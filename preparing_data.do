*Load the dataset
use "$hh\Greix_PanelData_2025q1.dta", clear

*-------------------------------------------------------------------------------

*Dropping of unnecessary variables and recoding of variables

*-------------------------------------------------------------------------------

*Drop unnecessary variables
drop district_num property_type address_id stadtbezirk area_floor

*Drop construct_year_cat to recreate it properly
drop construct_year_cat

*Create construct_year_cat
gen construction_year_cat = ""
replace construction_year_cat = "missing" if construct_year == 0 |  construct_year == .
replace construction_year_cat = "bis 1918" if construct_year > 0 & construct_year < 1919
replace construction_year_cat = "1919-1949" if construct_year > 1918 & construct_year < 1950
replace construction_year_cat = "1950-1977" if construct_year > 1949 & construct_year < 1978
replace construction_year_cat = "1978-1989" if construct_year > 1977 & construct_year < 1990
replace construction_year_cat = "1990-2004" if construct_year > 1989 & construct_year < 2005
replace construction_year_cat = "2005-today" if construct_year > 2004 

*Replace year_quarter (some mistakes were made before)
replace year_quarter = qofd(contract_date)
format year_quarter %tq

*-------------------------------------------------------------------------------

*Dropping of duplicates and correcting of observations

*-------------------------------------------------------------------------------

*Drop Hamburg duplicates
duplicates drop price contract_date area_living district if city == "Hamburg", force

*Correct one observation for NRW
replace year_quarter = 249 if year_quarter == -2059


*Rename Frankfurt to Frankfurt am Main
replace city = "Frankfurt" if city == "Frankfurt am Main"
*Rename Kreis Mettmann and Rhein-Erft-Kreis
replace city = "Kreis_Mettmann" if city == "Kreis Mettmann"
replace city = "Rhein_Erft_Kreis" if city == "Rhein-Erft-Kreis"

*Rename FFM to F
replace city_code = "F" if city_code == "FFM"


*-------------------------------------------------------------------------------

*Creation of new variables

*-------------------------------------------------------------------------------


* Create area_living^2
gen area_living_sq = area_living*area_living

* Create buyer_type dummy
gen buyer_type_dummy = 0
replace buyer_type_dummy = 1 if buyer_type == "privat"

* Create rentstatus dummy
gen unrented = .
replace unrented = 1 if inlist(rentstatus_num, 1)
replace unrented = 0 if inlist(rentstatus_num, 2, 3)

*Create new build
gen new_build = .
replace new_build = 1 if abs(year - construct_year) <= 1
replace new_build = 0 if abs(year - construct_year) > 1

*Create numeric city variable
encode city, gen(city_num)

*Create numeric market segment variable
encode market_segment, gen(market_segment_num)

*Create numeric construction_year_cat variable
encode construction_year_cat, gen(construction_year_cat_num)

* Gen merged price variable (clean price is preferred but not available for all properties, where we dont want to drop all of these)
gen price_merge = clean_price
replace price_merge = price if missing(clean_price)

*Replace 0s with missing values
replace price_merge = . if price_merge == 0

* Generate log(price_merge)
gen ln_price = log(price_merge)


*Create square_meter price_
gen price_sqm = price_merge/area_living

*create ln of price per square meter
gen ln_price_sqm = ln(price_sqm)


*Create Bundesland variable
gen str20 bundesland = ""

* Berlin
replace bundesland = "Berlin" if city == "Berlin"

* North Rhine-Westphalia
replace bundesland = "North_Rhine_Westphalia" if inlist(city, "Bocholt", "Dortmund", "Bonn", "Duisburg", "Köln", "Düsseldorf", "Münster", "Rhein_Erft_Kreis", "Kreis_Mettmann")

* Saxony
replace bundesland = "Saxony" if inlist(city, "Chemnitz", "Dresden", "Leipzig")

* Thuringia
replace bundesland = "Thuringia" if city == "Erfurt"

