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

*/

/*****************************************
*               小孩變化               *
******************************************/

/*
tab1 i01_2009 b12_2010 b12_2011 b12_2012 /// 
b13_2014 b15_2016 b11_2018 b11_2020
*/

/*************************************************************************
處理
若這波小孩數相較上波多兩2,多一1 沒多0
*************************************************************************/

local i = 2009
local j = 2010
local child_diff = 0
forvalue k = 1(1)8 {
	gen child_add_`j' = 0
	replace child_add_`j' = 1 if (child_num_`i' < child_num_`j') ///
								  & child_num_`i' != . & child_num_`j' != .
	replace child_add_`j' = 2 if (child_num_`j' - child_num_`i' >= 2) ///
	                              & child_num_`i' != . & child_num_`j' != .
	local i = `j'
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
}

/*
tab child_add_2010
tab b12_2010 if b12_2010 > i01_2009 & b12_2010 != .

tab child_add_2020
tab b11_2018 b11_2020 if child_add_2020 != 0

tabm child_add_*
*/
