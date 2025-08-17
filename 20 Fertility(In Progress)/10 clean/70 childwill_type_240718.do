* Last Updated: 2024. 04. 15
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/

cd "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD"

/*
do "20 model\10 clean\51 keep.do"
*/

use "10 data\PSDF_09t22_analysis.dta", clear

/*************************************************************************

*************************************************************************/

* 只保留已婚
keep if mar_status_ == 0
* 刪除小孩減少
drop if child_reduce == 1

* 刪除2009
drop if year == 2009

/*************************************************************************

*************************************************************************/

tostring x01, gen(id)
tostring child_num_, gen(child_nums_)
gen newid = id + "_" + child_nums_

bysort newid : egen year_str = min(year)
bysort newid : egen year_end = max(year)


* child_num_max 
bysort x01 : egen child_num_max = max(child_num_)

* child_num_min
bysort x01 : egen child_num_min = min(child_num_)


keep ///
newid x01 year year_str year_end mar_status_ ///
 child_num_ child_num_max child_num_min childwill0_ childwill_sex_ ///
R_male age30 age_ R_edu_max SP_edu_max ///
cohabit_num_ Is_pa_or_gr_cohabit_ Is_pa_cohabit_ Is_gr_cohabit_ ///
R_work_status_ R_work_change_ R_work_statusD_ SP_work_status_ ///
SP_work_change_ SP_work_statusD_ R_salarym_ R_salarymg_ SP_salarym_ siblings ///
SP_salarymg_ R_workhour_ SP_workhour_ R_health_ SP_health_ ///
family_value mom_work palive16 f_edu m_edu P_edu gender_prspct ////
R_on_housework_per_week_ SP_on_housework_per_week_  

ren childwill0_ childwill3_ /**/

recode childwill3_ (2 = 0), gen(childwill2_)

reshape wide ///
mar_status_  childwill2_ childwill3_ childwill_sex_ ///
age_ ///
cohabit_num_ Is_pa_or_gr_cohabit_ Is_pa_cohabit_ Is_gr_cohabit_  ///
R_work_status_ R_work_change_ R_work_statusD_ SP_work_status_ ///
SP_work_change_ SP_work_statusD_ R_salarym_ R_salarymg_ SP_salarym_  ///
SP_salarymg_ R_workhour_ SP_workhour_ R_health_ SP_health_  ///
R_on_housework_per_week_ SP_on_housework_per_week_  ///
, i(newid) j(year)

order ///
mar_status_*  childwill2_* childwill3_* childwill_sex_* ///
age_* ///
cohabit_num_* Is_pa_or_gr_cohabit_* Is_pa_cohabit_* Is_gr_cohabit_* siblings ///
R_work_status_* R_work_change_* R_work_statusD_* SP_work_status_* ///
SP_work_change_* SP_work_statusD_* R_salarym_* ///
R_salarymg_* SP_salarym_*  ///
SP_salarymg_* R_workhour_* SP_workhour_* R_health_* SP_health_*  ///
R_on_housework_per_week_* SP_on_housework_per_week_*  

* 有再生
gen child_new = 0
replace child_new = 1 if  child_num_max > child_num_

* year_gap
gen year_gap0 =  year_end - year_str

/*若有生育則是結尾是下一波生*/
gen year_gap = year_gap0
replace year_gap = year_gap0 + 1 if child_new == 1 & year_end < 2012
replace year_gap = year_gap0 + 2 if child_new == 1 & year_end >= 2012

recode year_gap (0/2 = 0 "短") ///
                (3/12 = 1 "長") , gen (year_gapc2) 

				
/*************************************************************************
childwill_t3_
*************************************************************************/
* 開始結束的生育意願
gen childwill3_str = .
gen childwill3_end = .
foreach x of num 2010 2011 2012 2014 2016 2018 2020 2022 {
	replace childwill3_str = childwill3_`x' ///
		if year_str == `x' & mar_status_`x' != .
	replace childwill3_end = childwill3_`x' ///
		if year_end == `x' & mar_status_`x' != .
}

