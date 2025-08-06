* scorecards subnational *
* % people using financial account, all female *
* Sizhen Fang *
* 2/27/2025 *

clear all
set more off

program main
	load_data
	analysis
end

program load_data
	* load and append
	* BGD 2022
	use "P:\SARMD\SARDATABANK\WORKINGDATA\BGD\BGD_2022_HIES\BGD_2022_HIES_v03_M\Data\Stata\BGD_2022_HIES_v03_M.dta", clear
	gen bank_acc = 1 if S1AQ12 == 1
	replace bank_acc = 0 if S1AQ12 == 2
	replace bank_acc = 1 if S1AQ13 == 1 & S1AQ12 == 2
	gen age = S1AQ03
	gen subnatid1 = ID_01_NAME
	gen countrycode = "BGD"
	gen year = 2022
	gen male = S1AQ01
	replace male = 0 if S1AQ01 == 2
	gen weight = hh_wgt

	keep age bank_acc subnatid1 countrycode year male weight
	keep if age >= 15

	tempfile bgd2022
	save `bgd2022', replace
	
	* BGD 2016
	use "P:\SARMD\SARDATABANK\WORKINGDATA\BGD\BGD_2016_HIES\BGD_2016_HIES_v01_M\Data\Stata\HH_SEC_1C.dta", clear
	drop if missing(indid)
	duplicates drop hhid psu quarter indid, force
	tempfile HH_SEC_1C
	save `HH_SEC_1C', replace
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\BGD\BGD_2016_HIES\BGD_2016_HIES_v01_M\Data\Stata\HH_SEC_5.dta" 
	duplicates drop hhid psu quarter, force
	tempfile HH_SEC_5
	save `HH_SEC_5', replace
	
	
	use "P:\SARMD\SARDATABANK\WORKINGDATA\BGD\BGD_2016_HIES\BGD_2016_HIES_v01_M\Data\Stata\BGD_2016_HIES_v01_M.dta", clear
	merge m:1 psu hhid quarter indid using `HH_SEC_1C' , nogen
	
	
end

* quality check: national avg
preserve 
collapse (mean)bank_acc [iw=weight], by(countrycode year)
export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\bank_acc.xlsx", firstrow(variables) sheet(national_all, replace)

* quality check: national avg. female
restore
preserve
keep if male == 0
collapse (mean)bank_acc [iw=weight], by(countrycode year)
export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\bank_acc.xlsx", firstrow(variables) sheet(national_female, replace)

* all
restore
preserve
collapse (mean)bank_acc [iw=weight], by(countrycode year subnatid1)
drop if missing(subnatid1)
export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\bank_acc.xlsx", firstrow(variables) sheet(subnat_all, replace)


* female 
restore
keep if male == 0
collapse (mean)bank_acc [iw=weight], by (countrycode year subnatid1) 
drop if missing(subnatid1)
export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\bank_acc.xlsx", firstrow(variables) sheet(subnat_female, replace)



