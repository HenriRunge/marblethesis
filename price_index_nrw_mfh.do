*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2012m1)
drop if year_month > tm(2025m3)

*drop market segment
drop if market_segment != "MFH"

*Create mean price per city per month
egen mean_price = mean(ln_price_sq), by(city_num year_quarter)

* Create average price per bundesland per month
egen mean_price_bundesland = mean (ln_price_sq), by(bundesland year_quarter)

*Create mean price index per city per month and then average at bundesland level
preserve
keep if year_quarter == tq(2021q4)
collapse (mean) base_price=mean_price, by(city_num)
save base_prices.dta, replace
restore

merge m:1 city_num using base_prices.dta
drop _merge

*Create mean price index per city per month and then average at bundesland level
preserve
keep if year_quarter == tq(2021q4)
collapse (mean) base_price_bundesland=mean_price_bundesland, by(bundesland)
save base_prices_bundesland.dta, replace
restore

merge m:1 bundesland using base_prices_bundesland.dta
drop _merge

gen price_index = (mean_price/base_price)

gen price_index_bundesland = (mean_price_bundesland/base_price_bundesland)


*Create price index for bundesland of interest and average for the rest
preserve
gen price_other = price_index if bundesland != "North_Rhine_Westphalia"
collapse (mean) price_other, by(year_quarter)
save other_states.dta, replace
restore
merge m:1 year_quarter using other_states.dta
drop _merge
preserve
keep if bundesland == "North_Rhine_Westphalia"
collapse (mean) price_nrw=price_index, by(year_quarter)
save nrw_prices.dta, replace
restore
merge m:1 year_quarter using nrw_prices.dta

*Plot the two indices
twoway (line price_nrw year_quarter, mcolor(blue) msymbol(o)) (line price_other year_quarter, mcolor(red) msymbol(x)), legend(label(1 "NRW") label(2 "Other states") position(6) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2021q4 = 1)", size(small)) xtitle("Quarter", size(small)) xline(247, lpattern(dash) lcolor(black)) xline(252, lpattern(dash) lcolor(black)) text(0.95 245 "2021q4", size(small)) text(0.95 250 "2023q2", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_nrw_mfh_full_control.pdf", replace

twoway ///
    (line price_index_bundesland year_quarter if bundesland == "North_Rhine_Westphalia", lcolor(blue) lpattern(solid)) ///
    (line price_index_bundesland year_quarter if bundesland == "Hesse", lcolor(red%70) lpattern(dash)) ///
    (line price_index_bundesland year_quarter if bundesland == "Baden_Württemberg", lcolor(orange)) ///
	(line price_index_bundesland year_quarter if bundesland == "Bavaria", lcolor(yellow)) ///
	  (line price_index_bundesland year_quarter if bundesland == "Saxony", lcolor(pink) lpattern(dash)) ///
    (line price_index_bundesland year_quarter if bundesland == "Thuringia", lcolor(green) lpattern(dot)) ///
    (line price_index_bundesland year_quarter if bundesland == "Brandenburg", lcolor(orange)) ///
	(line price_index_bundesland year_quarter if bundesland == "Schleswig_Holstein", lcolor(black%70) lpattern(dash)) ///
	(line price_index_bundesland year_quarter if bundesland == "Berlin", lcolor(green)) ///
	(line price_index_bundesland year_quarter if bundesland == "Hamburg", lcolor(black%45)), ///
    legend(order(1 "NRW" 2 "Hesse" 3 "Baden-Württemberg" 4 "Bavaria" 5 "Saxony" 6 "Thuringia" 7 "Brandenburg" 8 "Schleswig-Holstein" 9 "Berlin" 10 "Hamburg") position(11) ring(0) cols(2) size(small)) ytitle("Ln(price/sqm) index (2021q4 = 1)", size(small)) xtitle("Quarter", size(small)) xline(247, lpattern(dash) lcolor(black)) xline(252, lpattern(dash) lcolor(black)) text(1.3 245 "2021q4", size(small)) text(1.3 250 "2023q2", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_nrw_mfh_comparison.pdf", replace

twoway ///
    (line price_index_bundesland year_quarter if bundesland == "North_Rhine_Westphalia", lcolor(blue) lpattern(solid)) ///
    (line price_index_bundesland year_quarter if bundesland == "Hesse", lcolor(red%70) lpattern(dash)) ///
    (line price_index_bundesland year_quarter if bundesland == "Baden_Württemberg", lcolor(orange)) ///
	(line price_index_bundesland year_quarter if bundesland == "Bavaria", lcolor(yellow)) ///
	(line price_index_bundesland year_quarter if bundesland == "Berlin", lcolor(green)), ///
    legend(order(1 "NRW" 2 "Hesse" 3 "Baden_Württemberg" 4 "Bavaria" 5 "Berlin") position(6) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2021q4 = 1)", size(small)) xtitle("Quarter", size(small)) xline(247, lpattern(dash) lcolor(black)) xline(252, lpattern(dash) lcolor(black)) text(0.95 245 "2021q4", size(small)) text(0.95 250 "2023q2", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_nrw_mfh_comparison_reduced.pdf", replace
	
					twoway ///
    (line price_index year_quarter if city == "Münster", lcolor(blue) lpattern(solid)) ///
    (line price_index year_quarter if city == "Bocholt", lcolor(red) lpattern(dash)) ///
    (line price_index year_quarter if city == "Köln", lcolor(orange)) ///
	 (line price_index year_quarter if city == "Duisburg", lcolor(orange)) ///
	(line price_index year_quarter if city == "Dortmund", lcolor(black)) ///
	(line price_index year_quarter if city == "Rhein_Erft_Kreis", lcolor(blue) lpattern(dash)) ///
	(line price_index year_quarter if city == "Bonn", lcolor(brown)) ///
	(line price_index year_quarter if city == "Düsseldorf", lcolor(yellow)) ///
	(line price_index year_quarter if city == "Kreis_Mettmann", lcolor(green)), ///
    legend(order(1 "Münster" 2 "Bocholt" 3 "Köln" 4 "Duisburg" 5 "Dortmund" 6 "REK" 7 "Bonn" 8 "Düsseldorf" 9 "Kreis Mettmann") position(4) ring(0) cols(3) size(small)) ytitle("Ln(price/sqm) index (2021q4 = 1)", size(small)) xtitle("Quarter", size(small)) xline(247, lpattern(dash) lcolor(black)) xline(252, lpattern(dash) lcolor(black)) text(1.12 245 "2021q4", size(small)) text(1.12 250 "2023q2", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_nrw_mfh_comparison_cities.pdf", replace
	
*Reduced with Hamburg------------------------------------------------------------------------	
	
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2012m1)
drop if year_month > tm(2025m3)

*drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"

*drop market segment
drop if market_segment != "MFH"

*Create mean price per city per month
egen mean_price = mean(ln_price_sq), by(city_num year_quarter)

* Create average price per bundesland per month
egen mean_price_bundesland = mean (ln_price_sq), by(bundesland year_quarter)

*Create mean price index per city per month and then average at bundesland level
preserve
keep if year_quarter == tq(2021q4)
collapse (mean) base_price=mean_price, by(city_num)
save base_prices.dta, replace
restore

merge m:1 city_num using base_prices.dta
drop _merge

*Create mean price index per city per month and then average at bundesland level
preserve
keep if year_quarter == tq(2021q4)
collapse (mean) base_price_bundesland=mean_price_bundesland, by(bundesland)
save base_prices_bundesland.dta, replace
restore

merge m:1 bundesland using base_prices_bundesland.dta
drop _merge

gen price_index = (mean_price/base_price)

gen price_index_bundesland = (mean_price_bundesland/base_price_bundesland)


*Create price index for bundesland of interest and average for the rest
preserve
gen price_other = price_index if bundesland != "North_Rhine_Westphalia"
collapse (mean) price_other, by(year_quarter)
save other_states.dta, replace
restore
merge m:1 year_quarter using other_states.dta
drop _merge
preserve
keep if bundesland == "North_Rhine_Westphalia"
collapse (mean) price_nrw=price_index, by(year_quarter)
save nrw_prices.dta, replace
restore
merge m:1 year_quarter using nrw_prices.dta

*Plot the two indices
twoway (line price_nrw year_quarter, mcolor(blue) msymbol(o)) (line price_other year_quarter, mcolor(red) msymbol(x)), legend(label(1 "NRW") label(2 "Other states") position(6) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2021q4 = 1)", size(small)) xtitle("Quarter", size(small)) xline(247, lpattern(dash) lcolor(black)) xline(252, lpattern(dash) lcolor(black)) text(0.95 245 "2021q4", size(small)) text(0.95 250 "2023q2", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_nrw_mfh_reduced_control_w_Hamburg.pdf", replace

*Reduced without Hamburg------------------------------------------------------------------------	
	
*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2012m1)
drop if year_month > tm(2025m3)

