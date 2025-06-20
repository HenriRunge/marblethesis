* Load and filter dataset
use "$hh\Greix_PanelData_adjusted.dta", clear
drop if year_month < tm(2014m1)
drop if year_month > tm(2024m12)
keep if bundesland == "Hesse"
drop if market_segment != "ETW"
*drop if city == "Wiesbaden"

*Does not exist for MFH and EFH 


* Count transactions by city and month
bysort unrented year_half: gen n_transactions_buyer = _N
gen ln_transactions_buyer = ln(n_transactions_buyer)


    * -------- Step 2: rented --------
   preserve
    keep if unrented == 0
    collapse (sum) trans_rented = ln_transactions_buyer, by(year_half)
    gen base_rented = trans_rented if year_half == th(2023h2)
    egen base_val_rented = mean(base_rented)
    gen trans_rented_index = trans_rented / base_val_rented
	save rented_states_transactions.dta, replace
   restore
   merge m:1 year_half using rented_states_transactions.dta
   drop _merge

    * -------- Step 3: unrented --------
   preserve
    keep if unrented == 1
    collapse (sum) trans_unrented = ln_transactions_buyer, by(year_half)
    gen base_unrented = trans_unrented if year_half == th(2023h2)
    egen base_val_unrented = mean(base_unrented)
    gen trans_unrented_index = trans_unrented / base_val_unrented
	save unrented_transactions.dta, replace
   restore
   merge m:1 year_half using unrented_transactions.dta

*plot
    twoway ///
        (line trans_unrented_index year_half, mcolor(blue) lpattern(solid)) ///
        (line trans_rented_index year_half, mcolor(red)), ///
        legend(label(1 "Unrented") label(2 "Rented")position(12) ring(0) cols(1) size(small)) ytitle("Ln(transactions) index (2023h2 = 1)", size(small)) xtitle("Year half", size(small)) xline(127, lcolor(black) lpattern(dash)) text(3 126 "2023h2", size(small)) 
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\transaction_index_hesse_etw_unrented.pdf", replace