* Hesse
replace bundesland = "Hesse" if inlist(city, "Frankfurt", "Frankfurt am Main", "Wiesbaden")

* Hamburg
replace bundesland = "Hamburg" if city == "Hamburg"

* Baden-Württemberg
replace bundesland = "Baden_Württemberg" if inlist(city, "Karlsruhe", "Stuttgart")

* Bavaria
replace bundesland = "Bavaria" if inlist(city, "München")

* Schleswig-Holstein
replace bundesland = "Schleswig_Holstein" if city == "Lübeck"

* Brandenburg
replace bundesland = "Brandenburg" if city == "Potsdam"

order bundesland, first

*Create numeric bundesland variable
encode bundesland, gen(bundesland_num)

*Create RETT variable
gen RETT = .
replace RETT = 3.5
replace RETT = 5 if bundesland == "Baden_Württemberg" & year_month > ym(2011, 4)
replace RETT = 3.5 if bundesland == "Bavaria"
replace RETT = 4.5 if bundesland == "Berlin" & year > 2006
replace RETT = 5.0 if bundesland == "Berlin" & year_month > ym(2012, 3)
replace RETT = 6.0 if bundesland == "Berlin" & year > 2013
replace RETT = 5.0 if bundesland == "Brandenburg" & year > 2010
replace RETT = 6.5 if bundesland == "Brandenburg" & year_month > ym(2015, 6)
replace RETT = 4.5 if bundesland == "Hamburg" & year > 2008
replace RETT = 5.5 if bundesland == "Hamburg" & year > 2022
replace RETT = 5.0 if bundesland == "Hesse" & year > 2012
replace RETT = 6 if bundesland == "Hesse" & year_month > ym(2014, 7)
replace RETT = 5 if bundesland == "North_Rhine_Westphalia" & year_month > ym(2011, 9)
replace RETT = 6.5 if bundesland == "North_Rhine_Westphalia" & year > 2013
replace RETT = 5.5 if bundesland == "Saxony"  & year > 2022
replace RETT = 5.0 if bundesland == "Schleswig_Holstein" & year > 2011
replace RETT = 6.5 if bundesland == "Schleswig_Holstein" & year > 2013
replace RETT = 5.0 if bundesland == "Thuringia"  & year_month > ym(2011, 3)
replace RETT = 6.5 if bundesland == "Thuringia" & year > 2016
replace RETT = 5.0 if bundesland == "Thuringia"  & year > 2023
replace RETT = 5.5 if bundesland == "Saxony" & year > 2022

*Create new district variable
gen city_district = city_code + "-" + district
encode city_district, gen(district_num_new)

* Count transactions by city and month
bysort city market_segment year_month: gen n_transactions_city_m = _N
bysort bundesland market_segment year_month: gen n_transactions_bundesland_m = _N
bysort district_num_new market_segment year_month: gen n_transactions_district_m = _N

* Count transactions by city and quarter
bysort city market_segment year_quarter: gen n_transactions_city_q = _N
bysort bundesland market_segment year_quarter: gen n_transactions_bundesland_q = _N
bysort district_num_new market_segment year_quarter: gen n_transactions_district_q = _N

* Count transactions by city and half
bysort city market_segment year_half: gen n_transactions_city_h = _N
bysort bundesland market_segment year_half: gen n_transactions_bundesland_h = _N
bysort district_num_new market_segment year_half: gen n_transactions_district_h = _N

* Count transactions by city and year
bysort city market_segment year: gen n_transactions_city_y = _N
bysort bundesland market_segment year: gen n_transactions_bundesland_y = _N
bysort district_num_new market_segment year: gen n_transactions_district_y = _N

gen ln_transactions_district_m = ln(n_transactions_district_m)
gen ln_transactions_city_m = ln(n_transactions_district_m)
gen ln_transactions_bundesland_m = ln(n_transactions_district_m)

