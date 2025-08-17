* Last Updated: 2024. 04. 12
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
do "20 model\10 clean\14 childwill_240307.do"
*/
	 
/*****************************************
*                                *
******************************************/
/*************************************************************************
差補小孩
若缺失，以前一年小孩來補
*************************************************************************/

* 差補
local i = 2009
foreach var of var childwill_2010 - childwill_2022  {
	gen `var'n = `var'
    replace `var'n = childwill_`i' if `var' == .

	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*************************************************************************

*************************************************************************/

local i = 2010
local j = 2011
local child_diff = 0
forvalue k = 1(1)7 {
	gen achieved_`j' = .
	replace achieved_`j' = 1 if inlist(child_add_`j', 0) ///
	                          & childwill_`i'n == 0
	replace achieved_`j' = 2 if inlist(child_add_`j', 1, 2) ///
	                          & childwill_`i'n == 0
	replace achieved_`j' = 3 if inlist(child_add_`j', 0) ///
							  & childwill_`i'n == 1
	replace achieved_`j' = 4 if inlist(child_add_`j', 1, 2) ///
	                          & childwill_`i'n == 1
	replace achieved_`j' = 5 if inlist(child_add_`j', 0) ///
	                          & childwill_`i'n == 2
	replace achieved_`j' = 6 if inlist(child_add_`j', 1, 2) ///
						      & childwill_`i'n == 2
	
	local i = `j'
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
}

drop childwill_????n

/*
egen achieved = rcount(achieved_*) , cond(@ == 4) 
*/
