* Load and filter dataset
use "$hh\Greix_PanelData_adjusted.dta", clear
drop if year_month < tm(2012m1)
drop if year_month > tm(2025m3)
keep if bundesland == "North_Rhine_Westphalia"
*Drop cities with no rentstatus variable
drop if city == "Köln" 
drop if city == "Münster" 
drop if city == "Düsseldorf"
drop if market_segment != "ETW"


    * Compute mean price per rentstatus and half
    collapse (mean) mean_price = ln_price_sq, by(unrented year_half)
	
	gen mean_price_unrented = mean_price if unrented == 1
	gen mean_price_rented = mean_price if unrented == 0
	
    * Set base price for 2021q4
    gen base_price = .
    replace base_price = mean_price if year_half == th(2021h2)
    egen base_price_all = max(base_price), by(unrented)
    
    * Create price index
    gen price_index = mean_price / base_price_all
    
    * Separate series for graph
    gen price_index_unrented = price_index if unrented == 1
    gen price_index_rented = price_index if unrented == 0
    
    * Graph
    twoway (line price_index_unrented year_half, mcolor(blue) msymbol(o)) ///
           (line price_index_rented year_half, mcolor(red) msymbol(x)), ///
           legend(label(1 "Unrented") label(2 "Rented") position(4) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2021h2 = 1)", size(small)) xtitle("Year half", size(small)) xline(123, lpattern(dash) lcolor(black)) xline(126, lpattern(dash) lcolor(black)) text(1.01 122 "2021h2", size(small)) text(1.01 125 "2023h1", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_nrw_etw_rented.pdf", replace
