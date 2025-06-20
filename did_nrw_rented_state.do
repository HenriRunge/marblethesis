eststo clear
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2012m1)
drop if year_month > tm(2025m3)
keep if bundesland == "North_Rhine_Westphalia"

drop if market_segment != "ETW"

* Compute mean price per rentstatus and half
    preserve
	collapse (mean) mean_price = ln_price, by(unrented year_half district_num_new city_num bundesland)
    
    * Set base price for 2023h2
    gen base_price = .
    replace base_price = mean_price if year_half == th(2021h2)
    egen base_price_all = max(base_price), by(unrented)
    
    * Create price index
    gen price_index = mean_price / base_price_all
	save "index.dta", replace
	restore
   merge m:1 year_half unrented district_num_new using index.dta
   drop _merge
	
* --------------------------------------
* 1. Define Treatment Group (NRW vs. Other)
* --------------------------------------
gen treat = (unrented == 1)

* --------------------------------------
* 2. Part A: Event study around policy introduction (Jan 2022)
* --------------------------------------

* Define time to policy intro (January 2022)
gen rel_month_intro = year_half - th(2021h2)

* Cap the window
gen rel_month_intro_capped = rel_month_intro if inrange(rel_month_intro, -6, 6)
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
reghdfe ln_price treat_intro_m* area_living area_living_sq i.location_quality_num i.construction_year_cat_num new_build unrented, absorb(district_num_new year_half) vce(cluster district_num_new) 

* Plot results
coefplot, keep(treat_intro_m*) rename(treat_intro_mm6 = "-6" treat_intro_mm5 = "-5" treat_intro_mm4 = "-4" treat_intro_mm3 = "-3" treat_intro_mm2 = "-2" treat_intro_m0 = "0" treat_intro_m1 = "1" treat_intro_m2 = "2" treat_intro_m3 = "3" treat_intro_m4 = "4" treat_intro_m5 = "5" treat_intro_m6 = "6") xline(8, lcolor(black%30) lpattern(dash)) ///
    xtitle("Year halfs from Policy Start") ytitle("Effect on ln(price)") ///
    vertical
	
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\coeffplot_nrw_rented_state.pdf", replace

*summarize results using lincom
xlincom((treat_intro_m0 + treat_intro_m1 + treat_intro_m2)/3), post
eststo model1


*Export-------------------------------------------------------------------------
esttab model1 using nrw_results_rented_state.tex, ///
	replace booktabs ///
		se star(* 0.10 ** 0.05 *** 0.01) ///
		noconstant