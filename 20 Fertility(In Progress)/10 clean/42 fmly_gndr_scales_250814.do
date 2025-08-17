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
*/
	 
/*****************************************
*               family_value              *
******************************************/

/*************************************************************************
2009家庭觀念

tabm e02a_2009 e02b_2009 e02c_2009 e02d_2009 e02e_2009 e02f_2009 e02g_2009 e02h_2009 e02i_2009
*************************************************************************/

local list = "e02a_2009 e02b_2009 e02c_2009 e02d_2009 e02e_2009 e02f_2009 e02g_2009 e02h_2009 e02i_2009"

local i = 1
foreach var of local list {
	recode `var' (6 = .), gen(family_value_q`i'_2009)
	local i = `i' + 1
}
local list = " "
forvalues k = 1(1)9 {
	local list = "`list'" + " " + "family_value_q`k'_2009"
}
factor `list', pf
factor `list', pcf

alpha `list', item

// 家庭價值：9題和，高表認同，有缺遺漏
egen family_value = rowtotal(family_value_q*)

local list = " "
forvalues k = 1(1)9{
	local list = "`list'" + "," + "family_value_q`k'_2009"
}
replace family_value = . if missing(`list')

/*
sum family_value
*/


/*****************************************
*               父母工作              *
******************************************/

/*************************************************************************
2009 

tab1 c23a_2009 c24a_2009,m

無(不知道、缺失) = 0、有 = 1
*************************************************************************/

recode c24a_2009(0 9991/9999 . = 0)(* = 1),gen(mom_work)


/*****************************************
*               16歲父母健在              *
******************************************/

/*************************************************************************
2009 

tab1 f05z02f1_2009 f05z02m1_2009 ,m

tab x01b_2009,m4
*************************************************************************/
gen temage1 = a02z01_2009 + 16
mvdecode f05z02f1_2009 f05z02m1_2009, mv(0 996 998)

gen palive16 = 1
replace palive16 = 0 if temage1 > f05z02f1_2009 & f05z02f1_2009!= .
replace palive16 = 0 if temage1 > f05z02m1_2009 & f05z02m1_2009!= .

drop temage1

/*****************************************
*               父母教育年數             *
******************************************/
/*************************************************************************
2009 

tab1 f03f1_2009 f03m1_2009 ,m

*************************************************************************/
recode f03f1_2009 (1 2 = 0)(3 = 6)(4 = 9)(5 = 12)(6 7 8 = 14) ///
		          (9 = 16)(10 = 18)(11 = 20)(94/99 = .), gen(temeduf)

recode f03m1_2009 (1 2 = 0)(3 = 6)(4 = 9)(5 = 12)(6 7 8 = 14) ///
		          (9 = 16)(10 = 18)(11 = 20)(94/99 = .), gen(temedum)


gen f_edu = temeduf
qui sum temeduf
replace f_edu = r(mean) if temeduf == .

gen m_edu = temedum
qui sum temedum
replace m_edu = r(mean) if temedum == .
			  
gen P_edu = temeduf
replace P_edu = m_edu if (m_edu > f_edu | f_edu == .) & m_edu != .


/*****************************************
*               性別態度               *
******************************************/

/*************************************************************************
2010性別態度：1,2,3題和，高表傳統

tabm d02a_2010 d02b_2010 d02c_2010 d02d_2010 d02e_2010 d02f_2010
*************************************************************************/

local list = "d02a_2010 d02b_2010 d02c_2010 d02d_2010 d02e_2010 d02f_2010"
alpha `list', item
local k = 1
foreach var of local list {
	gen gender_prspct_q0`k'_2010 = `var'
	local k = `k' + 1
}

local list = " "
forvalues k = 2(1)4 {
	local list = "`list'" + " " + "gender_prspct_q0`k'_2010"
}
recode `list' (1 = 5)(2 = 4)(4 = 2)(5 = 1)

local list = " "
forvalues k = 1(1)6 {
	local list = "`list'" + " " + "gender_prspct_q0`k'_2010"
}
recode gender_prspct* (6 = .)
factor `list', pf
factor `list', pcf
alpha `list', item

egen gender_prspct = rowtotal(gender_prspct_q01 gender_prspct_q02 gender_prspct_q03)
local list = " "
forvalues k = 1(1)3{
	local list = "`list'" + "," + "gender_prspct_q0`k'_2010"
}
count if !missing(`list')
replace gender_prspct = . if missing(`list')

/*
sum gender_prspct
*/
