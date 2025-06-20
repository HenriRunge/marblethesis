*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2012m1)
drop if year_month > tm(2024m12)

*Drop bundesländer

drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Bavaria"
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"

drop if market_segment != "MFH"

collapse (mean) ln_transactions_district_y, by(district_num_new year city_num bundesland)
tsset district_num_new year
gen d_ln_transaction_district = D.ln_transactions_district

* 2. Save 2018q2 base value per Bundesland in separate dataset
preserve
keep if year == 2021
keep district_num_new ln_transactions_district_y
rename ln_transactions_district_y base_val
save base_txn_values.dta, replace
restore

* 3. Merge base value back into dataset
merge m:1 district_num_new using base_txn_values.dta, nogen

* 4. Generate transaction index (2018q2 = 1)
gen trans_index = ln_transactions_district_y / base_val

egen trans_index_bundesland = mean(trans_index), by(bundesland year)
collapse(mean) trans_index_bundesland, by(bundesland year)

gen group = "other"
replace group = "NRW" if bundesland == "North_Rhine_Westphalia"

collapse(mean) trans_index_bundesland, by (group year)

*plot
    twoway ///
        (line trans_index year if group == "NRW", mcolor(blue) lpattern(solid)) ///
        (line trans_index year if group == "other", mcolor(red)), ///
        legend(label(1 "NRW") label(2 "Other States") position(6) ring(0) cols(1) size(small)) ytitle("Ln(transactions) index (2021 =1)", size(small)) xtitle("Year", size(small)) xline(2021, lcolor(black) lpattern(dash)) xline(2023, lcolor(black) lpattern(dash)) text(1.05 2020 "2021", size(small)) text(1.05 2022 "2023", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\transaction_index_nrw_mfh.pdf", replace
