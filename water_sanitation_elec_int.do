* scorecards subnational *
* Percentage of population with access to electricity*
* Percentage of population with access to internet*
* Percentage of people with access to basic drinking water, sanitation services, or hygiene*
* Sizhen Fang sfang2@worldbank.org *
* 2/27/2025 *

clear all
set more off

program main
	load_data
	analysis
end

program load_data
	use "P:\SARMD\SARDATABANK\WORKINGDATA\BGD\BGD_2022_HIES\BGD_2022_HIES_v03_M_v01_A_SARMD\Data\Harmonized\BGD_2022_HIES_v03_M_v01_A_SARMD_GMD.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile bgd2022
	save `bgd2022', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\BGD\BGD_2016_HIES\BGD_2016_HIES_v01_M_v08_A_SARMD\Data\Harmonized\BGD_2016_HIES_v01_M_v08_A_SARMD_GMD.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile bgd2016
	save `bgd2016', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\BTN\BTN_2022_BLSS\BTN_2022_BLSS_v01_M_v02_A_SARMD\Data\Harmonized\BTN_2022_BLSS_v01_M_v02_A_SARMD_GMD.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile btn2022
	save `btn2022', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\BTN\BTN_2017_BLSS\BTN_2017_BLSS_v01_M_v03_A_SARMD\Data\Harmonized\BTN_2017_BLSS_v01_M_v03_A_SARMD_GMD.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile btn2017
	save `btn2017', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\IND\IND_2022_HCES\IND_2022_HCES_v02_M_v01_A_SARMD\Data\Harmonized\IND_2022_HCES_v02_M_v01_A_GMD.dta", clear
	rename improved_water imp_wat_rec
	rename improved_sanitation imp_san_rec
	cap gen internet = .
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile ind2022
	save `ind2022', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\IND\IND_2011_NSS-SCH2\IND_2011_NSS-SCH2_v02_M_v01_A_SARMD\Data\Harmonized\IND_2011_NSS-SCH2_v02_M_v01_A_GMD.dta", clear
	rename improved_water imp_wat_rec
	rename improved_sanitation imp_san_rec
	cap gen internet = .
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile ind2011
	save `ind2011', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\LKA\LKA_2019_HIES\LKA_2019_HIES_v01_M_v03_A_SARMD\Data\Harmonized\LKA_2019_HIES_v01_M_v03_A_SARMD_GMD.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile lka2019
	save `lka2019', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\LKA\LKA_2016_HIES\LKA_2016_HIES_v01_M_v07_A_SARMD\Data\Harmonized\LKA_2016_HIES_v01_M_v07_A_SARMD_GMD.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile lka2016
	save `lka2016', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\MDV\MDV_2019_HIES\MDV_2019_HIES_v01_M_v02_A_SARMD\Data\Harmonized\MDV_2019_HIES_v01_M_v02_A_SARMD_GMD.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile mdv2019
	save `mdv2019', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\MDV\MDV_2016_HIES\MDV_2016_HIES_v02_M_v01_A_SARMD\Data\Harmonized\MDV_2016_HIES_v02_M_v01_A_SARMD_GMD.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile mdv2016
	save `mdv2016', replace

	use "P:\SARMD\SARDATABANK\WORKINGDATA\NPL\NPL_2022_LSS-IV\NPL_2022_LSS-IV_v02_M_v01_A_SARMD\Data\Harmonized\NPL_2022_LSS-IV_v02_M_v01_A_SARMD_GMD.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile npl2022
	save `npl2022', replace
	
	use"P:\SARMD\SARDATABANK\WORKINGDATA\NPL\NPL_2010_LSS-III\NPL_2010_LSS-III_v01_M_v05_A_SARMD\Data\Harmonized\NPL_2010_LSS-III_v01_M_v05_A_SARMD_IND.dta", clear
	rename wgt weight
	rename improved_water imp_wat_rec
	rename improved_sanitation imp_san_rec
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile npl2010
	save `npl2010', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\PAK\PAK_2018_HIES\PAK_2018_HIES_v01_M_v03_A_SARMD\Data\Harmonized\PAK_2018_HIES_v01_M_v03_A_SARMD_GMD.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity internet
	tempfile pak2018
	save `pak2018', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\PAK\PAK_2015_HIES\PAK_2015_HIES_v01_M_v06_A_SARMD\Data\Harmonized\PAK_2015_HIES_v01_M_v06_A_SARMD_IND_GMD_ALL.dta", clear
	keep subnatid1 countrycode year weight imp_wat_rec imp_san_rec electricity 
	tempfile pak2015
	save `pak2015', replace
	
	* append 
	use `bgd2022', clear
	append using `bgd2016'
	append using `btn2022'
	append using `btn2017'
	append using `ind2022'
	append using `ind2011'
	append using `lka2019'
	append using `lka2016'
	append using `mdv2019'
	append using `mdv2016'
	append using `npl2022'
	append using `npl2010'
	append using `pak2018'
	append using `pak2015'

end

program analysis 
	* water or sanitation
// 	gen wat_san = 1 if imp_wat_rec == 1 | imp_san_rec == 1
// 	replace wat_san = 0 if imp_wat_rec == 0 & imp_san_rec == 0
	
	gen internet_acc = 0 
	replace internet_acc = 1 if inlist(internet,1, 2, 3, 4)
	replace internet_acc = . if missing(internet)
	
	* quality check: national avg
	preserve 
	collapse (mean) imp_wat_rec imp_san_rec electricity internet_acc [iw=weight], by(countrycode year)
	export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\water_sanitation_elec_int.xlsx", firstrow(variables) sheet(national, replace)

	* subnational
	restore
	preserve
	collapse (mean) imp_wat_rec imp_san_rec electricity internet_acc [iw=weight], by(countrycode year subnatid1)
	drop if missing(subnatid1)
	export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\water_sanitation_elec_int.xlsx", firstrow(variables) sheet(subnat, replace)
end

main