eststo clear
*ETW full-----------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2021m4)
drop if year_month > tm(2025m3)
/*
*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"
*/
drop if market_segment != "ETW"

* --------------------------------------
* 0. Setup & Date formatting
* -------------------------------------

gen contract_month = mofd(contract_date)
format contract_month %tm

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (bundesland == "Hesse")

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_quarter - tq(2024q2)


* Create safe variable names for each month (avoid negative signs)
levelsof rel_month_intro, local(months)

foreach m of local months {
    local cleanm = cond(`m' < 0, "mm" + string(abs(`m')), "m" + string(`m'))
    gen treat_intro_`cleanm' = (rel_month_intro == `m') * treat
}

* Drop baseline (-1)
drop treat_intro_mm1


* Run regression with city and month fixed effects
reghdfe ln_price treat_intro_m* area_living area_living_sq i.location_quality_num i.construction_year_cat_num new_build, absorb(district_num_new year_quarter) vce(cluster city_num) 

* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6" treat_intro_m7 = "7" treat_intro_m8 = "8" treat_intro_m9 = "9" treat_intro_m10 = "10" treat_intro_m11 = "11" treat_intro_m12 = "12") ///
    xtitle("Quarters from Policy Start") ytitle("Effect on ln(price)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_full_etw_city.pdf", replace

*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1 + treat_intro_m2 + treat_intro_m3)/4), post
eststo model1

*EFH full-----------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2021m4)
drop if year_month > tm(2025m3)
/*
*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"
*/
drop if market_segment != "EFH"

* --------------------------------------
* 0. Setup & Date formatting
* -------------------------------------

gen contract_month = mofd(contract_date)
format contract_month %tm

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (bundesland == "Hesse")

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_quarter - tq(2024q2)


* Create safe variable names for each month (avoid negative signs)
levelsof rel_month_intro, local(months)

foreach m of local months {
    local cleanm = cond(`m' < 0, "mm" + string(abs(`m')), "m" + string(`m'))
    gen treat_intro_`cleanm' = (rel_month_intro == `m') * treat
}

* Drop baseline (-1)
drop treat_intro_mm1


* Run regression with city and month fixed effects
reghdfe ln_price treat_intro_m* area_living area_living_sq i.location_quality_num i.construction_year_cat_num new_build, absorb(district_num_new year_quarter) vce(cluster city_num) 

* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6" treat_intro_m7 = "7" treat_intro_m8 = "8" treat_intro_m9 = "9" treat_intro_m10 = "10" treat_intro_m11 = "11" treat_intro_m12 = "12") ///
    xtitle("Quarters from Policy Start") ytitle("Effect on ln(price)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_full_efh_city.pdf", replace

*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1 + treat_intro_m2 + treat_intro_m3)/4), post
eststo model2

*MFH full-----------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2021m4)
drop if year_month > tm(2025m3)
/*
*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"
*/
drop if market_segment != "MFH"

* --------------------------------------
* 0. Setup & Date formatting
* -------------------------------------

gen contract_month = mofd(contract_date)
format contract_month %tm

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (bundesland == "Hesse")

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_quarter - tq(2024q2)


* Create safe variable names for each month (avoid negative signs)
levelsof rel_month_intro, local(months)

foreach m of local months {
    local cleanm = cond(`m' < 0, "mm" + string(abs(`m')), "m" + string(`m'))
    gen treat_intro_`cleanm' = (rel_month_intro == `m') * treat
}

* Drop baseline (-1)
drop treat_intro_mm1


* Run regression with city and month fixed effects
reghdfe ln_price treat_intro_m* area_living area_living_sq i.location_quality_num i.construction_year_cat_num new_build, absorb(district_num_new year_quarter) vce(cluster city_num) 

* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6" treat_intro_m7 = "7" treat_intro_m8 = "8" treat_intro_m9 = "9" treat_intro_m10 = "10" treat_intro_m11 = "11" treat_intro_m12 = "12") ///
    xtitle("Quarters from Policy Start") ytitle("Effect on ln(price)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_full_mfh_city.pdf", replace

*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1 + treat_intro_m2 + treat_intro_m3)/4), post
eststo model3

*ETW reduced-----------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2021m4)
drop if year_month > tm(2025m3)

*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"

drop if market_segment != "ETW"

