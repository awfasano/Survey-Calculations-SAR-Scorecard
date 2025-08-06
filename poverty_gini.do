
/*===================================================================================================
Project:			Subnational Poverty and Gini
Institution:		World Bank - ESAPV

Author:				Kelly Y. Montoya (kmontoyamunoz@worldbank.org)
Creation Date:		08/26/2024

Last Modification:	Sizhen Fang (sfang2@worldbank.org)
Modification date:  02/28/2025
===================================================================================================*/

clear all
drop _all
version 17.0

* Vintage information

* BGD 2022 2016
* BTN 2022 2017
* IND 2022 2011
* LKA 2019 2016
* MDV 2019 2016
* NPL 2022 2010
* PAK 2018 2015

gl code = "PAK"
gl year = 2015

gl cpiversion ="v12"
gl ppp = 2021
gl povlines "3.00 4.20 8.30"

* BGD HIES 2022(0204)
if "${code}" == "BGD" & ${year} == 2022 {
	gl survey = "HIES"
	gl vm = "02" 
	gl va = "04"
	gl source = "Pdrive"
} 

* 2016(0108)
else if "${code}" == "BGD" & ${year} == 2016 {
	gl survey = "HIES"
	gl vm = "01" 
	gl va = "08"
	gl source = "Pdrive"
} 

* BTN BLSS 2022(0102) 2017(0103) SARMD
else if "${code}" == "BTN" & ${year} == 2022 {
	gl survey = "BLSS"
	gl vm = "01" 
	gl va = "02"
	gl source = "SARMD"
} 

else if "${code}" == "BTN" & ${year} == 2017 {
	gl survey = "BLSS"
	gl vm = "01" 
	gl va = "03"
	gl source = "SARMD"
} 

* IND HCES 2022(0202)
else if "${code}" == "IND" & ${year} == 2022 {
	gl survey = "HCES"
	gl vm = "02" 
	gl va = "01"
	gl source = "IND"
} 

else if "${code}" == "IND" & ${year} == 2011 {
	gl survey = "NSS-SCH2"
	gl vm = "02" 
	gl va = "01"
	gl source = "IND"
} 

* LKA HIES 2019(0103) 2016(0107) SARMD
else if "${code}" == "LKA" & ${year} == 2019 {
	gl survey = "HIES"
	gl vm = "01" 
	gl va = "03"
	gl source = "SARMD"
} 

else if "${code}" == "LKA" & ${year} == 2016 {
	gl survey = "HIES"
	gl vm = "01" 
	gl va = "07"
	gl source = "SARMD"
} 

* MDV HIES 2019(0102) 2016(0201) SARMD
else if "${code}" == "MDV" & ${year} == 2019 {
	gl survey = "HIES"
	gl vm = "01" 
	gl va = "02"
	gl source = "SARMD"
} 

else if "${code}" == "MDV" & ${year} == 2016 {
	gl survey = "HIES"
	gl vm = "02" 
	gl va = "01"
	gl source = "SARMD"
} 

* NPL LSS-IV 2022(0201)  GMD
else if "${code}" == "NPL" & ${year} == 2022 {
	gl survey = "LSS-IV"
	gl vm = "02" 
	gl va = "01"
	gl source = "GMD"
} 

else if "${code}" == "NPL" & ${year} == 2010 {
	gl survey = "LSS-III"
	gl vm = "01" 
	gl va = "05"
	gl source = "SARMD"
} 

* PAK HIES 2018(0103) 2015(0106) SARMD
else if "${code}" == "PAK" & ${year} == 2018 {
	gl survey = "HIES"
	gl vm = "01" 
	gl va = "03"
	gl source = "SARMD"
} 

else if "${code}" == "PAK" & ${year} == 2015 {
	gl survey = "HIES"
	gl vm = "01" 
	gl va = "06"
	gl source = "SARMD"
} 

* Set up postfile for results
tempname mypost
tempfile myresults
postfile `mypost' str12(Country) Year str40(Indicator) Line str40(Aggregation) Value using `myresults', replace

************************************
* Load the data an caculate welfare
************************************

* Using Datalibweb SARMD

if "$source" == "SARMD" {
	
	* Load CPIs
	use "C:\Users\wb611670\OneDrive\SAR\Final_CPI_PPP_to_be_used.dta", clear
	keep if code == "${code}" & year == ${year}
	keep code year cpi${ppp} icp${ppp}
	rename code countrycode
	tempfile dlwcpi
	save `dlwcpi', replace
	
	* Load SARMD
	use "P:\SARMD\SARDATABANK\WORKINGDATA/${code}/${code}_${year}_${survey}/${code}_${year}_${survey}_v${vm}_M_v${va}_A_SARMD\Data\Harmonized/${code}_${year}_${survey}_v${vm}_M_v${va}_A_SARMD_IND", clear
	merge m:1 countrycode year using `dlwcpi', nogen keep(3)

	* Generate welfare
	gen welfare_ppp = (12 / 365) * welfare / cpi${ppp} / icp${ppp}
	cap gen wgt = weight
}


* Using P drive GMD

