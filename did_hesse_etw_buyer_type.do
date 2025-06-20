eststo clear
*ETW----------------------------------------------------------------------------
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2018m1)
drop if year_month > tm(2025m3)
keep if bundesland == "Hesse"

drop if market_segment != "ETW"

* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (buyer_type_dummy == 1)

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_quarter - tq(2024q2)

* Cap the window
gen rel_month_intro_capped = rel_month_intro if inrange(rel_month_intro, -12, 6)
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
reghdfe ln_price treat_intro_m* area_living area_living_sq i.location_quality_num i.construction_year_cat_num new_build buyer_type_dummy, absorb(district_num_new year_quarter) vce(cluster district_num_new) 

* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm12 = "-12" treat_intro_mm11 = "-11" treat_intro_mm10 = "-10" treat_intro_mm9 = "-9" treat_intro_mm8 = "-8" treat_intro_mm7 = "-7" treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6") ///
    xtitle("Quarters from Policy Start") ytitle("Effect on ln(price)") ///
    vertical
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_hesse_etw_buyer.pdf", replace	

*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1 + treat_intro_m2 + treat_intro_m3)/4), post
eststo model1

*Export-------------------------------------------------------------------------
esttab model1 using hesse_results_3.tex, ///
	replace booktabs ///
		se star(* 0.10 ** 0.05 *** 0.01) ///
		noconstant