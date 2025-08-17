* Last Updated: 2023. 01. 18
* File name: [new]model
* Data: TYP
* Subject: des

/*****************************
*          des         *
*****************************/
cd "D:\Dropbox\qbiexyz\中研院_工作\TYP_work\new"

*******************************************************************************
*******************************************************************************
*******************************************************************************
***查看 晚上工作問題
cd "D:\Dropbox\qbiexyz\中研院_工作\TYP_work\new"
log using "output/相關_230110.txt", text replace

***2014
use data\14\group_14_230107,clear

gen touse2 = !missing(group4_14, gender14, J314, edu4_14, worksector14, ///
                      firmsize14, supervising14, nightshift14, ///
					  holidayshift14, urbanization14, unemploy14)

keep if touse2 == 1

bysort nightshift14 :sum overtime14
bysort nightshift14 :sum inc14
bysort edu4_14 :tab nightshift14

pwcorr inc14 nightshift14 ,sig
	   
log close

***2017

cd "D:\Dropbox\qbiexyz\中研院_工作\TYP_work\new"
use data\17\group_17_230107,clear

log using "output/相關_230110.txt", text append


***查看 領加班費補修問題
gen touse2 = !missing(group4_17, gender17, J317, edu4_17, worksector17, ///
                      firmsize17, supervising17, nightshift17, ///
					  holidayshift17, urbanization17, unemploy17)

keep if touse2 == 1	   
	   
bysort nosubsidy17 :sum inc17
bysort edu4_17 :tab nosubsidy17

pwcorr Secondjob17 nosubsidy17 Tempjob17 overtime17 inc17 replaced17 ///
       worry17 if touse2 == 1 ,sig

log close

*******************************************************************************
*******************************************************************************
*******************************************************************************
***1417三類交叉

cd "D:\Dropbox\工作\中研院_工作\! done\TYP_work\new"
***2014
use data\14\group_14_nosubsidy_230410,clear

recode group3_14 (1 = 3)(3 = 1)

merge 1:m id2 using "data\17\group_17_nosubsidy_230410.dta"
recode group3_17 (1 = 3)(3 = 1)

tab group3_14 group3_17, row

/*
cd "D:\Dropbox\工作\中研院_工作\! done\TYP_work\new"
***2014
use data\14\group_14_230401,clear



merge 1:m id2 using "data\17\group_17_230401.dta"


tab group3_14 group3_17, row
*/