gen ln_transactions_district_q = ln(n_transactions_district_q)
gen ln_transactions_city_q = ln(n_transactions_district_q)
gen ln_transactions_bundesland_q = ln(n_transactions_district_q)

gen ln_transactions_district_h = ln(n_transactions_district_h)
gen ln_transactions_city_h = ln(n_transactions_district_h)
gen ln_transactions_bundesland_h = ln(n_transactions_district_h)

gen ln_transactions_district_y = ln(n_transactions_district_y)
gen ln_transactions_city_y = ln(n_transactions_district_y)
gen ln_transactions_bundesland_y = ln(n_transactions_district_y)
*Gen west dummy
gen west = .
replace west = 1 if inlist(bundesland, "Baden_Württemberg", "Bavaria", "Hamburg", "Hesse", "North_Rhine_Westphalia", "Schleswig_Holstein")
replace west = 0 if inlist(bundesland, "Berlin", "Thuringia", "Saxony", "Brandenburg")

*Save the dataset
save "$hh\Greix_PanelData_adjusted.dta", replace


*-------------------------------------------------------------------------------

*Merging additional predictor variables for SCM

*-------------------------------------------------------------------------------


*----------------------------------GDP------------------------------------------


*Load GDP dataset
import excel using "$hh\GDP_data_adjusted.xlsx", firstrow clear
bro
*Drop unnecessary rows
drop in 1
drop in 2
drop in 2
drop if _n >= 36
*Rename variables
rename (A B C D E G H ZumInhaltsverzeichnis N P Q) (year BadenWürttemberg Bavaria Berlin Brandenburg Hamburg Hesse NRW Saxony SchleswigHolstein Thuringia)
drop F I J L M O R S T U V W
drop in 1
rename BadenWürtt~g BadenWuerttemberg
rename SchleswigH~n SchleswigHolstein

*stack 
stack BadenWuerttemberg Bavaria Berlin Brandenburg Hamburg Hesse NRW Saxony SchleswigHolstein Thuringia, into(gdp) wide clear

*create bundesland variable
gen bundesland = "" 
replace bundesland = "Baden_Württemberg" if _stack == 1
replace bundesland = "Bavaria" if _stack == 2
replace bundesland = "Berlin" if _stack == 3
replace bundesland = "Brandenburg" if _stack == 4
replace bundesland = "Hamburg" if _stack == 5
replace bundesland = "Hesse" if _stack == 6
replace bundesland = "North_Rhine_Westphalia" if _stack == 7
replace bundesland = "Saxony" if _stack == 8
replace bundesland = "Schleswig_Holstein" if _stack == 9
replace bundesland = "Thuringia" if _stack == 10

drop Bavaria Berlin Brandenburg Hamburg Hesse NRW Saxony SchleswigHolstein Thuringia

gen year = 1990 + mod(_n-1, 34) + 1

drop BadenWuerttemberg _stack

*Save the GDP dataset
save "$hh\GDP_data_adjusted.dta", replace

*Open panel data
use "$hh\Greix_PanelData_adjusted.dta", clear

merge m:1 bundesland year using "$hh\GDP_data_adjusted.dta"
drop _merge

*Save the dataset
save "$hh\Greix_PanelData_adjusted.dta", replace


*----------------------------------Population-----------------------------------

*Load population dataset
import excel using "$hh\Population_data_adjusted.xlsx", firstrow clear
bro
*Drop unnecessary rows
drop in 1
drop in 2
drop in 2
drop if _n >= 36
*Rename variables
rename (EinwohnerinnenundEinwohner B C D E G H ZumInhaltsverzeichnis N P Q) (year BadenWürttemberg Bavaria Berlin Brandenburg Hamburg Hesse NRW Saxony SchleswigHolstein Thuringia)
drop F I J L M O R S T U V W
drop in 1
rename BadenWürtt~g BadenWuerttemberg
rename SchleswigH~n SchleswigHolstein


