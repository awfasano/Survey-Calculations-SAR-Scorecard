* scorecards subnational *
* % of salaried workers (all, female) *
* Sizhen Fang *
* 2/19/2025 *

clear all
set more off

program main
	merge_data
	salaried_worker
end

program merge_data

use "P:\SARMD\SARDATABANK\SAR_DATABANK\MDV\MDV_2019_HIES\MDV_2019_HIES_v01_M_v02_A_SARMD\Data\Harmonized\MDV_2019_HIES_v01_M_v02_A_SARMD_GMD.dta", clear
drop cpi2017
drop educat4
merge 1:1 pid using "C:\Users\wb611670\WBG\Laura Liliana Moreno Herrera - 12.JQI\TMP\MDV_2019_HIES_v01_M_v01_SARMD_TMP.dta", nogen keep(match)
keep age empstat subnatid1 countrycode year male weight
tempfile mdv2019
save `mdv2019', replace


* BGD 2022
use "P:\SARMD\SARDATABANK\WORKINGDATA\BGD\BGD_2022_QLFS\BGD_2022_QLFS_v01_M_v02_A_SARLAB\Data\Harmonized\BGD_2022_QLFS_v01_M_v02_A_SARLAB_IND.dta", clear

* BGD 2016
append using "P:\SARMD\SARDATABANK\WORKINGDATA\BGD\BGD_2016_QLFS\BGD_2016_QLFS_v01_M_v02_A_SARLAB\Data\Harmonized\BGD_2016_QLFS_v01_M_v02_A_SARLAB_IND.dta", force

* BTN 2022 
append using "P:\SARMD\SARDATABANK\WORKINGDATA\BTN\BTN_2022_LFS\BTN_2022_LFS_v01_M_v03_A_SARLAB\Data\Harmonized\BTN_2022_LFS_v01_M_v03_A_SARLAB_IND.dta", force

* BTN 2019
append using "P:\SARMD\SARDATABANK\WORKINGDATA\BTN\BTN_2019_LFS\BTN_2019_LFS_v01_M_v02_A_SARLAB\Data\Harmonized\BTN_2019_LFS_v01_M_v02_A_SARLAB_IND.dta", force
 
* IND 2023
append using "P:\SARMD\SARDATABANK\WORKINGDATA\IND\IND_2023_PLFS\IND_2023_PLFS_v01_M_v01_A_SARLAB\Data\Harmonized\IND_2023_PLFS_v01_M_v01_A_SARLAB_IND.dta", force

* IND 2019
append using "P:\SARMD\SARDATABANK\WORKINGDATA\IND\IND_2019_PLFS\IND_2019_PLFS_v01_M_v01_A_SARLAB\Data\Harmonized\IND_2019_PLFS_v01_M_v01_A_SARLAB_IND.dta", force

* LKA 2023
append using "P:\SARMD\SARDATABANK\WORKINGDATA\LKA\LKA_2023_LFS\LKA_2023_LFS_v01_M_v01_A_SARLAB\Data\Harmonized\LKA_2023_LFS_v01_M_v01_A_SARLAB_IND.dta", force

* LKA 2019
append using "P:\SARMD\SARDATABANK\WORKINGDATA\LKA\LKA_2019_LFS\LKA_2019_LFS_v01_M_v01_A_SARLAB\Data\Harmonized\LKA_2019_LFS_v01_M_v01_A_SARLAB_IND.dta", force

* NPL 2017
append using "P:\SARMD\SARDATABANK\WORKINGDATA\NPL\NPL_2017_NLFS\NPL_2017_NLFS_v01_M_v01_A_SARLAB\Data\Harmonized\NPL_2017_NLFS_v01_M_v01_A_SARLAB_IND.dta", force
replace year = 2017 if countrycode == "NPL"

* PAK 2020
append using "P:\SARMD\SARDATABANK\WORKINGDATA\PAK\PAK_2020_LFS\PAK_2020_LFS_v01_M_v03_A_SARLAB\Data\Harmonized\PAK_2020_LFS_v01_M_v03_A_SARLAB_IND.dta", force

* PAK 2018
append using "P:\SARMD\SARDATABANK\WORKINGDATA\PAK\PAK_2018_LFS\PAK_2018_LFS_v01_M_v03_A_SARLAB\Data\Harmonized\PAK_2018_LFS_v01_M_v03_A_SARLAB_IND.dta", force

** MDV 2019
append using `mdv2019', force

** MDV 2016


save "C:\Users\wb611670\OneDrive - WBG\Documents\sarlab_tmp.dta", replace

end

program salaried_worker
use "C:\Users\wb611670\OneDrive - WBG\Documents\sarlab_tmp.dta", clear

* % salaried worker, all
* keep 15+ all workers 
keep if age >= 15
gen salaried_worker = 1 if empstat == 1
replace salaried_worker = 0 if empstat!= 1 & !missing(empstat)

* quality check: national avg
preserve 
collapse (mean)salaried_worker [iw=weight], by(countrycode year)
export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\salaried_worker.xlsx", firstrow(variables) sheet(national_all, replace)

* quality check: national avg. female
restore
preserve
keep if male == 0
collapse (mean)salaried_worker [iw=weight], by(countrycode year)
export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\salaried_worker.xlsx", firstrow(variables) sheet(national_female, replace)

* all
restore
preserve
collapse (mean)salaried_worker [iw=weight], by(countrycode year subnatid1)
drop if missing(subnatid1)
export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\salaried_worker.xlsx", firstrow(variables) sheet(subnat_all, replace)


* female 
restore
keep if male == 0
collapse (mean)salaried_worker [iw=weight], by (countrycode year subnatid1) 
drop if missing(subnatid1)
export excel using "C:\Users\wb611670\OneDrive\SAR\scorecards\subnat\salaried_worker.xlsx", firstrow(variables) sheet(subnat_female, replace)

end

main