drop if bundesland == "Hamburg"
drop if bundesland == "Saxony"
*drop if bundesland == "Baden_Württemberg" 
*drop if bundesland == "Hesse"
*drop if bundesland == "Berlin"
drop if bundesland == "Brandenburg"
drop if bundesland == "Thuringia"
drop if bundesland == "Schleswig_Holstein"

*drop market segment
drop if market_segment != "MFH"

*Create mean price per city per month
egen mean_price = mean(ln_price_sq), by(city_num year_quarter)

* Create average price per bundesland per month
egen mean_price_bundesland = mean (ln_price_sq), by(bundesland year_quarter)

*Create mean price index per city per month and then average at bundesland level
preserve
keep if year_quarter == tq(2021q4)
collapse (mean) base_price=mean_price, by(city_num)
save base_prices.dta, replace
restore

merge m:1 city_num using base_prices.dta
drop _merge

*Create mean price index per city per month and then average at bundesland level
preserve
keep if year_quarter == tq(2021q4)
collapse (mean) base_price_bundesland=mean_price_bundesland, by(bundesland)
save base_prices_bundesland.dta, replace
restore

merge m:1 bundesland using base_prices_bundesland.dta
drop _merge

gen price_index = (mean_price/base_price)

gen price_index_bundesland = (mean_price_bundesland/base_price_bundesland)


*Create price index for bundesland of interest and average for the rest
preserve
gen price_other = price_index if bundesland != "North_Rhine_Westphalia"
collapse (mean) price_other, by(year_quarter)
save other_states.dta, replace
restore
merge m:1 year_quarter using other_states.dta
drop _merge
preserve
keep if bundesland == "North_Rhine_Westphalia"
collapse (mean) price_nrw=price_index, by(year_quarter)
save nrw_prices.dta, replace
restore
merge m:1 year_quarter using nrw_prices.dta

*Plot the two indices
twoway (line price_nrw year_quarter, mcolor(blue) msymbol(o)) (line price_other year_quarter, mcolor(red) msymbol(x)), legend(label(1 "NRW") label(2 "Other states") position(6) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2021q4 = 1)", size(small)) xtitle("Quarter", size(small)) xline(247, lpattern(dash) lcolor(black)) xline(252, lpattern(dash) lcolor(black)) text(0.95 245 "2021q4", size(small)) text(0.95 250 "2023q2", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_nrw_mfh_reduced_control_wo_Hamburg.pdf", replace


	