*stack 
stack BadenWuerttemberg Bavaria Berlin Brandenburg Hamburg Hesse NRW Saxony SchleswigHolstein Thuringia, into(pop) wide clear

*create bundesland variable
gen bundesland = "" 
replace bundesland = "Baden_Württemberg" if _stack == 1
replace bundesland = "Bavaria" if _stack == 2
replace bundesland = "Berlin" if _stack == 3
replace bundesland = "Brandenburg" if _stack == 4
replace bundesland = "Hamburg" if _stack == 5
replace bundesland = "Hesse" if _stack == 6
replace bundesland = "North_Rhine_Westphalia" if _stack == 7
replace bundesland = "Saxony" if _stack == 8
replace bundesland = "Schleswig_Holstein" if _stack == 9
replace bundesland = "Thuringia" if _stack == 10

drop Bavaria Berlin Brandenburg Hamburg Hesse NRW Saxony SchleswigHolstein Thuringia

gen year = 1990 + mod(_n-1, 34) + 1

drop BadenWuerttemberg _stack

*Save the population dataset
save "$hh\GDP_data_adjusted.dta", replace

*Open panel data
use "$hh\Greix_PanelData_adjusted.dta", clear

merge m:1 bundesland year using "$hh\GDP_data_adjusted.dta"

drop _merge

*Save the dataset
save "$hh\Greix_PanelData_adjusted.dta", replace


*----------------------------------Unemployment---------------------------------

*Load unemployment dataset
import excel using "$hh\unemployment_data_adjusted.xlsx", firstrow clear
bro

drop in 1
drop in 1
drop in 1
drop in 1
drop B C D E F G H I J Q R S T U V W X Y AF AG AH AI AJ AK AX AY AZ Arbeitsmarktstatistik
drop K M N P Z AB AC AE AL AN AO AQ AR AT AU AW BA BC BD 
rename (A L O AA AD AM AP AS AV BB BE) (year_month SchleswigHolstein Hamburg NorthRhineWestphalia Hesse BadenWuerttemberg Bavaria Berlin Brandenburg Thuringia Saxony)
drop in 1/78
drop in 338
drop in 338

*stack 
stack BadenWuerttemberg Bavaria Berlin Brandenburg Hamburg Hesse NorthRhineWestphalia Saxony SchleswigHolstein Thuringia, into(unemployment) wide clear

*create bundesland variable
gen bundesland = "" 
replace bundesland = "Baden_Württemberg" if _stack == 1
replace bundesland = "Bavaria" if _stack == 2
replace bundesland = "Berlin" if _stack == 3
replace bundesland = "Brandenburg" if _stack == 4
replace bundesland = "Hamburg" if _stack == 5
replace bundesland = "Hesse" if _stack == 6
replace bundesland = "North_Rhine_Westphalia" if _stack == 7
replace bundesland = "Saxony" if _stack == 8
replace bundesland = "Schleswig_Holstein" if _stack == 9
replace bundesland = "Thuringia" if _stack == 10


drop Bavaria Berlin Brandenburg Hamburg Hesse NorthRhineWestphalia Saxony SchleswigHolstein Thuringia BadenWuerttemberg

gen month_index = mod(_n-1, 337)
gen year_month = ym(1997, 4) + month_index
format year_month %tm

drop _stack month_index

*Save the unemployment dataset
save "$hh\unemployment_data_adjusted.dta", replace

*Open panel data
use "$hh\Greix_PanelData_adjusted.dta", clear

merge m:1 bundesland year_month using "$hh\unemployment_data_adjusted.dta"

drop _merge

*Save the dataset
save "$hh\Greix_PanelData_adjusted.dta", replace


*----------------------------Construction permits-------------------------------

*Load construction permit dataset
import excel using "$pp\construction permits.xlsx", firstrow clear
bro

rename BaugenehmigungenimFertigteilba bundesland

replace bundesland = bundesland[_n-1] if missing(bundesland)

