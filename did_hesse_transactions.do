eststo clear
*ETW full-----------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2018m1)
drop if year_month > tm(2024m12)

/*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"
*/
drop if market_segment != "ETW"

collapse (mean) ln_transactions_district_h, by(district_num_new year_half bundesland)
tsset district_num_new year_half
gen d_ln_transaction_district = D.ln_transactions_district

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (bundesland == "Hesse")

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_half - th(2024h1)

* Cap the window
gen rel_month_intro_capped = rel_month_intro if inrange(rel_month_intro, -12, 12)
drop if rel_month_intro_capped == .

* Create safe variable names for each month (avoid negative signs)
levelsof rel_month_intro_capped, local(months)

foreach m of local months {
    local cleanm = cond(`m' < 0, "mm" + string(abs(`m')), "m" + string(`m'))
    gen treat_intro_`cleanm' = (rel_month_intro == `m') * treat
}

* Drop baseline (-1)
drop treat_intro_mm1


* Run regression with city and month fixed effects
reghdfe ln_transactions_district_h treat_intro_m*, absorb(district_num_new year_half) vce(cluster district_num_new) 
* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6" treat_intro_m7 = "7" treat_intro_m8 = "8" treat_intro_m9 = "9" treat_intro_m10 = "10" treat_intro_m11 = "11" treat_intro_m12 = "12") ///
    xtitle("Year halfs from Policy Start") ytitle("Effect on ln(transactions)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_transactions_etw_full.pdf", replace
*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1 )/2), post
eststo model1


*MFH full-----------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2018m1)
drop if year_month > tm(2024m12)

/*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"
*/
drop if market_segment != "MFH"

collapse (mean) ln_transactions_district_h, by(district_num_new year_half bundesland)
tsset district_num_new year_half
gen d_ln_transaction_district = D.ln_transactions_district

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (bundesland == "Hesse")

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_half - th(2024h1)

* Cap the window
gen rel_month_intro_capped = rel_month_intro if inrange(rel_month_intro, -12, 12)
drop if rel_month_intro_capped == .

* Create safe variable names for each month (avoid negative signs)
levelsof rel_month_intro_capped, local(months)

foreach m of local months {
    local cleanm = cond(`m' < 0, "mm" + string(abs(`m')), "m" + string(`m'))
    gen treat_intro_`cleanm' = (rel_month_intro == `m') * treat
}

* Drop baseline (-1)
drop treat_intro_mm1


* Run regression with city and month fixed effects
reghdfe ln_transactions_district_h treat_intro_m*, absorb(district_num_new year_half) vce(cluster district_num_new) 
* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6" treat_intro_m7 = "7" treat_intro_m8 = "8" treat_intro_m9 = "9" treat_intro_m10 = "10" treat_intro_m11 = "11" treat_intro_m12 = "12") ///
    xtitle("Year halfs from Policy Start") ytitle("Effect on ln(transactions)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_transactions_mfh_full.pdf", replace
*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1)/2), post
eststo model2

*ETW reduced-----------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2018m1)
drop if year_month > tm(2024m12)

*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"

drop if market_segment != "ETW"

collapse (mean) ln_transactions_district_h, by(district_num_new year_half bundesland)
tsset district_num_new year_half
gen d_ln_transaction_district = D.ln_transactions_district

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (bundesland == "Hesse")

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_half - th(2024h1)

* Cap the window
gen rel_month_intro_capped = rel_month_intro if inrange(rel_month_intro, -12, 12)
drop if rel_month_intro_capped == .

* Create safe variable names for each month (avoid negative signs)
levelsof rel_month_intro_capped, local(months)

foreach m of local months {
    local cleanm = cond(`m' < 0, "mm" + string(abs(`m')), "m" + string(`m'))
    gen treat_intro_`cleanm' = (rel_month_intro == `m') * treat
}

* Drop baseline (-1)
drop treat_intro_mm1


* Run regression with city and month fixed effects
reghdfe ln_transactions_district_h treat_intro_m*, absorb(district_num_new year_half) vce(cluster district_num_new) 
* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6" treat_intro_m7 = "7" treat_intro_m8 = "8" treat_intro_m9 = "9" treat_intro_m10 = "10" treat_intro_m11 = "11" treat_intro_m12 = "12") ///
    xtitle("Year halfs from Policy Start") ytitle("Effect on ln(transactions)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_transactions_etw_reduced.pdf", replace
*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1)/2), post
eststo model3

*MFH reduced-----------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2018m1)
drop if year_month > tm(2024m12)

*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"

drop if market_segment != "MFH"

collapse (mean) ln_transactions_district_h, by(district_num_new year_half bundesland)
tsset district_num_new year_half
gen d_ln_transaction_district = D.ln_transactions_district

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (bundesland == "Hesse")

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_half - th(2024h1)

* Cap the window
gen rel_month_intro_capped = rel_month_intro if inrange(rel_month_intro, -12, 12)
drop if rel_month_intro_capped == .

* Create safe variable names for each month (avoid negative signs)
levelsof rel_month_intro_capped, local(months)

foreach m of local months {
    local cleanm = cond(`m' < 0, "mm" + string(abs(`m')), "m" + string(`m'))
    gen treat_intro_`cleanm' = (rel_month_intro == `m') * treat
}

* Drop baseline (-1)
drop treat_intro_mm1


* Run regression with city and month fixed effects
reghdfe ln_transactions_district_h treat_intro_m*, absorb(district_num_new year_half) vce(cluster district_num_new) 
* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6" treat_intro_m7 = "7" treat_intro_m8 = "8" treat_intro_m9 = "9" treat_intro_m10 = "10" treat_intro_m11 = "11" treat_intro_m12 = "12") xtitle("Year halfs from Policy Start") ytitle("Effect on ln(transactions)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_transactions_mfh_reduced.pdf", replace
*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1)/2), post
eststo model4

*Export-------------------------------------------------------------------------
esttab model1 model2 model3 model4 using hesse_results_2.tex, ///
	replace booktabs ///
		se star(* 0.10 ** 0.05 *** 0.01) ///
		noconstant