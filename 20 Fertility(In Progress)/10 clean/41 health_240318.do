* Last Updated: 2024. 03. 18
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
*               health                    *
******************************************/
/*
tabm a04a_2009 a04a_2010 a04a_2011 a04a_2012 a04a_2014 a04a_2016 a04a_2018 w01e_2020 a11_2022
*/

/*************************************************************************
自評健康：R_health , 
改成高表好
*************************************************************************/

local list = "a04a_2009 a04a_2010 a04a_2011 a04a_2012 a04a_2014 a04a_2016 a04a_2018 w01e_2020 a11_2022"

local i = 2009
foreach var of local list {
	recode `var' (1 = 5)(2 = 4)(3 = 3)(4 = 2)(5 = 1)(else = .), gen (R_health_temp_`i')
	gen R_health_`i' = R_health_temp_`i'
	drop R_health_temp_`i'
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*
tab a04a_2009 R_health_2009
tab R_health_2009
*/

/*************************************************************************
配偶健康：SP_health
lookfor )目前的健康狀況
di r(varlist)
lookfor ）目前的健康狀況
di r(varlist)

tab1 d15a_2009 a19_2010 a19_2011 a19_2012 a28_2014 a29_2016 a29_2018 w35_2020 d42_2022
*************************************************************************/

local list = "d15a_2009 a19_2010 a19_2011 a19_2012 a28_2014 a29_2016 a29_2018 w35_2020 d42_2022"
local i = 2009
foreach var of local list {
	recode `var' (1 = 5)(2 = 4)(3 = 3)(4 = 2)(5 = 1)(else = .), gen (SP_health_temp_`i')
	gen SP_health_`i' = SP_health_temp_`i'
	drop SP_health_temp_`i'
	
	if (`i' >= 2012) local i = `i' + 2
	else local i = `i' + 1
}

/*
tabm SP_health*
*/