drop E G B
drop in 105 
drop in 105 
drop in 105 
drop in 105 
drop in 105 
drop in 105 
drop in 105 
drop in 105 

drop in 1 
drop in 1 
drop in 1 
drop in 1 

rename C year
rename D construction_permits_houses
rename F construction_permits_apartments

destring year, replace
replace bundesland = "Bavaria" if bundesland == "Bayern"
replace bundesland = "Baden_Württemberg" if bundesland == "Baden-Württemberg"
replace bundesland = "North_Rhine_Westphalia" if bundesland == "Nordrhein-Westfalen"
replace bundesland = "Thuringia" if bundesland == "Thüringen"
replace bundesland = "Hesse" if bundesland == "Hessen"
replace bundesland = "Schleswig_Holstein" if bundesland == "Schleswig-Holstein"
replace bundesland = "Saxony" if bundesland == "Sachsen"


save "$pp\construction permits.dta", replace

*Open panel data
use "$hh\Greix_PanelData_adjusted.dta", clear

merge m:1 bundesland year using "$pp\construction permits.dta"
drop _merge

*Save the dataset
save "$hh\Greix_PanelData_adjusted.dta", replace


*--------------------------Number of properties---------------------------------


*Load number of properties dataset
import excel using "$pp\number of properties.xlsx", firstrow clear
bro

drop C D E F G H I J K L M N P R

drop in 1
drop in 1
drop in 1
drop in 1
drop in 1

rename WohngebäudeWohnungenWohnfläc year
* Step 1: Extract year if the format is like "31.12.2010"
gen year_clean = .
replace year_clean = real(substr(year, -4, 4)) if strpos(year, ".") > 0
* Step 2: Fill forward the values
gen year_final = year_clean
replace year_final = year_final[_n-1] if missing(year_final)

drop year year_clean 
rename year_final year
rename B bundesland
rename O n_buildings
rename Q n_apartments

replace bundesland = "Bavaria" if bundesland == "Bayern"
replace bundesland = "Baden_Württemberg" if bundesland == "Baden-Württemberg"
replace bundesland = "North_Rhine_Westphalia" if bundesland == "Nordrhein-Westfalen"
replace bundesland = "Thuringia" if bundesland == "Thüringen"
replace bundesland = "Hesse" if bundesland == "Hessen"
replace bundesland = "Schleswig_Holstein" if bundesland == "Schleswig-Holstein"
replace bundesland = "Saxony" if bundesland == "Sachsen"

drop in 141
drop in 141
drop in 141
drop in 141
drop in 141
drop in 141
drop in 141
save "$pp\number of properties.dta", replace

*Open panel data
use "$hh\Greix_PanelData_adjusted.dta", clear

merge m:1 bundesland year using "$pp\number of properties.dta"
drop _merge

*Save the dataset
save "$hh\Greix_PanelData_adjusted.dta", replace


*--------------------------------Price index------------------------------------


*Load price index dataset
import excel using "$pp\price_index.xlsx", firstrow clear
bro

drop in 1
drop in 1
drop in 1
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184



drop D F H J L N P R T V 

rename (VerbraucherpreisindexBundeslän B C E G I K M O Q S U) (year month Baden_Württemberg Bavaria Berlin Brandenburg Hamburg Hesse North_Rhine_Westphalia Saxony Schleswig_Holstein Thuringia)

*stack 
stack Baden_Württemberg Bavaria Berlin Brandenburg Hamburg Hesse North_Rhine_Westphalia Saxony Schleswig_Holstein Thuringia, into(overall_price_index) wide clear

*create bundesland variables
gen bundesland = "" 
replace bundesland = "Baden_Württemberg" if _stack == 1
replace bundesland = "Bavaria" if _stack == 2
replace bundesland = "Berlin" if _stack == 3
replace bundesland = "Brandenburg" if _stack == 4
replace bundesland = "Hamburg" if _stack == 5
replace bundesland = "Hesse" if _stack == 6
replace bundesland = "North_Rhine_Westphalia" if _stack == 7
replace bundesland = "Saxony" if _stack == 8
replace bundesland = "Schleswig_Holstein" if _stack == 9
replace bundesland = "Thuringia" if _stack == 10

