* Last Updated: 2024. 03. 14
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/

/*
do "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD\20 model\10 clean\10 cd_clean_240307.do"

do "20 model\10 clean\11 mar_status_240307.do"
do "20 model\10 clean\22 age_240310.do"
*/
	 
/*****************************************
*               edu                    *
******************************************/
/*
lookfor 教育程度是
di r(varlist)
tab1 b01_2009 d13_2009 a03c_2010 a18_2010 b18a_2010 a03c_2011 a18_2011 b18a_2011 a03c_2012 a18_2012 b18a_2012 a03c_2014 a27_2014 a03c_2016 a28_2016 a42z01_2016 a03a_2018 a27_2018 a03a_2020 w31_2020
*/

/*************************************************************************
受訪者最高教育程度

受訪者最高edu：R_edu_2020
lookfor 您最高的教育程度
di r(varlist)
tab1 b01_2009 a03c_2010 a03c_2011 a03c_2012 a03c_2014 a03c_2016 a03a_2018 a03a_2020
*************************************************************************/
local list = "b01_2009 a03c_2010 a03c_2011 a03c_2012 a03c_2014 a03c_2016 a03a_2018 a03a_2020 b01_2022"

local i = 2009
foreach var of local list {
	gen R_edu_`i'= `var'
	if (`i' <= 2014){
	    recode R_edu_`i' (1 = 0)(3 = 6)(4 5 = 9)(6/8 = 12)(9 10 11 = 14) ///
		                 (12 13 = 16)(14 = 18)(15 = 20)(2 94/99 = .)
	}
	else{
	    recode R_edu_`i' (1 = 0)(3 = 6)(4 = 9)(5/8 = 12)(9 10 11 = 14) ///
		                 (12 13 = 16)(14 = 18)(15 = 20)(2 94/99 = .)
	}
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

sum R_edu_*

/*************************************************************************
差補教育程度
以前一年來補(用來之後辨認)
*************************************************************************/
foreach x of num 2009/2012 2014 2016 2018 2020 2022 {
	clonevar R_edun_`x' = R_edu_`x' 
}

local i = 2009
foreach var of var R_edun_2010 - R_edun_2022  {
    replace `var' = R_edun_`i' if `var' == .

	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

replace R_edun_2009 = 16 if x01 == 1123350
replace R_edun_2010 = 16 if x01 == 1123350

/*************************************************************************
檢查教育程度有減少之不合理
*************************************************************************/
* 有填寫之最高教育程度
egen R_edu_max = rmax(R_edun_*)

gen R_edu_reduce = 1 ///
 if (R_edun_2010 < R_edun_2009 ///
     & R_edun_2010 != . & R_edun_2009 != .) ///
  | (R_edun_2011 < R_edun_2010 ///
     & R_edun_2011 != . & R_edun_2010 != .) ///
  | (R_edun_2012 < R_edun_2011 ///
     & R_edun_2012 != . & R_edun_2011 != .) ///
  | (R_edun_2014 < R_edun_2012 ///
     & R_edun_2014 != . & R_edun_2012 != .) ///
  | (R_edun_2016 < R_edun_2014 ///
     & R_edun_2016 != . & R_edun_2014 != .) ///
  | (R_edun_2018 < R_edun_2016 ///
     & R_edun_2018 != . & R_edun_2016 != .) ///
  | (R_edun_2020 < R_edun_2018 ///
     & R_edun_2020 != . & R_edun_2018 != .) ///
  | (R_edun_2022 < R_edun_2020 ///
     & R_edun_2022 != . & R_edun_2020 != .) 
	 
gen R_edu_add = 1 ///
 if (R_edun_2010 > R_edun_2009 ///
     & R_edun_2010 != . & R_edun_2009 != .) ///
  | (R_edun_2011 > R_edun_2010 ///
     & R_edun_2011 != . & R_edun_2010 != .) ///
  | (R_edun_2012 > R_edun_2011 ///
     & R_edun_2012 != . & R_edun_2011 != .) ///
  | (R_edun_2014 > R_edun_2012 ///
     & R_edun_2014 != . & R_edun_2012 != .) ///
  | (R_edun_2016 > R_edun_2014 ///
     & R_edun_2016 != . & R_edun_2014 != .) ///
  | (R_edun_2018 > R_edun_2016 ///
     & R_edun_2018 != . & R_edun_2016 != .) ///
  | (R_edun_2020 > R_edun_2018 ///
     & R_edun_2020 != . & R_edun_2018 != .) ///
  | (R_edun_2022 > R_edun_2020 ///
     & R_edun_2022 != . & R_edun_2020 != .) 

/*
R_edu_add if R_edu_reduce != 1 ,m
*/

* 教育程度不同個數
egen R_edu_diff = rownvals(R_edun_*)

* 最常出現教育程度不同個數
egen R_edu_com = rowmedian(R_edun_*)

* 教育程度變化次數
gen temp = R_edun_2009
gen R_edu_change = 0
foreach var of var R_edun_???? {
    replace R_edu_change = R_edu_change + 1 if `var' != temp
    replace temp = `var'
}

drop temp

/*************************************************************************
直接使用最大值當作最高教育年數可能不正確者

若是最大教育年數不等於最近一次調查的值，
以最常出現的值 | 最後一次填寫 替代
brow x01 ///
     R_edu_2009 - R_edu_2022 R_edu_max R_edu_com ///
     if R_edu_max != R_edu_com if R_edu_reduce == 1

詢問畢業狀況
age_2009 b02z01_2009 b02z02_2009 a03b_2018 ///
a03b_2020 a03c_2020 a03d_2020 b02_2022 b03z01_2022 b04_2022 
*************************************************************************/
replace R_edu_max = R_edun_2022 if R_edu_reduce == 1 & R_edu_change == 1 

replace R_edu_max = R_edu_com ///
	if R_edu_max != R_edun_2022 & R_edu_reduce == 1 & R_edu_change != 1

drop R_edu_2009 - R_edun_2022 R_edu_reduce - R_edu_change
/*************************************************************************
配偶最高教育程度

受訪者配偶最高edu：SP_edu_2016(正常的)
lookfor )的最高教育程度
di r(varlist)
tab1 d13_2009 a18_2010 a18_2011 a18_2012 a27_2014 a28_2016 a27_2018 w31_2020
*************************************************************************/

local list = "d13_2009 a18_2010 a18_2011 a18_2012 a27_2014 a28_2016 a27_2018 w31_2020 d39_2022"

local i = 2009
foreach var of local list {
	gen SP_edu_`i'= `var'
	replace SP_edu_`i' = . if mar_status_`i' != 0
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

recode SP_edu_* (1 = 0)(3 = 6)(4 5 = 9)(6/8 = 12)(9 10 11 = 14) ///
                (12 13 = 16)(14 = 18)(15 = 20)(2 94/99 = .)

sum SP_edu_*

//跳問 
//2014 非 變化成為婚姻狀態者 皆被跳問
tab a16a_2014 if a16a_2014 == 7
tab a27_2014 if a27_2014 != 0
replace SP_edu_2014 = SP_edu_2012 if a16a_2014 != 7
sum SP_edu_2014

//2018 已婚且未變化者 被跳問
tab1 a17a_2018 a17b_2018
replace SP_edu_2018 = SP_edu_2016 if a17a_2018 == 2 & a17b_2018 == 2
sum SP_edu_2018

//2020 已婚且未變化者 被跳問
tab1 w20a_2020 w20b_2020, nolabel
replace SP_edu_2020 = SP_edu_2018 if w20a_2020 == 2 & w20b_2020 == 2
sum SP_edu_2020


//非婚姻狀態 遺漏化
local i = 2009
forvalues k = 1(1)8 {
    replace SP_edu_`i' = . if mar_status_`i' != 0
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

* 有填寫之最高教育程度
egen SP_edu_max = rmax(SP_edu_*)

drop SP_edu_????