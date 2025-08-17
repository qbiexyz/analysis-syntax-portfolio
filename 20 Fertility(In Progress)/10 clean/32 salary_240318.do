* Last Updated: 2024. 03. 18
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/

/*
set maxvar 10000
do "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD\20 model\10 clean\10 cd_clean_240307.do"
do "20 model\10 clean\11 mar_status_240307.do"
do "20 model\10 clean\31 work_240328.do"
*/

/*****************************************
*               income                    *
******************************************/
/*
lookfor 這份工作平均每個月的總收入
di r(varlist)
lookfor 您這份工作平均每個月的總收入
di r(varlist)
lookfor 您這份工作平均每個月的總收入有多少
di r(varlist)
*/
/*************************************************************************
受訪者 有數字 ，2022 z01 萬 z02 千
tab1 c08a_2009 a10a_2010 a10a_2011 a10a_2012 a08a_2014 a09a01_2016 a09a01_2018 w06a_2020 c15z01r1_2022 c15z02r1_2022
tab1 c08a_2009

lookfor 您這份工作平均每個月的總收入大約
di r(varlist)
受訪者 分組
tab1 c08b_2009 a10b_2010 a10b_2011 a10b_2012 a08b_2014 a09a02_2016 a09a02_2018 w06b_2020 c18r1_2022, m
*************************************************************************/

* 先處理收入分組
local list = "c08b_2009 a10b_2010 a10b_2011 a10b_2012 a08b_2014 a09a02_2016 a09a02_2018 w06b_2020 c18r1_2022"