drop Bavaria Berlin Brandenburg Hamburg Hesse North_Rhine_Westphalia Saxony Schleswig_Holstein Thuringia Baden_Württemberg

* Step 1: Generate a numeric time variable from 0 to 182
gen month_id = _n
bysort bundesland (month_id): replace month_id = _n

* Step 2: Create a Stata monthly date starting from 2010m1
gen year_month = ym(2010, 1) + month_id - 1
format year_month %tm

drop _stack month_id

save "$pp\price_index.dta", replace

*Open panel data
use "$hh\Greix_PanelData_adjusted.dta", clear

merge m:1 bundesland year_month using "$pp\price_index.dta"
drop _merge

*Save the dataset
save "$hh\Greix_PanelData_adjusted.dta", replace


*------------------------------Rent price index---------------------------------



*Load rent price index dataset
import excel using "$pp\index_rent_prices.xlsx", firstrow clear
bro

drop in 1
drop in 1
drop in 1
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184
drop in 184


drop D F H J L N P R T V 

rename (IndexderNettokaltmietenBunde B C E G I K M O Q S U) (year month Baden_Württemberg Bavaria Berlin Brandenburg Hamburg Hesse North_Rhine_Westphalia Saxony Schleswig_Holstein Thuringia)

*stack 
stack Baden_Württemberg Bavaria Berlin Brandenburg Hamburg Hesse North_Rhine_Westphalia Saxony Schleswig_Holstein Thuringia, into(price_index_rents) wide clear

*create bundesland variables
gen bundesland = "" 
replace bundesland = "Baden_Württemberg" if _stack == 1
replace bundesland = "Bavaria" if _stack == 2
replace bundesland = "Berlin" if _stack == 3
replace bundesland = "Brandenburg" if _stack == 4
replace bundesland = "Hamburg" if _stack == 5
replace bundesland = "Hesse" if _stack == 6
replace bundesland = "North_Rhine_Westphalia" if _stack == 7
replace bundesland = "Saxony" if _stack == 8
replace bundesland = "Schleswig_Holstein" if _stack == 9
replace bundesland = "Thuringia" if _stack == 10

drop Bavaria Berlin Brandenburg Hamburg Hesse North_Rhine_Westphalia Saxony Schleswig_Holstein Thuringia Baden_Württemberg

* Step 1: Generate a numeric time variable from 0 to 182
gen month_id = _n
bysort bundesland (month_id): replace month_id = _n

* Step 2: Create a Stata monthly date starting from 2010m1
gen year_month = ym(2010, 1) + month_id - 1
format year_month %tm

drop _stack month_id

save "$pp\index_rent_prices.dta", replace

*Open panel data
use "$hh\Greix_PanelData_adjusted.dta", clear

merge m:1 bundesland year_month using "$pp\index_rent_prices.dta"
drop _merge

*-------------------------------------------------------------------------------

*Destringing new variables

*-------------------------------------------------------------------------------

destring pop, replace
destring unemployment, replace
destring gdp, replace
destring construction_permits_houses construction_permits_apartments n_apartments n_buildings, replace
replace overall_price_index = "" if trim(overall_price_index) == "-"
replace price_index_rents = "" if trim(price_index_rents) == "-"
destring overall_price_index price_index_rents, replace


*-------------------------------------------------------------------------------

*creation of further new variables

*-------------------------------------------------------------------------------


* Create GDP per capita
gen gdp_per_capita = gdp / pop



*-------------------------------------------------------------------------------

*Some final cleaning

*-------------------------------------------------------------------------------

*Dropping of observations
drop if price_merge <= 0






*Save the dataset
save "$hh\Greix_PanelData_adjusted.dta", replace