else if "$source" == "GMD" {
	
	use "C:\Users\wb611670\OneDrive\SAR\Final_CPI_PPP_to_be_used.dta", clear
	keep if code == "${code}" & year == ${year}
	keep code year cpi${ppp} icp${ppp}
	rename code countrycode
	tempfile dlwcpi
	save `dlwcpi', replace
	
	* Load data
// 	dlw, coun("${code}") y(${year}) t(GMD) mod(all) clear
	use "P:\SARMD\SARDATABANK\WORKINGDATA/${code}/${code}_${year}_${survey}/${code}_${year}_${survey}_v${vm}_M_v${va}_A_SARMD\Data\Harmonized/${code}_${year}_${survey}_v${vm}_M_v${va}_A_SARMD_${source}", clear
	merge m:1 countrycode year using `dlwcpi', nogen keep(3)
	
	* Generate welfare
	gen welfare_ppp = (1 / 365) * welfare / cpi${ppp} / icp${ppp}
	cap gen wgt = weight
}


* Using the P drive

else if "$source" == "Pdrive" {

	* Load CPIs
// 	dlw, coun(Support) y(2005) t(GMDRAW) surveyid(Support_2005_CPI_${cpiversion}_M) filename(Final_CPI_PPP_to_be_used.dta)
	use "C:\Users\wb611670\OneDrive\SAR\Final_CPI_PPP_to_be_used.dta", clear
	keep if code == "${code}" & year == ${year}
	keep code year cpi${ppp} icp${ppp}
	rename code countrycode
	tempfile dlwcpi
	save `dlwcpi', replace

	* Load necessary modules
	gl INC "P:\SARMD\SARDATABANK\WORKINGDATA/${code}/${code}_${year}_${survey}/${code}_${year}_${survey}_v${vm}_M_v${va}_A_SARMD\Data\Harmonized/${code}_${year}_${survey}_v${vm}_M_v${va}_A_SARMD_INC"
	gl IND "P:\SARMD\SARDATABANK\WORKINGDATA/${code}/${code}_${year}_${survey}/${code}_${year}_${survey}_v${vm}_M_v${va}_A_SARMD\Data\Harmonized/${code}_${year}_${survey}_v${vm}_M_v${va}_A_SARMD_IND"

	use "$INC", clear

	tempfile income
	save `income'

	use "$IND", clear
	merge m:1 hhid pid using `income', nogen

	cap drop icp* cpi* 
	merge m:1 countrycode year using `dlwcpi', keep(3) nogen

	* Generate welfare
	gen welfare_ppp = (12 / 365) * welfare / cpi${ppp} / icp${ppp}
	cap gen wgt = weight
}

* IND 
else if "${code}" == "IND" {
	use "C:\Users\wb611670\OneDrive\SAR\Final_CPI_PPP_to_be_used.dta", clear
	gen urban = datalevel
	keep if code == "${code}" & year == ${year}
	keep code year cpi${ppp} icp${ppp} urban
	rename code countrycode
	tempfile dlwcpi
	save `dlwcpi', replace
	
	* Load data
	if ${year} == 2022 {
		use "P:\SARMD\SARDATABANK\WORKINGDATA/${code}/${code}_${year}_${survey}/${code}_${year}_${survey}_v${vm}_M_v${va}_A_SARMD\Data\Harmonized/${code}_${year}_${survey}_v${vm}_M_v${va}_A_GMD_ALL", clear
		gen weight = weight_h
	}
	else {
	use "P:\SARMD\SARDATABANK\WORKINGDATA/${code}/${code}_${year}_${survey}/${code}_${year}_${survey}_v${vm}_M_v${va}_A_SARMD\Data\Harmonized/${code}_${year}_${survey}_v${vm}_M_v${va}_A_GMD", clear
	}
	
	
	cap drop cpi
	cap drop icp
	
	merge m:1 countrycode year urban using `dlwcpi', nogen keep(1 3)
	
	* Generate welfare
	gen welfare_ppp = (1 / 365) * welfare / cpi${ppp} / icp${ppp}
	cap gen wgt = weight
	
}

************************************
* Poverty and Inequality
************************************
	
foreach line of global povlines {
	* National
	noi: apoverty welfare_ppp [w=wgt] if welfare_ppp != . , line(`line') h
	loc rat = r(head_1)
	post `mypost' ("${code}") (${year}) ("Poverty")  (`line') ("National") (`rat')
		
	* State
	levelsof subnatid1, local(list)
		
	foreach i in `list' {
		noi: apoverty welfare_ppp [w=wgt] if welfare_ppp != . & subnatid1 == "`i'", line(`line') h
		loc rat = r(head_1)
		post `mypost' ("${code}") (${year}) ("Poverty")  (`line') ("`i'") (`rat')
	}

}

* Inequality
	ainequal welfare_ppp [w=wgt] // National
	loc gini = r(gini_1)
	post `mypost' ("${code}") (${year}) ("Inequality") (0) ("National") (`gini')
	
levelsof subnatid1, local(list)
		
foreach i in `list' {
	ainequal welfare_ppp [w=wgt] if subnatid1 == "`i'"
	loc gini = r(gini_1)
	post `mypost' ("${code}") (${year})  ("Inequality") (0) ("`i'") (`gini')
}
	

* save

postclose `mypost'
use  `myresults', clear

save "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_${code}_${year}.dta", replace

* append all

use "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_BGD_2022.dta", clear
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_BGD_2016.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_BTN_2022.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_BTN_2017.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_IND_2022.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_IND_2011.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_LKA_2019.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_LKA_2016.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_MDV_2019.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_MDV_2016.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_NPL_2022.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_NPL_2010.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_PAK_2018.dta"
append using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\pov_temp\poverty_SAR_PAK_2015.dta"

export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\indicators\poverty_gini.xlsx", firstrow(variables) replace

