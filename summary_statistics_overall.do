*Load the dataset
use "$hh\Greix_PanelData_adjusted.dta", clear


drop if year_month < tm(2008m1)
drop if year_month > tm(2025m3)
/*drop if city == "Bocholt"
drop if city == "Duisburg"
drop if city == "Dortmund"
drop if city == "Rhein_Erft_Kreis"
drop if city == "Kreis_Mettmann"

*/

********************************************************************************
* Generate region variable
********************************************************************************
gen region = "Other"
replace region = "Hesse" if bundesland == "Hesse"
replace region = "North_Rhine_Westphalia" if bundesland == "North_Rhine_Westphalia"
replace region = "Bavaria" if bundesland == "Bavaria"

tab region market_segment

*Generate dummies for categorical variables 
gen private = buyer_type_dummy
tabulate location_quality_num, generate(location_dummy)
tabulate construction_year_cat, generate(construction_dummy)

rename location_dummy1 Simple
rename location_dummy2 Mediocre
rename location_dummy3 Good
rename location_dummy4 Very_good
rename location_dummy5 Missing
rename construction_dummy1 c_1919_1949
rename construction_dummy2 c_1950_1977
rename construction_dummy3 c_1978_1989
rename construction_dummy4 c_1990_2005
rename construction_dummy5 c_2005_today
rename construction_dummy6 construct_1918


eststo clear
bysort market_segment region: eststo: estpost sum price_sq area_living unrented private new_build Simple Mediocre Good Very_good Missing construct_1918 c_1919_1949 c_1950_1977 c_1978_1989 c_1990_2005 c_2005_today 
esttab using overall_summary_quantitiative.tex, replace tex cells ("mean") mtitles("Hesse" "NRW" "Other" "Bavaria" "Hesse" "NRW" "Other" "Hesse" "NRW" "Other") nonumber noobs
