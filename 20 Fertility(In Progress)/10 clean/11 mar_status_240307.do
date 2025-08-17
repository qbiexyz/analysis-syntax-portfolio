* Last Updated: 2024. 03. 07
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/

/*
set maxvar 10000
do "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD\20 model\10 clean\10 cd_clean_240307.do"
*/
	 
/*****************************************
*               婚姻狀態                 *
******************************************/
/*
tab1 d01a01_2009 a16z01_2010 /// 
	 a16a_2011 a16a_2012 a16a_2014 /// 
	 a17a_2016 a17a_2018 /// 
	 w20b_2020 d02_2022
*/ 
/*************************************************************************
婚姻狀態者：過去已婚者、新已婚、同居、再婚 0
非婚姻狀態：未婚、離婚、分居、喪偶 1
流失樣本：已婚成遺漏 2
流失樣本：非婚成遺漏 3

*************************************************************************/

local list = "d01a01_2009 a16z01_2010 a16a_2011 a16a_2012 a16a_2014 a17a_2016 a17a_2018 w20b_2020 d02_2022"
tab1 `list'

local i = 2009
foreach var of local list {
	gen mar_status_`i' = `var'
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*
tab1 mar_status* ,m
*/

recode mar_status_2009 (2 3 4 = 0)(1 6 7 8 = 1)
recode mar_status_2010 (2 3 4 = 0)(1 6 7 8 = 1)
recode mar_status_2011 (1 2 7 = 0)(3/6 9 97 = 1)
recode mar_status_2012 (1 2 7 = 0)(3/6 9 10 97 = 1)
recode mar_status_2014 (1 2 7 = 0)(3/6 8/11 97 = 1)
recode mar_status_2016 (2 = 0)(1 3/5 = 1)
recode mar_status_2018 (2 = 0)(1 3/8 = 1)
recode mar_status_2020 (2 = 0)(1 3/98 = 1)
recode mar_status_2022 (1 2 8 = 0)(4/7 9/98 = 1)


local i = 2009
local j = 2010

forvalues k = 1(1)8 {
	replace mar_status_`j' = 2 ///
	     if inlist(mar_status_`i',0,2) & mar_status_`j' == . 
	replace mar_status_`j' = 3 ///
	     if inlist(mar_status_`i',1,3) & mar_status_`j' == . 
	
	local i = `j'
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
}

/*
tabm mar_status* , missing

brow ///
     d01a01_2009 mar_status_2009 a16z01_2010 mar_status_2010 ///
	 a16a_2011 mar_status_2011 a16a_2012 mar_status_2012 ///
	 a16a_2014 mar_status_2014 a17a_2016 mar_status_2016 ///
	 a17a_2018 mar_status_2018 w20b_2020 mar_status_2020 ///
	 d02_2022 mar_status_2022

*/

/*************************************************************************
資料處理：mar_change

0有有 
1有無 
2無有 
3無無 
.遺漏->遺漏
*************************************************************************/

foreach x of var mar_status_* {
	recode `x' (2 = 0)(3 = 1), gen(n`x')
}

local i = 2009
local j = 2010

forvalues k = 1(1)8 {
	gen mar_change_`j' = .
	replace mar_change_`j' = 0 if nmar_status_`i' == 0 & nmar_status_`j' == 0
	replace mar_change_`j' = 1 if nmar_status_`i' == 0 & nmar_status_`j' == 1
	replace mar_change_`j' = 2 if nmar_status_`i' == 1 & nmar_status_`j' == 0
	replace mar_change_`j' = 3 if nmar_status_`i' == 1 & nmar_status_`j' == 1

	local i = `j'
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
}

drop nmar_status_*

/*
tabm mar_change* if x01b_2009 == 4 ,m
*/
/*
// 持續三波於婚姻組

local l = 2009
local i = 2009
local j = 2010
local m = 2011
forvalues k = 1(1)6 {
	if (`i' == 2009) count if mar_status_`i' == 0 & mar_status_`j' == 0 & mar_status_`m' == 0
	else count if mar_status_`l' != 0 & mar_status_`i' == 0 & mar_status_`j' == 0 & mar_status_`m' == 0
	
	local l = `i'
	local i = `j'
	local j = `m'
	if (`m' >= 2012) local m = `m' + 2
	else local m = `m' + 1
}

// 持續兩波於婚姻組

local l = 2009
local i = 2009
local j = 2010
forvalues k = 1(1)8 {
	if (`i' == 2009) count if mar_status_`i' == 0 & mar_status_`j' == 0 
	else count if mar_status_`l' != 0 & mar_status_`i' == 0 & mar_status_`j' == 0
	
	local l = `i'
	local i = `j'
	
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
	
}

// 不論之前是否持續，連續兩波(此波&上波)處於婚者
local l = 2009
local i = 2009
local j = 2010
forvalues k = 1(1)8 {
	count if mar_status_`i' == 0 & mar_status_`j' == 0 
	
	local l = `i'
	local i = `j'
	
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
	
}
*/