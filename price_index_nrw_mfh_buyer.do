* Load and filter dataset
use "$hh\Greix_PanelData_adjusted.dta", clear
drop if year_month < tm(2012m1)
drop if year_month > tm(2025m3)
keep if bundesland == "North_Rhine_Westphalia"
drop if market_segment != "MFH"
*Drop cities without data on buyer type for MFH
drop if city == "Dortmund" | city == "Düsseldorf" | city == "Münster" | city == "Köln"
 

    * Compute mean price per rentstatus and year
    collapse (mean) mean_price = ln_price_sqm, by(buyer_type_dummy year)
    
    * Set base price for 2021
    gen base_price = .
    replace base_price = mean_price if year == 2021
    egen base_price_all = max(base_price), by(buyer_type_dummy)
    
    * Create price index
    gen price_index = mean_price / base_price_all
    
    * Separate series for graph
    gen price_index_private = price_index if buyer_type_dummy == 1
    gen price_index_nprivate = price_index if buyer_type_dummy == 0
    
    * Graph
    twoway (line price_index_private year, mcolor(blue) msymbol(o)) ///
           (line price_index_nprivate year, mcolor(red) msymbol(x)), ///
           legend(label(1 "Private") label(2 "Non-private") position(4) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2021 = 1)", size(small)) xtitle("Year", size(small)) xline(2021, lpattern(dash) lcolor(black)) xline(2023, lpattern(dash) lcolor(black)) text(1.02 2020 "2021", size(small)) text(1.02 2022 "2023", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_nrw_mfh_buyer.pdf", replace

  