* 中間有不一樣的想法
gen childwill3_dif = 0
foreach x of num 2011 2012 2014 2016 2018 2020  {
	replace childwill3_dif = 1  if (childwill3_`x' != childwill3_str ///
	                            & childwill3_`x' != . ) ///
								& (childwill3_`x' != childwill3_end ///
	                            & childwill3_`x' != . ) ///
								& (year_str != `x' & year_end != `x')
}

/*************************************************************************
childwill_t2_
*************************************************************************/
* 開始結束的生育意願
gen childwill2_str = .
gen childwill2_end = .
foreach x of num 2010 2011 2012 2014 2016 2018 2020 2022 {
	replace childwill2_str = childwill2_`x' ///
		if year_str == `x' & mar_status_`x' != .
	replace childwill2_end = childwill2_`x' ///
		if year_end == `x' & mar_status_`x' != .
}

* 中間有不一樣的想法
gen childwill2_dif = 0
foreach x of num 2011 2012 2014 2016 2018 2020  {
	replace childwill2_dif = 1  if (childwill2_`x' != childwill2_str ///
	                            & childwill2_`x' != . ) ///
								& (childwill2_`x' != childwill2_end ///
	                            & childwill2_`x' != . ) ///
								& (year_str != `x' & year_end != `x')
}

* 去除開始跟結尾，中間有表達想生
gen childwill2_want = 0
foreach x of num 2011 2012 2014 2016 2018 2020  {
	replace childwill2_want = 1  if (childwill2_`x' == 1 ) ///
						         & (year_str != `x' & year_end != `x')
}


foreach x of num 2010 2011 2012 2014 2016 2018 2020  {
	replace childwill2_want = 1  if (childwill2_`x' == 1 ) ///
	                             & (year_str == `x' & year_end == `x') ///
								 & year_gap0 == 0
}

local w = 2014
foreach x of num 2012 2014 2016 2018 2020 {

	replace childwill2_want = 1 if (childwill2_str == 1 ///
	                             | childwill2_end == 1) ///
                                 & year_str == `x' & year_end == `w' ///
								 & year_gap0 == 2
local w = 2 + `w'				
}

local i = 2011
foreach x of num 2010 2011   {
	replace childwill2_want = 1 if (childwill2_str == 1 ///
	                             | childwill2_end == 1) ///
                                 & year_str == `x' & year_end == `i' ///
								 & year_gap0 == 1
    local i = 1 + `i'
}

/*************************************************************************

*************************************************************************/
gen childwill_nn = 0
foreach x of num 2010 2011 2012 2014 2016 2018 2020 2022 {
	replace childwill_nn = 1 ///
		if childwill3_`x' == 2
}

replace childwill_nn = 1 - childwill_nn
*
foreach x of var childwill2_str childwill2_end childwill2_dif ///
                 childwill3_str childwill3_end childwill3_dif  {
	tostring `x', gen(t`x')
}

gen childwill2_t1 = tchildwill2_str + tchildwill2_end
gen childwill2_t2 = tchildwill2_str + tchildwill2_end + tchildwill2_dif

gen childwill3_t1 = tchildwill3_str + tchildwill3_end
gen childwill3_t2 = tchildwill3_str + tchildwill3_end + tchildwill3_dif

/*************************************************************************
age_ ///
cohabit_num_ Is_pa_or_gr_cohabit_ Is_pa_cohabit_ Is_gr_cohabit_  ///
R_work_status_ R_work_change_ R_work_statusD_ SP_work_status_ ///
SP_work_change_ SP_work_statusD_ R_salarym_ R_salarymg_ SP_salarym_  ///
SP_salarymg_ R_workhour_ SP_workhour_ R_health_ SP_health_  ///
R_on_housework_per_week_ SP_on_housework_per_week_  ///
**********************************************************i***************/

local tem ///
"age_ cohabit_num_ Is_pa_or_gr_cohabit_ Is_pa_cohabit_ Is_gr_cohabit_ R_work_status_ R_work_change_ R_work_statusD_ SP_work_status_ SP_work_change_ SP_work_statusD_ R_salarym_ R_salarymg_ SP_salarym_ SP_salarymg_ R_workhour_ SP_workhour_ R_health_ SP_health_ R_on_housework_per_week_ SP_on_housework_per_week_"

*
foreach x of local tem {
	gen `x'str = .
	gen `x'end = .
	foreach y of num 2010 2011 2012 2014 2016 2018 2020 2022 {
		replace `x'str = `x'`y' ///
			if year_str == `y' & mar_status_`y' != .
		replace `x'end = `x'`y' ///
			if year_end == `y' & mar_status_`y' != .
	}
	gen `x'diff = `x'end - `x'str 
}

* R_work_change
gen R_work_change = 0
foreach x of num 2011 2012 2014 2016 2018 2020  {
	replace R_work_change = 1  if (R_work_change_`x' != 0 ///
	                            & R_work_change_`x' != . ) ///
								& (year_str != `x' & year_end != `x')
}

replace R_work_change = 1 if ///
	  (R_work_change_str != 0 & R_work_change_str != .) ///
	| (R_work_change_end != 0 & R_work_change_end != .)




/*************************************************************************

*************************************************************************/
lab val R_work_status_* SP_work_status_* work_status_
lab val R_work_change_* SP_work_change_* work_change_
lab val R_work_statusD_* SP_work_statusD_* work_statusD_
lab val R_salarymg_*  SP_salarymg_* salarym_

/*************************************************************************

*************************************************************************/
keep ///
     newid x01 year_str year_end year_gap0 year_gap year_gapc2 ///
	 R_male age30 R_edu_max SP_edu_max ///
	 family_value mom_work palive16 f_edu m_edu P_edu gender_prspct siblings ///
     child_num_ child_num_max child_num_min child_new ///
	 childwill2_str childwill2_end childwill2_dif childwill2_want ///
	 childwill3_str childwill3_end childwill3_dif childwill_nn ///
	 childwill2_t1 childwill2_t2 childwill3_t1 childwill3_t2 ///
	 age_str - SP_on_housework_per_week_diff R_work_change 

order ///
     newid x01  ///
	 R_male age30 R_edu_max SP_edu_max ///
	 family_value mom_work palive16 f_edu m_edu P_edu gender_prspct siblings ///
	 year_str year_end year_gap year_gap0 year_gapc2 ///
     child_num_ child_num_max child_num_min child_new ///
	 childwill2_str childwill2_end childwill2_dif childwill2_want ///
	 childwill3_str childwill3_end childwill3_dif childwill_nn ///
	 childwill2_t1 childwill2_t2 childwill3_t1 childwill3_t2 ///
	 age_str - SP_on_housework_per_week_diff R_work_change 
	 
sort child_num_ child_new year_gap childwill3_str childwill3_end 

/*************************************************************************

*************************************************************************/

lab var newid "受訪者編號_小孩數"
lab var year_str "開始年"
lab var year_end "結束年(有生小孩的前一波)"
lab var year_gap "結束-開始(若有生育則是結尾是下一波生)"
lab var year_gapc2 "結束-開始_二類"
lab var child_num_max "最後調查時的小孩數"
lab var child_num_min "最開始有資料時的小孩數"
lab var child_new "是否之後有生小孩"
lab var childwill2_str "生育意願兩類_開始年"
lab var childwill2_end "生育意願兩類_結束年"
lab var childwill2_dif "生育意願兩類_中間是否搖擺"
lab var childwill2_want "生育意願兩類_中間是否明確表示想生"
lab var childwill3_str "生育意願三類_開始年"
lab var childwill3_end "生育意願三類_結束年"
lab var childwill3_dif "生育意願三類_中間是否搖擺"
lab var childwill_nn "生育意願_中間沒有不確定"
lab var childwill2_t1 "生育意願兩類_第一類"
lab var childwill2_t2 "生育意願兩類_第二類"
lab var childwill3_t1 "生育意願三類_第一類"
lab var childwill3_t2 "生育意願三類_第二類"

/*************************************************************************

*************************************************************************/

lab def childwill2 0 "不想(再)生/不確定" 1 "想(再)生"
lab val childwill2_str childwill2
lab val childwill2_end childwill2

recode childwill3_str childwill3_end (2 = 0.5)

lab def childwill3 0 "不想(再)生" 1 "想(再)生" 2 "不確定想不想(再)生"
lab val childwill3_str childwill3
lab val childwill3_end childwill3


* 單年度 沒有之後意願結果(沒變化)
drop if year_gap == 0


recode child_num_ (0 = 0)(1 = 1)(2/4 = 2), gen(childnum_g3)

gen age33 = 0
replace age33 = 1 if age_end >= 33

save "10 data\PSDF_childwill_type.dta", replace