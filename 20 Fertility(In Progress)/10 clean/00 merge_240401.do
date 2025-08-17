* Last Updated: 2024. 03. 29
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/


cd "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD"


/*****************************************
*                              *
******************************************/


/*************************************************************************
保留RI2016新樣本在18-22資料
把RI2016當作2024(之後方便處理)
*************************************************************************/

use "10 data\10 merge\psfd_ri2016_v202110_stata.dta", clear
rename * *_n2016
rename x01_* x01
compress

*
merge 1:1 x01 using "10 data\10 merge\RR2018_v201907_stata.dta"
rename * *_2018
rename x01_* x01

rename *n2016* *n2016

drop if _merge == 2
drop _merge
*
merge 1:1 x01 using "10 data\10 merge\RR2020.dta"
rename * *_2020
rename x01_* x01

rename *2018* *2018
rename *n2016* *n2016

drop if _merge == 2
drop _merge
clonevar id = x01
*
merge 1:1 id using "10 data\10 merge\RR2022_completed_0620.dta"
rename * *_2022
rename x01_* x01
drop id_*

rename *n2016* *n2016
rename *2018* *2018
rename *2020* *2020

drop if _merge == 2
drop _merge

compress
save "10 data\10 merge\RI16t22.dta", replace

/*************************************************************************
合併到原本2009主樣本資料
*************************************************************************/

use "10 data\2009_merge.dta", clear
append using "10 data\10 merge\RI16t22.dta"

compress
save "10 data\RI09toRR22&RI16tRR22_merge.dta", replace

