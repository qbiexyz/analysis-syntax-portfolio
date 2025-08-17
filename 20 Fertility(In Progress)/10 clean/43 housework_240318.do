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
*               housework                    *
******************************************/
/*
lookfor 家務工作
di r(varlist)
tab1 h02a_2009 h02b_2009 c01a_2010 c01b_2010 c01a_2011 c01b_2011 d01a_2012 d01b_2012 c01a_2014 c01b_2014 c02a_2016 c02b_2016 c02a_2018 c02b_2018 c02a_2020 c02b_2020 
*/

/*************************************************************************
受訪者家務工作時間
lookfor 您平均每週大約花多少時間作
di r(varlist)
lookfor 您平均每週大約花多少時間做
di r(varlist)
tab1 h02a_2009 c01a_2010 c01a_2011 d01a_2012 c01a_2014 c02a_2016 c02a_2018 c02a_2020
*************************************************************************/

local list = "h02a_2009 c01a_2010 c01a_2011 d01a_2012 c01a_2014 c02a_2016 c02a_2018 c02a_2020 k01_2022"

local i = 2009
foreach var of local list {
	gen R_on_housework_per_week_`i' = `var'
	recode R_on_housework_per_week_`i' (168/999 = 0)
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*
sum R_on_housework_per_week_*
*/

/*************************************************************************
配偶家務工作時間
lookfor 的配偶平均每週大約花多少時間作
di r(varlist)
lookfor 的配偶平均每週大約花多少時間做
di r(varlist)
tab1 h02b_2009 c01b_2010 c01b_2011 d01b_2012 c01b_2014 c02b_2016 c02b_2018 c02b_2020
*************************************************************************/

local list = "h02b_2009 c01b_2010 c01b_2011 d01b_2012 c01b_2014 c02b_2016 c02b_2018 c02b_2020 k02_2022"

local i = 2009
foreach var of local list {
	gen SP_on_housework_per_week_`i' = `var'
	recode SP_on_housework_per_week_`i' (168/999 = 0)
	replace SP_on_housework_per_week_`i' = . if mar_status_`i' != 0
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*
sum SP_on_housework_per_week_*
*/