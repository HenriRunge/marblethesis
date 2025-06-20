*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2008m7)
drop if year_month > tm(2024m12)

*drop market segment
drop if market_segment != "ETW"


*Create mean price per city per month
egen mean_price = mean(ln_price_sq), by(city_num year_quarter)

* Create average price per bundesland per month
egen mean_price_bundesland = mean (ln_price_sq), by(bundesland year_quarter)

*Create mean price index per city per month and then average at bundesland level
preserve
keep if year_quarter == tq(2018q2)
collapse (mean) base_price=mean_price, by(city_num)
save base_prices.dta, replace
restore

merge m:1 city_num using base_prices.dta
drop _merge

*Create mean price index per city per month and then average at bundesland level
preserve
keep if year_quarter == tq(2018q2)
collapse (mean) base_price_bundesland=mean_price_bundesland, by(bundesland)
save base_prices_bundesland.dta, replace
restore

merge m:1 bundesland using base_prices_bundesland.dta
drop _merge

gen price_index = (mean_price/base_price)

gen price_index_bundesland = (mean_price_bundesland/base_price_bundesland)


*Create price index for bundesland of interest and average for the rest
preserve
gen price_other = price_index_bundesland if bundesland != "Bavaria"
collapse (mean) price_other, by(year_quarter)
save other_states.dta, replace
restore
merge m:1 year_quarter using other_states.dta
drop _merge
preserve
keep if bundesland == "Bavaria"
collapse (mean) price_bavaria=price_index_bundesland, by(year_quarter)
save bavaria_prices.dta, replace
restore
merge m:1 year_quarter using bavaria_prices.dta

*Plot the two indices
twoway (line price_bavaria year_quarter, mcolor(blue) msymbol(o)) (line price_other year_quarter, mcolor(red) msymbol(x)), legend(label(1 "Bavaria") label(2 "Other states") position(4) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2018q2 = 1)", size(small)) xtitle("Quarter", size(small)) xline(233, lpattern(dash) lcolor(black)) xline(244, lpattern(dash) lcolor(black)) text(1.05 230 "2018q2", size(small)) text(1.05 241 "2020q4", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_bavaria_full_controls.pdf", replace


twoway ///
    (line price_index_bundesland year_quarter if bundesland == "North_Rhine_Westphalia", lcolor(yellow) lpattern(solid)) ///
    (line price_index_bundesland year_quarter if bundesland == "Hesse", lcolor(red%70) lpattern(dash)) ///
    (line price_index_bundesland year_quarter if bundesland == "Baden_Württemberg", lcolor(orange)) ///
	(line price_index_bundesland year_quarter if bundesland == "Bavaria", lcolor(blue)) ///
	  (line price_index_bundesland year_quarter if bundesland == "Saxony", lcolor(pink) lpattern(dash)) ///
    (line price_index_bundesland year_quarter if bundesland == "Thuringia", lcolor(green) lpattern(dot)) ///
    (line price_index_bundesland year_quarter if bundesland == "Brandenburg", lcolor(orange)) ///
	(line price_index_bundesland year_quarter if bundesland == "Schleswig_Holstein", lcolor(black%70) lpattern(dash)) ///
	(line price_index_bundesland year_quarter if bundesland == "Berlin", lcolor(green)) ///
	(line price_index_bundesland year_quarter if bundesland == "Hamburg", lcolor(black%45)), ///
    legend(order(1 "NRW" 2 "Hesse" 3 "Baden-Württemberg" 4 "Bavaria" 5 "Saxony" 6 "Thuringia" 7 "Brandenburg" 8 "Schleswig-Holstein" 9 "Berlin" 10 "Hamburg")) ///
    ytitle("Ln(price/sqm) index (2018q2 = 1)", size(small)) xtitle("Quarter", size(small)) xline(233, lpattern(dash) lcolor(black)) xline(244, lpattern(dash) lcolor(black)) text(1.1 228 "2018q2", size(small)) text(1.1 239 "2020q4", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_bavaria_comparison.pdf", replace
	
	
	
	twoway ///
    (line price_index_bundesland year_quarter if bundesland == "Hesse", lcolor(red) lpattern(dash)) ///
    (line price_index_bundesland year_quarter if bundesland == "Baden_Württemberg", lcolor(orange)) ///
	(line price_index_bundesland year_quarter if bundesland == "Bavaria", lcolor(blue)), ///
    legend(order(1 "Hesse" 2 "Baden-Württemberg" 3 "Bavaria")) ///
    xline(233, lpattern(dash) lcolor(black)) xline(244, lpattern(dash) lcolor(black)) ///
	  ytitle("Ln(price/sqm)index (2018q2 = 1)", size(small)) xtitle("Quarter", size(small)) xline(233, lpattern(dash) lcolor(black)) xline(244, lpattern(dash) lcolor(black)) text(1.05 228 "2018q2", size(small)) text(1.05 239 "2020q4", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_bavaria_comparison_reduced.pdf", replace
	
	
**Reduced-----------------------------------------------------------------------	
	*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2008m7)
drop if year_month > tm(2024m12)

*drop market segment
drop if market_segment != "ETW"


	drop if bundesland == "Saxony"
	drop if bundesland == "Thuringia"
	drop if bundesland == "Brandenburg"
	drop if bundesland == "Berlin"
	drop if bundesland == "North_Rhine_Westphalia"
	drop if bundesland == "Schleswig_Holstein"
	drop if bundesland == "Hamburg"
	
*Create mean price per city per month
egen mean_price = mean(ln_price_sq), by(city_num year_quarter)

* Create average price per bundesland per month
egen mean_price_bundesland = mean (ln_price_sq), by(bundesland year_quarter)

*Create mean price index per city per month and then average at bundesland level
preserve
keep if year_quarter == tq(2018q2)
collapse (mean) base_price=mean_price, by(city_num)
save base_prices.dta, replace
restore

merge m:1 city_num using base_prices.dta
drop _merge

*Create mean price index per city per month and then average at bundesland level
preserve
keep if year_quarter == tq(2018q2)
collapse (mean) base_price_bundesland=mean_price_bundesland, by(bundesland)
save base_prices_bundesland.dta, replace
restore

merge m:1 bundesland using base_prices_bundesland.dta
drop _merge

gen price_index = (mean_price/base_price)

gen price_index_bundesland = (mean_price_bundesland/base_price_bundesland)


*Create price index for bundesland of interest and average for the rest
preserve
gen price_other = price_index_bundesland if bundesland != "Bavaria"
collapse (mean) price_other, by(year_quarter)
save other_states.dta, replace
restore
merge m:1 year_quarter using other_states.dta
drop _merge
preserve
keep if bundesland == "Bavaria"
collapse (mean) price_bavaria=price_index_bundesland, by(year_quarter)
save bavaria_prices.dta, replace
restore
merge m:1 year_quarter using bavaria_prices.dta

	*Plot the two indices
twoway (line price_bavaria year_quarter, mcolor(blue) msymbol(o)) (line price_other year_quarter, mcolor(red) msymbol(x)), legend(label(1 "Bavaria") label(2 "Other states") position(4) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2018q2 = 1)", size(small)) xtitle("Quarter", size(small)) xline(233, lpattern(dash) lcolor(black)) xline(244, lpattern(dash) lcolor(black)) text(1.05 230 "2018q2", size(small)) text(1.05 241 "2020q4", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_bavaria_reduced_controls.pdf", replace
