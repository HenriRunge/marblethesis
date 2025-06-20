* Load and filter dataset
use "$hh\Greix_PanelData_adjusted.dta", clear
drop if year_month < tm(2014m1)
drop if year_month > tm(2025m3)
keep if bundesland == "Hesse"
drop if market_segment != "MFH"
*Frankfurt has no data on MFH buyer type
drop if city != "Wiesbaden"

    
    * Compute mean price per rentstatus and half
    collapse (mean) mean_price = ln_price_sqm, by(buyer_type_dummy year_half)
    
    * Set base price for 2023h2
    gen base_price = .
    replace base_price = mean_price if year_half == th(2023h2)
    egen base_price_all = max(base_price), by(buyer_type_dummy)
    
    * Create price index
    gen price_index = mean_price / base_price_all
    
    * Separate series for graph
    gen price_index_private = price_index if buyer_type_dummy == 1
    gen price_index_nprivate = price_index if buyer_type_dummy == 0
    
    * Graph
    twoway (line price_index_private year_half, mcolor(blue) msymbol(o)) ///
           (line price_index_nprivate year_half, mcolor(red) msymbol(x)), ///
           legend(label(1 "Private") label(2 "Non-private")position(6) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2023h2 = 1)", size(small)) xtitle("Year half", size(small)) xline(127, lcolor(black) lpattern(dash)) text(1.2 126 "2023h2", size(small)) 
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_hesse_mfh_buyer.pdf", replace

