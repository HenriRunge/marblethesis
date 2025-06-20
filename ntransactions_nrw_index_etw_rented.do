* Load and filter dataset
use "$hh\Greix_PanelData_adjusted.dta", clear
drop if year_month < tm(2012m1)
drop if year_month > tm(2024m12)
keep if bundesland == "North_Rhine_Westphalia"
drop if city == "Köln" 
drop if city == "Münster" 
drop if city == "Düsseldorf"
drop if market_segment != "ETW"


* Count transactions by city and month
bysort unrented year: gen n_transactions_buyer = _N
gen ln_transactions_buyer = ln(n_transactions_buyer)

    * -------- Step 2: unrented --------
   preserve
    keep if unrented == 1
    collapse (sum) trans_unrented = ln_transactions_buyer, by(year)
    gen base_unrented = trans_unrented if year == 2021
    egen base_val_unrented = mean(base_unrented)
    gen trans_unrented_index = trans_unrented / base_val_unrented
	save unrented_states_transactions.dta, replace
   restore
   merge m:1 year using unrented_states_transactions.dta
   drop _merge

    * -------- Step 3: rented --------
   preserve
    keep if unrented == 0
    collapse (sum) trans_rented = ln_transactions_buyer, by(year)
    gen base_rented = trans_rented if year == 2021
    egen base_val_rented = mean(base_rented)
    gen trans_rented_index = trans_rented / base_val_rented
	save rented_transactions.dta, replace
   restore
   merge m:1 year using rented_transactions.dta

*plot
    twoway ///
        (line trans_unrented_index year, mcolor(blue) lpattern(solid)) ///
        (line trans_rented_index year, mcolor(red)), ///
        legend(label(1 "Unrented") label(2 "Rented")position(6) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2021 = 1)", size(small)) xtitle("Year", size(small)) xline(2021, lpattern(dash) lcolor(black)) xline(2023, lpattern(dash) lcolor(black)) text(1.2 2020 "2021", size(small)) text(1.2 2022 "2023", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\transaction_index_nrw_etw_unrented.pdf", replace
