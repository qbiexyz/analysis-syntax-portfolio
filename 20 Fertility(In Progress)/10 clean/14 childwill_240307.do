* Last Updated: 2024. 03. 10
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/

/*
do "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD\20 model\10 clean\10 cd_clean_240307.do"

do "20 model\10 clean\11 mar_status_240307.do"
do "20 model\10 clean\12 child_num_240210.do"
do "20 model\10 clean\13 child_add_240210.do"
*/

/*****************************************
*               打算(再)生               *
******************************************/

/*
tab1 i04_2009 e03_2010 e03_2011 f03_2012 /// 
d03_2014 d03_2016 d06_2018 b28c_2020 h28_2022

RI2016沒問
*/

/*************************************************************************
0不想再生(不想) 
1想 
2不確定(不確定)

排除非已婚者回答

2009若回答沒小孩，會被跳答(直接變缺失)
*************************************************************************/

local list = "i04_2009 e03_2010 e03_2011 f03_2012 d03_2014 d03_2016 d06_2018 b28c_2020 h28_2022"

* childwill 不知道、拒答缺失版
local i = 2009
foreach var of local list {
	gen childwill_`i' = `var'
	recode childwill_`i' (1 = 1)(2 = 0)(3 = 2)(* = .)
	replace childwill_`i' = . if mar_status_`i' != 0
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*
tab i04_2009 childwill_2009,m
tabm childwill_????
*/

* childwill0 不知道、拒答->不確定

local list = "i04_2009 e03_2010 e03_2011 f03_2012 d03_2014 d03_2016 d06_2018"
local i = 2009
foreach var of local list {
	gen childwill0_`i' = `var'
	recode childwill0_`i' (0 = .)(1 = 1)(2 = 0)(3/99 = 2)
	replace childwill0_`i' = . if mar_status_`i' != 0
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

local i = 2020
foreach var of var b28c_2020 h28_2022 {
	gen childwill0_`i' = `var'
	recode childwill0_`i' (96 = .)(1 = 1)(2 = 0)(3 97/99 = 2)
	replace childwill0_`i' = . if mar_status_`i' != 0
	
	local i = `i' + 2
}

/*
tab h28_2022 childwill0_2022,m
*/

/*****************************************
*               再生性別                 *
******************************************/

/*
tab1 i04_2009 e03_2010 e03_2011 f03_2012 /// 
d03_2014 d03_2016 d06_2018 b28c_2020 h28_2022
*/

/*************************************************************************
childwill
資料處理：wish_sex ,childwill_sex
0 都不 (前面回答 沒有想(再)生))
1 男孩 
2 女孩 
3 都可以 
4 不確定 (前面回答 不確定想(再)生))

tab1 i05_2009 e04_2010 e04_2011 f04_2012 d04_2014 d04_2016 d07_2018 b28d_2020 h29_2022 h30_2022
*************************************************************************/

local list = "i05_2009 e04_2010 e04_2011 f04_2012 d04_2014 d04_2016 d07_2018 b28d_2020"

local i = 2009
foreach var of local list {
	gen wish_sex_`i' = `var'
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}
recode wish_sex_2020 (96 = 0)
recode wish_sex* (4/99 = .)

local i = 2009
forvalues k = 1(1)8 {
	gen childwill_sex_`i' = .
	replace childwill_sex_`i' = 0 if childwill_`i' == 0
	replace childwill_sex_`i' = 1 if wish_sex_`i' == 1
	replace childwill_sex_`i' = 2 if wish_sex_`i' == 2
	replace childwill_sex_`i' = 3 if wish_sex_`i' == 3
	replace childwill_sex_`i' = 4 if childwill_`i' == 2
	replace childwill_sex_`i' = . if mar_status_`i' != 0
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/* 2022 不太能合併，但嘗試看看*/

/*
tab h29_2022 h30_2022
*/

gen childwill_sex_2022 = .
replace childwill_sex_2022 = 0 if childwill_2022 == 0
replace childwill_sex_2022 = 4 if childwill_2022 == 2
replace childwill_sex_2022 = 1 if h29_2022 == 1 & h30_2022 == 1
replace childwill_sex_2022 = 1 if h29_2022 == 4 & h30_2022 == 1
replace childwill_sex_2022 = 1 if h29_2022 == 1 & h30_2022 == 3
replace childwill_sex_2022 = 1 if h29_2022 == 1 & h30_2022 == 4
replace childwill_sex_2022 = 1 if h29_2022 == 1 & h30_2022 == 5
replace childwill_sex_2022 = 2 if h29_2022 == 2 & h30_2022 == 2
replace childwill_sex_2022 = 2 if h29_2022 == 4 & h30_2022 == 2
replace childwill_sex_2022 = 2 if h29_2022 == 2 & h30_2022 == 3
replace childwill_sex_2022 = 2 if h29_2022 == 2 & h30_2022 == 4
replace childwill_sex_2022 = 3 if h29_2022 == 3 & h30_2022 == 3
replace childwill_sex_2022 = 3 if h29_2022 == 3 & h30_2022 == 1
replace childwill_sex_2022 = 3 if h29_2022 == 3 & h30_2022 == 2

drop wish_sex*

// keep x01 mar_status_*
// reshape long mar_status_, i(x01) j(year)