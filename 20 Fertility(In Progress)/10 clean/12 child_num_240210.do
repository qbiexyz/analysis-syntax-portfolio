* Last Updated: 2024. 03. 07
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/

/*
do "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD\20 model\10 clean\10 cd_clean_240307.do"
do "20 model\10 clean\11 mar_status_240307.do"
*/

/*****************************************
*               有幾個小孩               *
******************************************/

/*
lookfor 有幾個小孩
di r(varlist)

tab1 i01_2009 b12_2010 b12_2011 b12_2012 b13_2014 b15_2016 b11_2018 b11_2020 g02z01_2022 i01_n2016
*/

/*************************************************************************

*************************************************************************/

local list = "i01_2009 b12_2010 b12_2011 b12_2012 b13_2014 b15_2016 b11_2018 b11_2020 g02z01_2022 i01_n2016"

local i = 2009
foreach var of local list {
    gen child_num_`i' = `var'
	replace child_num_`i' = . if child_num_`i' > 90
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

replace child_num_2016 = child_num_2024 if x01b_n2016 == 5

/*
sum child_num*
*/

/*************************************************************************
差補小孩
若缺失，以前一年小孩來補
*************************************************************************/

* 保留沒差補
foreach x of num 2009 2010 2011 2012 2014 2016 2018 2020 2022 {
	gen child_num0_`x' = child_num_`x'
}

* 差補
local i = 2009
foreach var of var child_num_2010 - child_num_2022  {
    replace `var' = child_num_`i' if `var' == .

	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*************************************************************************
檢查小孩有減少之不合理
*************************************************************************/

local i = 2009
local j = 2010
gen child_reduce = .

forvalues k = 1(1)8 {
    replace child_reduce = 1 ///
		if (child_num_`j' < child_num_`i' ///
			& child_num_`j' != . & child_num_`i' != .) 
	
	local i = `j'
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
}
      
/*************************************************************************
修改小孩個數不合理資料
判斷標準
檢查婚姻改變、看有填答小孩資訊之出生年
*************************************************************************/
/*
brow x01 child_num_2009 - child_num_2022 if child_reduce == 1

lookfor 健在子女1
lookfor 子女1:出生年
di r(varlist)

健在子女2目前大概幾歲?
健在子女2性別

brow x01 ///
     d01a01_2009 a16z01_2010 a16a_2011 a16a_2012 a16a_2014 ///
	 a17a_2016 a17a_2018 w20b_2020 d02_2022  ///
	 i02a02z1_2009 b13c01c1_2010 b13c01c1_2011 ///
	 b13c01c1_2012 b14c01c1_2014 b16c01c1_2016 ///
	 b12c01z01c1_2018 b12c01z1c1_2020 g08z01c1_2022 ///
	 i02b02z1_2009 b13c01c2_2010 b13c01c2_2011 ///
	 b13c01c2_2012 b14c01c2_2014 b16c01c2_2016 ///
	 b12c01z01c2_2018 b12c01z1c2_2020 g08z01c2_2022 ///
	 i02c02z1_2009 b13c01c3_2010 b13c01c3_2011 ///
	 b13c01c3_2012 b14c01c3_2014 b16c01c3_2016 ///
	 b12c01z01c3_2018 b12c01z1c3_2020 g08z01c3_2022 ///
     if x01 == 8242320
	 
brow x01 ///
     i01_2009 b12_2010 b12_2011 b12_2012 b13_2014 ///
	 b15_2016 b11_2018 b11_2020 g02z01_2022 ///
	 i02a02z1_2009 b13c01c1_2010 b13c01c1_2011 ///
	 b13c01c1_2012 b14c01c1_2014 b16c01c1_2016 ///
	 b12c01z01c1_2018 b12c01z1c1_2020 g08z01c1_2022 ///
	 i02b02z1_2009 b13c01c2_2010 b13c01c2_2011 ///
	 b13c01c2_2012 b14c01c2_2014 b16c01c2_2016 ///
	 b12c01z01c2_2018 b12c01z1c2_2020 g08z01c2_2022 ///
	 i02c02z1_2009 b13c01c3_2010 b13c01c3_2011 ///
	 b13c01c3_2012 b14c01c3_2014 b16c01c3_2016 ///
	 b12c01z01c3_2018 b12c01z1c3_2020 g08z01c3_2022 ///
     if mar_status_2009 == 0 & mar_status_2010 == 0 ///
	  & mar_status_2011 == 0 & mar_status_2012 == 0 ///
	  & mar_status_2014 == 0 & mar_status_2016 == 0 ///
	  & mar_status_2018 == 0 & mar_status_2020 == 0 ///
	  & mar_status_2022 == 0 
*/  

replace child_num_2016 = 2 if x01 == 1033100
replace child_num_2012 = 1 if x01 == 4372100
replace child_num_2010 = 1 if x01 == 4372310
replace child_num_2012 = 1 if x01 == 5572360
replace child_num_2018 = 2 if x01 == 8303040
replace child_num_2018 = 1 if x01 == 9072320
replace child_num_2022 = 2 if x01 == 9073480
replace child_num_2020 = 3 if x01 == 3372320
replace child_num_2016 = 3 if x01 == 2002040

replace child_num_2012 = 2 if x01 == 2272110
replace child_num_2014 = 3 if x01 == 2272110
replace child_num_2016 = 3 if x01 == 2272110
replace child_num_2018 = 3 if x01 == 2272110

replace child_num_2018 = 2 if x01 == 1122420
replace child_num_2020 = 2 if x01 == 1122420
replace child_num_2022 = 2 if x01 == 1122420

replace child_num_2022 = 2 if x01 == 3003250

replace child_num_2009 = 3 if x01 == 3372130
replace child_num_2011 = 3 if x01 == 3372130

replace child_num_2016 = 3 if x01 == 3372240
replace child_num_2018 = 3 if x01 == 3372240

replace child_num_2022 = 1 if x01 == 4203190
replace child_num_2022 = 3 if x01 == 7372190
replace child_num_2022 = 2 if x01 == 8062140
replace child_num_2022 = 2 if x01 == 8203050


/*
brow x01 child_num_*  if x01b_n2016 == 5 & child_reduce==1

brow x01 ///
	 a17a_2018 w20b_2020 d02_2022  ///
	 b12c01z01c1_2018 b12c01z1c1_2020 g08z01c1_2022 ///
	 b12c01z01c2_2018 b12c01z1c2_2020 g08z01c2_2022 ///
	 b12c01z01c3_2018 b12c01z1c3_2020 g08z01c3_2022 ///
     if x01 == 


x01

2474640
3344140

4114650
4274170
7094160
9234640

*/

replace child_num_2018 = 2 if x01 == 2214290
replace child_num_2022 = 1 if x01 == 3514260