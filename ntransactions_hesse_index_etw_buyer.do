* Load and filter dataset
use "$hh\Greix_PanelData_adjusted.dta", clear
drop if year_month < tm(2014m1)
drop if year_month > tm(2024m12)
keep if bundesland == "Hesse"
drop if market_segment != "ETW"
*drop if city != "Wiesbaden"

* Count transactions by city and month
bysort buyer_type_dummy year_half: gen n_transactions_buyer = _N
gen ln_transactions_buyer = ln(n_transactions_buyer)
    * -------- Step 2: Private --------
   preserve
    keep if buyer_type_dummy == 1
    collapse (mean) trans_private = ln_transactions_buyer, by(year_half)
    gen base_private = trans_private if year_half == th(2023h2)
    egen base_val_private = mean(base_private)
    gen trans_private_index = trans_private / base_val_private
	save private_states_transactions.dta, replace
   restore
   merge m:1 year_half using private_states_transactions.dta
   drop _merge

    * -------- Step 3: nprivate --------
   preserve
    keep if buyer_type_dummy == 0
    collapse (mean) trans_nprivate =ln_transactions_buyer, by(year_half)
    gen base_nprivate = trans_nprivate if year_half == th(2023h2)
    egen base_val_nprivate = mean(base_nprivate)
    gen trans_nprivate_index = trans_nprivate / base_val_nprivate
	save nprivate_transactions.dta, replace
   restore
   merge m:1 year_half using nprivate_transactions.dta

*plot
    twoway ///
        (line trans_private_index year_half, mcolor(blue) lpattern(solid)) ///
        (line trans_nprivate_index year_half, mcolor(red)), ///
        legend(label(1 "Private") label(2 "Non-private")position(6) ring(0) cols(1) size(small)) ytitle("Ln(transactions) index (2023h2 = 1)", size(small)) xtitle("Year half", size(small)) xline(127, lcolor(black) lpattern(dash)) text(1.2 126 "2023h2", size(small)) 
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\transaction_index_hesse_etw_buyer.pdf", replace