* --------------------------------------
* 0. Setup & Date formatting
* -------------------------------------

gen contract_month = mofd(contract_date)
format contract_month %tm

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (bundesland == "Hesse")

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_quarter - tq(2024q2)


* Create safe variable names for each month (avoid negative signs)
levelsof rel_month_intro, local(months)

foreach m of local months {
    local cleanm = cond(`m' < 0, "mm" + string(abs(`m')), "m" + string(`m'))
    gen treat_intro_`cleanm' = (rel_month_intro == `m') * treat
}

* Drop baseline (-1)
drop treat_intro_mm1


* Run regression with city and month fixed effects
reghdfe ln_price treat_intro_m* area_living area_living_sq i.location_quality_num i.construction_year_cat_num new_build, absorb(district_num_new year_quarter) vce(cluster city_num) 

* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6" treat_intro_m7 = "7" treat_intro_m8 = "8" treat_intro_m9 = "9" treat_intro_m10 = "10" treat_intro_m11 = "11" treat_intro_m12 = "12") ///
    xtitle("Quarters from Policy Start") ytitle("Effect on ln(price)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_reduced_etw_city.pdf", replace

*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1 + treat_intro_m2 + treat_intro_m3)/4), post
eststo model4

*EFH reduced-----------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2021m4)
drop if year_month > tm(2025m3)

*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"

drop if market_segment != "EFH"

* --------------------------------------
* 0. Setup & Date formatting
* -------------------------------------

gen contract_month = mofd(contract_date)
format contract_month %tm

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (bundesland == "Hesse")

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_quarter - tq(2024q2)


* Create safe variable names for each month (avoid negative signs)
levelsof rel_month_intro, local(months)

foreach m of local months {
    local cleanm = cond(`m' < 0, "mm" + string(abs(`m')), "m" + string(`m'))
    gen treat_intro_`cleanm' = (rel_month_intro == `m') * treat
}

* Drop baseline (-1)
drop treat_intro_mm1


* Run regression with city and month fixed effects
reghdfe ln_price treat_intro_m* area_living area_living_sq i.location_quality_num i.construction_year_cat_num new_build, absorb(district_num_new year_quarter) vce(cluster city_num) 

* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6" treat_intro_m7 = "7" treat_intro_m8 = "8" treat_intro_m9 = "9" treat_intro_m10 = "10" treat_intro_m11 = "11" treat_intro_m12 = "12") ///
    xtitle("Quarters from Policy Start") ytitle("Effect on ln(price)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_reduced_efh_city.pdf", replace

*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1 + treat_intro_m2 + treat_intro_m3)/4), post
eststo model5

*MFH reduced-----------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2021m4)
drop if year_month > tm(2025m3)

*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"

drop if market_segment != "MFH"

* --------------------------------------
* 0. Setup & Date formatting
* -------------------------------------

gen contract_month = mofd(contract_date)
format contract_month %tm

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (bundesland == "Hesse")

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_quarter - tq(2024q2)


* Create safe variable names for each month (avoid negative signs)
levelsof rel_month_intro, local(months)

foreach m of local months {
    local cleanm = cond(`m' < 0, "mm" + string(abs(`m')), "m" + string(`m'))
    gen treat_intro_`cleanm' = (rel_month_intro == `m') * treat
}

* Drop baseline (-1)
drop treat_intro_mm1


* Run regression with city and month fixed effects
reghdfe ln_price treat_intro_m* area_living area_living_sq i.location_quality_num i.construction_year_cat_num new_build, absorb(district_num_new year_quarter) vce(cluster city_num) 

* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6" treat_intro_m7 = "7" treat_intro_m8 = "8" treat_intro_m9 = "9" treat_intro_m10 = "10" treat_intro_m11 = "11" treat_intro_m12 = "12") ///
    xtitle("Quarters from Policy Start") ytitle("Effect on ln(price)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_reduced_mfh_city.pdf", replace

*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1 + treat_intro_m2 + treat_intro_m3)/4), post
eststo model6

*Export-------------------------------------------------------------------------
esttab model1 model2 model3 model4 model5 model6 using hesse_results_city.tex, ///
	replace booktabs ///
		se star(* 0.10 ** 0.05 *** 0.01) ///
		noconstant ///
		

	
	