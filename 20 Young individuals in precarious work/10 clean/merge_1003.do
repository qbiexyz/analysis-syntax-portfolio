* Last Updated: 2021. 10. 03
* File name: merge1417
* Data: TYP
* Subject: merge

/*****************************
*          TYP 2014 2017      *
*****************************/

cd "D:\Dropbox\qbiexyz\中研院_工作\TYP_work\new"


***2014
use data\14\group3_14_1002,clear
merge m:1 id2 using data\014
drop group m2sgroup
drop if _merge == 2
gen mis14 = 1 if _merge == 3
drop _merge
save data\merge\mis14


use data\17\group3_17_1002,clear
merge m:1 id2 using data\017
drop group m2sgroup
drop if _merge == 2
gen mis17 = 1 if _merge == 3
drop _merge
save data\merge\mis17


use data\merge\mis14,clear
merge m:1 id2 using data\merge\mis17
drop if mis14 == 1
keep if _merge == 1 
gen m_14 = 1 if _merge == 1 
keep id2 m_14
save data\merge\check17

use data\merge\mis14,clear
merge m:1 id2 using data\merge\mis17
drop if mis17 == 1
keep if _merge == 2 
gen m_17 = 1 if _merge == 2
keep id2 m_17
save data\merge\check14

use data\14\TYP2014_20161121_stata15,clear
sort id2
merge m:1 id2 using data\merge\check14

m2s003000 m2sedu m2s008000(7/10)


use data\17\TYP2017_all_原始資料,clear
sort id2
merge m:1 id2 using data\merge\check17







log using "output\group14 17_1003.txt" ,text replace 

tab _merge

/*
大學以上
*/
tab group3_14 group3_17 if edu1_14 == 1, col chi

/*
二專以下
*/
tab group3_14 group3_17 if edu1_14 == 0, col chi



log close 