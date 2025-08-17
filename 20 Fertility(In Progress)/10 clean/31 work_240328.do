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
*/
	 
/*****************************************
*            work_status                  *
******************************************/
/*
lookfor 目前有工
di r(varlist)
*/

/*************************************************************************
受訪者工作狀態：work_status
0 無工作 1 有工作
*************************************************************************/

/*
tab1 c01_2009 a05_2010 a05_2011 a05_2012 a05_2014 a06a01_2016 a06a_2018 w03_2020 c02r1_2022, nolabel
*/

local list = "c01_2009 a05_2010 a05_2011 a05_2012 a05_2014 a06a01_2016 a06a_2018 w03_2020 c02r1_2022"
local i = 2009
foreach var of local list {
    gen R_work_status_`i' = `var'
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

foreach var of var R_work_status_2009 - R_work_status_2018 {
	recode `var' (1 = 1)(2 3 = 0)(* = .)
}

recode R_work_status_2020 (1 = 1)(2 3 4 = 0)(* = .)
recode R_work_status_2022 (1 = 1)(2 3 = 0)(* = .)

/*
tabm R_work_status*
*/

/*************************************************************************
差補工作狀態
若缺失，以前一年來補
*************************************************************************/
* 差補
local i = 2009
foreach var of var R_work_status_2010 - R_work_status_2022 {
    replace `var' = R_work_status_`i' if `var' == .

	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*************************************************************************
受訪者工作狀態變化：work_change
處理：0有有、1有無、2無有、3無無

用差補後
ex.上次調查"無"+這次調查"有" == 無有
*************************************************************************/
local i = 2009
local j = 2010
forvalues k = 1(1)8 {
    gen R_work_change_`j' = .
	replace R_work_change_`j' = 0 if inlist(R_work_status_`i',1) ///
	                               & inlist(R_work_status_`j',1)
	replace R_work_change_`j' = 1 if inlist(R_work_status_`i',1) ///
								   & inlist(R_work_status_`j',0) 
	replace R_work_change_`j' = 2 if inlist(R_work_status_`i',0) ///
	                               & inlist(R_work_status_`j',1)
	replace R_work_change_`j' = 3 if inlist(R_work_status_`i',0) ///
	                               & inlist(R_work_status_`j',0)
	local i = `j'
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
}

/*
tab R_work_change_2010
tab R_work_change_2020
tab a06a_2018 w03_2020
tab R_work_status_2009 R_work_status_2010
tabm R_work_status*
tabm R_work_change*
*/

/*************************************************************************
受訪者周工時 work_hour 
168(24 * 7) 視為遺漏

lookfor 在正常
lookfor 在正常的情形下,您這份工
di r(varlist)
sum c07_2009 a11a_2010 a11a_2011 a11a_2012 a09b_2014 a10b01_2016 a10b_2018 w06g_2020
*************************************************************************/
local list = "c07_2009 a11a_2010 a11a_2011 a11a_2012 a09b_2014 a10b01_2016 a10b_2018 w06g_2020 c19r1_2022"

local i = 2009
foreach var of local list {
	gen R_workhour_`i' = `var'
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

* 20 22 年工時跳答 = 996
replace R_workhour_2020 = 0 if w06g_2020 == 996
replace R_workhour_2022 = 0 if c19r1_2022 == 996
recode R_workhour* (168/999 = .)

* 無工作、但收入為缺失 = 0
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022{
	replace R_workhour_`x' = 0 if R_work_status_`x' == 0 ///
                                  & R_workhour_`x' == .
}

* 剩下有工作還是缺失的，用當年度平均差補
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022{
	qui sum R_workhour_`x'
	replace R_workhour_`x' = r(mean) if R_work_status_`x' == 1 ///
                                      & R_workhour_`x' == .
}

/*************************************************************************
受訪配偶工作狀態：SP_work_status_
0 無工作 1 有工作 2 缺失 3 跳答

tab1 d16_2009 a20_2010 a20_2011 a20_2012 a29_2014 a30z01_2016 a30_2018 w36_2020 c02r2_2022
*************************************************************************/ 
local list = "d16_2009 a20_2010 a20_2011 a20_2012 a29_2014 a30z01_2016 a30_2018 w36_2020 c02r2_2022"
local i = 2009
foreach var of local list {
    gen SP_work_status_`i' = `var'
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

foreach var of var SP_work_status_2009 - SP_work_status_2018 {
	recode `var' (1 = 1)(2 3 = 0)(0 = 3)(* = 2)
}

recode SP_work_status_2020 (1 = 1)(2 3 4 = 0)(4 = 3)(96 = 3)(* = 2)
recode SP_work_status_2022 (1 = 1)(2 3 = 0)(96 = 3)(* = 2)


/*************************************************************************
受訪配偶工作狀態變化：SP_work_change

處理：0有有、1有無、2無有、3無無 4 其他(遺漏等))
*************************************************************************/ 

local i = 2009
local j = 2010
forvalues k = 1(1)8 {
    gen SP_work_change_`j' = .
	replace SP_work_change_`j' = 0 if inlist(SP_work_status_`i',1) ///
	                                & inlist(SP_work_status_`j',1) ///
									& inlist(mar_status_`i',0,2) ///
									& mar_status_`j' == 0
	replace SP_work_change_`j' = 1 if inlist(SP_work_status_`i',1) ///
	                                & inlist(SP_work_status_`j',0) ///
									& inlist(mar_status_`i',0,2) ///
									& mar_status_`j' == 0
	replace SP_work_change_`j' = 2 if inlist(SP_work_status_`i',0, 3) ///
	                                & inlist(SP_work_status_`j',1) ///
									& inlist(mar_status_`i',0,2) ///
									& mar_status_`j' == 0
	replace SP_work_change_`j' = 3 if inlist(SP_work_status_`i',0, 3) ///
	                                & inlist(SP_work_status_`j',0, 3) ///
									& inlist(mar_status_`i',0,2) ///
									& mar_status_`j' == 0
	replace SP_work_change_`j' = 4 if SP_work_change_`j' == .
	local i = `j'
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
}


*
recode SP_work_status_* (3 = 2)

/*************************************************************************
受訪配偶周工時 work_hour 
168(24 * 7) 視為遺漏

lookfor )這份工作平均每週
di r(varlist)

tab1 d22_2009 a26a_2010 a26a_2011 a26a_2012 a33b_2014 a34b01_2016 a10b_2018 w38g_2020 c19r2_2022
*************************************************************************/
local list = "d22_2009 a26a_2010 a26a_2011 a26a_2012 a33b_2014 a34b01_2016 a10b_2018 w38g_2020 c19r2_2022"

local i = 2009
foreach var of local list {
	gen SP_workhour_`i' = `var'
	replace SP_workhour_`i' = . if mar_status_`i' != 0
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

* 20 22 年工時跳答 = 996
replace SP_workhour_2020 = 0 if w38g_2020 == 996
replace SP_workhour_2022 = 0 if c19r2_2022 == 996
recode SP_workhour* (168/999 = .)


* 無工作、但收入為缺失 = 0
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022{
	replace SP_workhour_`x' = 0 if SP_work_status_`x' == 0 ///
                                 & SP_workhour_`x' == . ///
								 & mar_status_`x'== 0
}

* 剩下有工作還是缺失的，用當年度平均差補
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022{
	qui sum SP_workhour_`x'
	replace SP_workhour_`x' = r(mean) if SP_work_status_`x' == 1 ///
                                       & SP_workhour_`x' == . ///
								       & mar_status_`x' == 0
}