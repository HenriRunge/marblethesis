*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2014m1)
drop if year_month > tm(2024m12)
*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"

drop if market_segment != "ETW"

collapse (mean) ln_transactions_district_h, by(district_num_new year_half city_num bundesland)
tsset district_num_new year_half
gen d_ln_transaction_district = D.ln_transactions_district

* 2. Save 2018q2 base value per Bundesland in separate dataset
preserve
keep if year_half == th(2023h2)
keep district_num_new ln_transactions_district_h
rename ln_transactions_district_h base_val
save base_txn_values.dta, replace
restore

* 3. Merge base value back into dataset
merge m:1 district_num_new using base_txn_values.dta, nogen

* 4. Generate transaction index (2018q2 = 1)
gen trans_index = ln_transactions_district_h / base_val

egen trans_index_bundesland = mean(trans_index), by(bundesland year_half)
collapse(mean) trans_index_bundesland, by(bundesland year_half)

gen group = "other"
replace group = "Hesse" if bundesland == "Hesse"

collapse(mean) trans_index_bundesland, by (group year_half)
    


*plot
    twoway ///
        (line trans_index year_half if group == "Hesse", mcolor(blue) lpattern(solid)) ///
        (line trans_index year_half if group == "other", mcolor(red)), ///
        legend(label(1 "Hesse") label(2 "Other States")position(6) ring(0) cols(1) size(small)) ytitle("Ln(transactions) index (2023h2 = 1)", size(small)) xtitle("Year half", size(small)) xline(127, lcolor(black) lpattern(dash)) text(1.2 126 "2023h2", size(small)) 
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\transaction_index_hesse_etw.pdf", replace


