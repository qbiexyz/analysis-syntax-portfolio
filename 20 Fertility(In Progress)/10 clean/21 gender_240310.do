* Last Updated: 2024. 03. 10
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/

/*
do "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD\20 model\10 clean\10 cd_clean_240307.do"
*/
	 
/*****************************************
*               受訪者性別                 *
******************************************/

/*************************************************************************
受訪者性別: 0女1男

lookfor 受訪者性別
di r(varlist)

tabm a01_2009 a01_2010 a01_2011 a01_2012 a01_2014 a01_2016 a01_2018 a01_2020 a01_2022 a01_n2016
*************************************************************************/

local list = "a01_2009 a01_2010 a01_2011 a01_2012 a01_2014 a01_2016 a01_2018 a01_2020 a01_2022 a01_n2016"
local i = 2009
foreach var of local list {
	gen R_gender_`i' = `var'
	recode R_gender_`i' (1 = 1)(2 = 0)
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

replace R_gender_2016 = R_gender_2024 if x01b_n2016 == 5

/*
tabm R_gender_*
*/	

/*
檢查性別有無變化
brow x01 a02a_2018 a02a_2020 R_gender_* ///
 if (R_gender_2010 != R_gender_2009 ///
     & R_gender_2010 != . & R_gender_2009 != .) ///
  | (R_gender_2011 != R_gender_2010 ///
     & R_gender_2011 != . & R_gender_2010 != .) ///
  | (R_gender_2012 != R_gender_2011 ///
     & R_gender_2012 != . & R_gender_2011 != .) ///
  | (R_gender_2014 != R_gender_2012 ///
     & R_gender_2014 != . & R_gender_2012 != .) ///
  | (R_gender_2016 != R_gender_2014 ///
     & R_gender_2016 != . & R_gender_2014 != .) ///
  | (R_gender_2018 != R_gender_2016 ///
     & R_gender_2018 != . & R_gender_2016 != .) ///
  | (R_gender_2020 != R_gender_2018 ///
     & R_gender_2020 != . & R_gender_2018 != .) ///
  | (R_gender_2022 != R_gender_2020 ///
     & R_gender_2022 != . & R_gender_2020 != .)
*/	 

replace R_gender_2020 = 1 if x01 == 1042110
replace R_gender_2020 = 0 if x01 == 7373090
replace R_gender_2020 = 0 if x01 == 7224030

* 留一個
egen R_male = rmax(R_gender_*) 

lab var R_male "男性"

drop R_gender_2009 - R_gender_2022