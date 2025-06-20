* Load and filter dataset
use "$hh\Greix_PanelData_adjusted.dta", clear
drop if year_month < tm(2008m7)
drop if year_month > tm(2024m12)
keep if bundesland == "Bavaria"


* Count transactions by city and month
bysort unrented year_half: gen n_transactions_buyer = _N
gen ln_transactions_buyer = ln(n_transactions_buyer)

    * -------- Step 2: Private --------
   preserve
    keep if unrented == 1
    collapse (sum) trans_other = n_transactions_buyer, by(year_half)
    gen base_other = trans_other if year_half == th(2018h1)
    egen base_val_other = mean(base_other)
    gen trans_other_index = trans_other / base_val_other
	save other_states_transactions.dta, replace
   restore
   merge m:1 year_half using other_states_transactions.dta
   drop _merge

    * -------- Step 3: bavaria --------
   preserve
    keep if unrented == 0
    collapse (sum) trans_bavaria = n_transactions_buyer, by(year_half)
    gen base_bavaria = trans_bavaria if year_half == th(2018h1)
    egen base_val_bavaria = mean(base_bavaria)
    gen trans_bavaria_index = trans_bavaria / base_val_bavaria
	save bavaria_transactions.dta, replace
   restore
   merge m:1 year_half using bavaria_transactions.dta

*plot
    twoway ///
        (line trans_other_index year_half, mcolor(blue) lpattern(solid)) ///
        (line trans_bavaria_index year_half, mcolor(red)), ///
        legend(label(1 "Unrented") label(2 "Rented") position(4) ring(0) cols(1) size(small)) ytitle("Ln(transactions) index (2018h1 = 1)", size(small)) xtitle("Year half", size(small)) xline(116, lpattern(dash) lcolor(black)) xline(121, lpattern(dash) lcolor(black)) text(2 114 "2018h1", size(small)) text(2 119 "2020h2", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\transaction_index_bavaria_rented.pdf", replace

