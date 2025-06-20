*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear

drop if year_month < tm(2008m7)
drop if year_month > tm(2025m3)
drop if bundesland != "Bavaria"



* Compute mean price per rentstatus and half
    collapse (mean) mean_price = ln_price_sq, by(unrented year_quarter)
    
    * Set base price for 2023h2
    gen base_price = .
    replace base_price = mean_price if year_quarter == tq(2018q2)
    egen base_price_all = max(base_price), by(unrented)
    
    * Create price index
    gen price_index = mean_price / base_price_all
    

    
    * Graph
    twoway (line price_index year_quarter if unrented == 1, mcolor(blue) msymbol(o)) ///
           (line price_index year_quarter if unrented == 0, mcolor(red) msymbol(x)), ///
           legend(label(1 "Unrented") label(2 "Rented")position(4) ring(0) cols(1) size(small)) ytitle("Ln(price/sqm) index (2018q2 = 1)", size(small)) xtitle("Quarter", size(small)) xline(233, lpattern(dash) lcolor(black)) xline(244, lpattern(dash) lcolor(black)) text(1.05 230 "2018q2", size(small)) text(1.05 241 "2020q4", size(small))
graph export "C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax\price_index_bavaria_rented.pdf", replace
       