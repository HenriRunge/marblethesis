* Load and filter dataset
use "$hh\Greix_PanelData_adjusted.dta", clear
drop if year_month < tm(2012m1)
drop if year_month > tm(2024m12)
keep if bundesland == "North_Rhine_Westphalia"
drop if market_segment != "MFH"
*Drop cities for which no data on buyer type exists
drop if city == "Dortmund" | city == "Düsseldorf" | city == "Münster" | city == "Köln"


*line n_transactions_bundesland year_half, by(bundesland)

* Count transactions by city and half
bysort buyer_type_dummy year: gen n_transactions_buyer = _N
gen ln_transactions_buyer = ln(n_transactions_buyer)

    * -------- Step 2: Private --------
   preserve
    keep if buyer_type_dummy == 1
    collapse (mean) trans_private = ln_transactions_buyer, by(year)
    gen base_private = trans_private if year == 2021
    egen base_val_private = mean(base_private)
    gen trans_private_index = trans_private / base_val_private
	save private_states_transactions.dta, replace
   restore
   merge m:1 year using private_states_transactions.dta
   drop _merge

    * -------- Step 3: private --------
   preserve
    keep if buyer_type_dummy == 0
    collapse (mean) trans_nprivate = ln_transactions_buyer, by(year)
    gen base_nprivate = trans_nprivate if year == 2021
    egen base_val_nprivate = mean(base_nprivate)
    gen trans_nprivate_index = trans_nprivate / base_val_nprivate
	save nprivate_transactions.dta, replace
   restore
   merge m:1 year using nprivate_transactions.dta

*plot
    twoway ///
        (line trans_private_index year, mcolor(blue) lpattern(solid)) ///
        (line trans_nprivate_index year, mcolor(red)), ///
        legend(label(1 "Private") label(2 "Non-private") position(4) ring(0) cols(1) size(small)) ytitle("Ln(transactions) index (2021 = 1)", size(small)) xtitle("Year", size(small)) xline(2021, lpattern(dash) lcolor(black)) xline(2023, lpattern(dash) lcolor(black)) text(1.02 2020 "2021", size(small)) text(1.02 2022 "2023", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\transaction_index_nrw_mfh_buyer.pdf", replace