local i = 2009
foreach var of local list {
	gen R_ginc_`i' = `var'
	mvdecode R_ginc_`i', mv(0 96/99)

	gen R_incm_`i' = .
	replace R_incm_`i' = 0 if R_ginc_`i' == 1
	replace R_incm_`i' = (R_ginc_`i' - 2)*1 + .5 ///
		if R_ginc_`i' >= 2 & R_ginc_`i' <= 21

	replace R_incm_`i' = 25 if R_ginc_`i' == 22 
	replace R_incm_`i' = 30 if R_ginc_`i' == 23 & `i' <= 2016
	replace R_incm_`i' = 35 if R_ginc_`i' == 23 & `i' >= 2018
	replace R_incm_`i' = 40 if R_ginc_`i' == 24 & `i' >= 2018	
	replace R_incm_`i' = . if R_ginc_`i' == .

	replace R_incm_`i' = R_incm_`i' * 10000

	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

* 自填收入
local list = "c08a_2009 a10a_2010 a10a_2011 a10a_2012 a08a_2014 a09a01_2016 a09a01_2018 w06a_2020"
 
/*
有些跳答在0或是9999996
之後這些都變成0
*/
local i = 2009
foreach var of local list {
    gen R_salarym_`i' = `var'
	replace R_salarym_`i' = . ///
		if R_salarym_`i' >= 9910000 | R_salarym_`i' < 0
	
	replace R_salarym_`i' = R_incm_`i' ///
		if !inlist(R_incm_`i', 0, .)
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*
處理2022 自填收入 z01 萬 z02 千
如果金額輸入錯誤 用分組取代 
c16r1_2022 == 2
*/
mvdecode c15z01r1_2022 c15z02r1_2022, mv(991/999)
gen R_salarym_2022 = c15z01r1_2022 * 10000 + c15z02r1_2022 * 1000
replace R_salarym_2022 = R_incm_2022 if c16r1_2022 == 2
replace R_salarym_2022 = R_incm_2022 if !inlist(R_incm_2022, 0, .)

* 再確認回答無工作，若缺失為0
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022{
	replace R_salarym_`x' = 0 ///
		if R_work_status_`x' == 0 & R_salarym_`x' == .
}

drop R_ginc_* R_incm_*


/*
mdesc R_salarym_* if x01b_2009 == 4

剩下還有回答有工作但收入缺失者
brow R_salarym_* a09a01_2016 a09a02_2016 ///
     R_work_change_2016 ///
	 if x01b_2009 == 4 & R_salarym_2016 == . 
*/

* 先做一個有缺失的類別收入
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022{
	/*按照每一年不同(包括0去算) 低 中 高 比例*/
	xtile R_salarymg_`x' = R_salarym_`x' if x01b_2009 == 4, nq(3)
	replace R_salarymg_`x' = 4 if R_salarymg_`x' == .
}

* 另外剩下有工作還是缺失的，用當年度平均差補
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022{
	gen R_salarymtg_`x' = R_salarym_`x'
	replace R_salarymtg_`x' = . if R_salarymtg_`x' == 0
	
	qui sum R_salarymtg_`x'
	gen R_salarymtgm_`x' = r(mean)
	replace R_salarym_`x' = R_salarymtgm_`x' ///
		if R_work_status_`x' == 1 & R_salarym_`x' == .
}

/*************************************************************************
受訪者配偶收入
lookfor )這份工作平均每個月的總收入
di r(varlist)
tab1 d23a_2009 a25a_2010 a25a_2011 a25a_2012 a32a_2014 a33a01_2016 a33a01_2018 w38a_2020 
*************************************************************************/

* 先處理收入分組
local list = "d23b_2009 a25b_2010 a25b_2011 a25b_2012 a32b_2014 a33a02_2016 a33a02_2018 w38b_2020 c18r2_2022"

local i = 2009
foreach var of local list {
	gen SP_ginc_`i' = `var'
	mvdecode SP_ginc_`i', mv(0 96/99)

	gen SP_incm_`i' = .
	replace SP_incm_`i' = 0 if SP_ginc_`i' == 1
	replace SP_incm_`i' = (SP_ginc_`i' - 2)*1 + .5 ///
		if SP_ginc_`i' >= 2 & SP_ginc_`i' <= 21

	replace SP_incm_`i' = 25 if SP_ginc_`i' == 22 
	replace SP_incm_`i' = 30 if SP_ginc_`i' == 23 & `i' <= 2016
	replace SP_incm_`i' = 35 if SP_ginc_`i' == 23 & `i' >= 2018
	replace SP_incm_`i' = 40 if SP_ginc_`i' == 24 & `i' >= 2018	
	replace SP_incm_`i' = . if SP_ginc_`i' == .

	replace SP_incm_`i' = SP_incm_`i' * 10000

	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

* 自填收入
local list = "d23a_2009 a25a_2010 a25a_2011 a25a_2012 a32a_2014 a33a01_2016 a33a01_2018 w38a_2020"
 
/*
有些跳答在0或是9999996
之後這些都變成0
*/
local i = 2009
foreach var of local list {
    gen SP_salarym_`i' = `var'
	replace SP_salarym_`i' = . ///
		if SP_salarym_`i' >= 9910000 | SP_salarym_`i' < 0
	
	replace SP_salarym_`i' = SP_incm_`i' ///
		if !inlist(SP_incm_`i', 0, .)
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*
處理2022 自填收入 z01 萬 z02 千
如果金額輸入錯誤 用分組取代 
c16r1_2022 == 2
*/
mvdecode c15z01r2_2022 c15z02r2_2022, mv(991/999)
gen SP_salarym_2022 = c15z01r2_2022 * 10000 + c15z02r2_2022 * 1000
replace SP_salarym_2022 = SP_incm_2022 if c16r2_2022 == 2
replace SP_salarym_2022 = SP_incm_2022 if !inlist(SP_incm_2022, 0, .)

* 再確認回答無工作，若缺失為0
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022{
	replace SP_salarym_`x' = 0 ///
		if SP_work_status_`x' == 0 & SP_salarym_`x' == .
}

drop SP_ginc_* SP_incm_*


/*
mdesc SP_salarym_* if x01b_2009 == 4

剩下還有回答有工作但收入缺失者
brow SP_salarym_* a09a01_2016 a09a02_2016 ///
     SP_work_change_2016 ///
	 if x01b_2009 == 4 & SP_salarym_2016 == . 
*/



* 先做一個有缺失的類別收入
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022{
	/*按照受訪者每一年不同 低 中 高 比例*/
	egen qq25_`x' = pctile(R_salarym_`x') , p(33.33)
	egen qq75_`x' = pctile(R_salarym_`x') , p(66.66)

	gen SP_salarymg_`x' = .
	replace SP_salarymg_`x' = 1 ///
		if SP_salarym_`x' <= qq25_`x' & SP_salarym_`x' >= 0
	replace SP_salarymg_`x' = 2 ///
		if SP_salarym_`x' > qq25_`x' & SP_salarym_`x' <= qq75_`x'
	replace SP_salarymg_`x' = 3 ///
		if SP_salarym_`x' >= qq75_`x' & SP_salarym_`x' != .		
	replace SP_salarymg_`x' = 4 ///
		if SP_salarymg_`x' == .		

	drop qq25_`x' qq75_`x'
}


* 另外剩下有工作還是缺失的，用配偶當年度平均差補
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022{
	gen SP_salarymtg_`x' = SP_salarym_`x'
	replace SP_salarymtg_`x' = . if SP_salarymtg_`x' == 0
	
	qui sum SP_salarymtg_`x'
	gen SP_salarymtgm_`x' = r(mean)
	replace SP_salarym_`x' = SP_salarymtgm_`x' ///
		if SP_work_status_`x' == 1 & SP_salarym_`x' == .
}

drop SP_salarymtgm_* R_salarymtgm_*
