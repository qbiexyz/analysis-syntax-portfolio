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
*               age                    *
******************************************/

/*************************************************************************
age：2009年時的歲數

tab1 a02z01_2009 
*************************************************************************/

gen age_2009 = 2009 - (1911 + a02z01_2009)

/*
tab age_2009
*/

local i = 2009
local j = 2010
local m = 1
forvalues k = 1(1)8{
    gen age_`j' = age_`i' + `m'
	
	local i = `j'
	if (`j' >= 2012) {
		local j = `j' + 2
		local m = 2
	}
	else local j = `j' + 1
}

/*
tabm age*
*/

gen age_n2016 = 2016 - (1911 + a02a01_n2016) if x01b_n2016 == 5
replace age_2018 = age_n2016 + 2 if x01b_n2016 == 5
replace age_2020 = age_2018 + 2 if x01b_n2016 == 5
replace age_2022 = age_2020 + 2 if x01b_n2016 == 5

gen age30 = .
replace age30 = 0 if age_2009 < 30
replace age30 = 1 if age_2009 >= 30