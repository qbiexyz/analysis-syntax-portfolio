* Last Updated: 2024. 03. 10
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/
/*
set maxvar 10000
do "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD\20 model\10 clean\10 cd_clean_240307.do"
keep if x01b_2009 == 4
do "20 model\10 clean\11 mar_status_240307.do"
do "20 model\10 clean\31 work_240328.do"
do "20 model\10 clean\32 salary_240318.do"
*/
	 
/*****************************************
*                                   *
******************************************/

/*
lookfor 您是由人力
di r(varlist)

tab1 a11c_2010 a11c_2011 a11c_2012 a09a_2014 a10a_2016 a10a01_2018 w06e_2020
*/

/*************************************************************************
dispatch_status
 0不是 1是 .跳答,虧損,不適用,不知道,拒答 
*************************************************************************/
local list = "a11c_2010 a11c_2011 a11c_2012 a09a_2014 a10a_2016 a10a01_2018 w06e_2020"

local i = 2010
foreach var of local list {
	recode `var' (1 = 1)(2 = 0)(* = .), gen(R_dispatch_`i')

	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

gen R_dispatch_2009 = .
gen R_dispatch_2022 = .

/*
tabm R_dispatch_*
*/

/*************************************************************************
R_work_status_dis

0 無工作 1典型  2 非典型(派遣、<=29 hrs/week) 3 缺失
*************************************************************************/

local i = 2009
forvalues k = 1(1)9 {
	gen R_work_statusD_`i' = .
	replace R_work_statusD_`i' = 0 ///
		if R_work_status_`i' == 0
	replace R_work_statusD_`i' = 1 ///
		if R_work_status_`i' == 1

	replace R_work_statusD_`i' = 2 ///
		if (R_dispatch_`i' == 1 | R_workhour_`i' <= 29) ///
		 & R_work_status_`i' == 1

	replace R_work_statusD_`i' = 3 ///
		if R_work_statusD_`i' == .

	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
} 

/*
tabm R_work_statusD_* if x01b_2009 == 4 , m
tab R_work_status_2022
*/

drop R_dispatch_*

/*
有無兼差
0沒有 1有 .跳答,虧損,不適用,不知道,拒答
lookfor 兼差嗎
di r(varlist)
tabm a12_2010 a12_2011 a12_2012 a13a_2014 a14a_2016 a14a_2018 w15_2020

local list = " a12_2010 a12_2011 a12_2012 a13a_2014 a14a_2016 a14a_2018 w15_2020 "
local i = 2010
foreach var of local list {
	gen R_have_parttime_`i' = `var'
 	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}
recode R_have_parttime_* (1 = 1)(2 = 0)(else = .)
tabm R_have_parttime_*

2018,2020,2022 有問工作身份，將臨時、定契->非典型
lookfor 工作的工作身份
di r(varlist)
R 
tab1 a07b_2018 w05b_2020 c09r1_2022
local list = "a07b_2018 w05b_2020 c09r1_2022"
local i = 2018
foreach var of local list {
	replace R_work_status_with_dispatch_`i' = 1 if inlist(`var',1,2)

	local i = `i' + 2
}
tabm R_work_status_with_dispatch_*
SP
tabm a31b_2018 w37b_2020 c09r2_2022
*/

/*************************************************************************
配偶
是否派遣

lookfor 是由人力
di r(varlist)
tabm a26c_2010 a26c_2011 a26c_2012 a33a_2014 a34a_2016 a34a01_2018 w38e_2020 

//dispatch_status
// 0不是 1是 .跳答,虧損,不適用,不知道,拒答
*************************************************************************/
local list = "a26c_2010 a26c_2011 a26c_2012 a33a_2014 a34a_2016 a34a01_2018 w38e_2020"

local i = 2010
foreach var of local list {
	recode `var' (1 = 1)(2 = 0)(* = .), gen(SP_dispatch_`i')
	replace SP_dispatch_`i' = . if mar_status_`i' != 0
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

gen SP_dispatch_2009 = .
gen SP_dispatch_2022 = .

/*
tabm R_dispatch_*
*/

/*************************************************************************
SP_work_status_dis

0 無工作 1典型  2 非典型(派遣、<=29 hrs/week) 3 缺失
*************************************************************************/

local i = 2009
forvalues k = 1(1)9 {
	gen SP_work_statusD_`i' = .
	replace SP_work_statusD_`i' = 0 ///
		if SP_work_status_`i' == 0
	replace SP_work_statusD_`i' = 1 ///
		if SP_work_status_`i' == 1

	replace SP_work_statusD_`i' = 2 ///
		if (SP_dispatch_`i' == 1 | SP_workhour_`i' <= 29) ///
		 & SP_work_status_`i' == 1

	replace SP_work_statusD_`i' = 3 ///
		if SP_work_statusD_`i' == .

	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
} 

/*
tabm SP_work_status_* SP_work_statusD_* if x01b_2009 == 4 , m
*/

drop SP_dispatch_*