* Last Updated: 2024. 03. 25
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
*               cohabit                    *
******************************************/

/*************************************************************************
有無同居：有無同居：Is_pa_or_gr_cohabit
長輩數：cohabit_num
*************************************************************************/
local list = "g06b b04b b04b b04b b11b b11b b07b b07b"
local stuff = "0"
local j = 2009
foreach var of local list {
    forvalues k = 1(1)30 {
		if (`k' <= 9) local list_concat = "`var'" + "`stuff'" +"`k'" + "_`j'"
		else local list_concat = "`var'" +"`k'" + "_`j'"
		
		if (`k' == 3){
		    
		}
		else {
		    
			if (`k' >= 6 & `k' <= 21){
			    
			}
			else{
			    if (`k' == 30){
				    
				}
				else {
				    local big_list = "`big_list'" + " " + "`list_concat'"
					local temp_list = "`temp_list'" + " " + "`list_concat'" + "temp"
					
				}
			    
			}
		}
		
		
	
	}
	
	recode `big_list' (2/99 = 0),gen(`temp_list')
	tabm `temp_list'
	egen cohabit_num_`j' = rowtotal(`temp_list')
	gen Is_pa_or_gr_cohabit_`j' = 0
	replace Is_pa_or_gr_cohabit_`j' = 1 if cohabit_num_`j' >= 1
	tab Is_pa_or_gr_cohabit_`j'
	tab cohabit_num_`j'
	
	if(`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
	
	drop `temp_list'
	local big_list = " "
	local temp_list = " "
}

/*
tabm Is_pa_or_gr_cohabit*
tabm cohabit_num_*
*/

* 有無父母輩同居、有無祖父母輩同居

local list = "g06b b04b b04b b04b b11b b11b b07b b07b"
local stuff = "0"
local j = 2009
foreach var of local list {
    di "`var'"
    forvalues k = 1(1)30 {
		if (`k' <= 9) local list_concat = "`var'" + "`stuff'" +"`k'" + "_`j'"
		else local list_concat = "`var'" +"`k'" + "_`j'"
		
		if (`k' <= 5){
		    if (`k' == 3){
			    
			}
			else{
			    local pa_list = "`pa_list'" + " " + "`list_concat'"
				local temp_pa_list = "`temp_pa_list'" + " " + "`list_concat'" + "temp"
			}
		}
		else {
		    if (`k' >= 6 & `k' <= 21){
			    
			}
			else{
			    if (`k' == 30){
				    
				}
				else{
				    local gr_list = "`gr_list'" + " " + "`list_concat'"
					local temp_gr_list = "`temp_gr_list'" + " " + "`list_concat'" + "temp"
				}
			}
		}
		
	}
	di "`pa_list'"
	recode `pa_list' (90/99 = .), gen (`temp_pa_list')
	egen Is_pa_cohabit_`j' = rowtotal(`temp_pa_list')
	replace Is_pa_cohabit_`j' = 1 if Is_pa_cohabit_`j' >= 1
	
	
	recode `gr_list' (90/99 = .), gen (`temp_gr_list')
	egen Is_gr_cohabit_`j' = rowtotal(`temp_gr_list')
	replace Is_gr_cohabit_`j' = 1 if Is_gr_cohabit_`j' >= 1
	
	
	drop `temp_pa_list'
	drop `temp_gr_list'
	local pa_list = " "
	local temp_pa_list = " "
	local gr_list = " "
	local temp_gr_list = " "
	
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
}

local list = "g06b b04b b04b b04b b11b b11b b07b b07b"
local stuff = "01"
local j = 2009
foreach var of local list {
    local list_concat = "`var'" + "`stuff'"+"_`j'"
	replace Is_pa_or_gr_cohabit_`j' = . if `list_concat' >= 2 | `list_concat' == .
	replace cohabit_num_`j' = . if `list_concat' >= 2 | `list_concat' == .
	replace Is_pa_cohabit_`j' = . if `list_concat' >= 2 | `list_concat' == .
	replace Is_gr_cohabit_`j' = . if `list_concat' >= 2 | `list_concat' == . 
	
	if (`j' >= 2012) local j = `j' + 2
	else local j = `j' + 1
}

/*
tabm Is_pa_or_gr_cohabit_*
tabm cohabit_num_*
tabm Is_pa_cohabit_*
tabm Is_gr_cohabit*
*/

/*************************************************************************
2022編碼不同，獨立做

父母輩 f16z01_2022 f16z02_2022 f16z04_2022 f16z05_2022
祖父母輩 f16z22_2022 f16z23_2022 f16z24_2022 f16z25_2022 f16z26_2022 f16z27_2022 f16z28_2022 f16z29_2022

*************************************************************************/
* 有無長輩同居：
gen Is_pa_or_gr_cohabit_2022 = 0
egen temp_calculate = rowtotal(f16z01_2022 f16z02_2022 f16z04_2022 f16z05_2022 f16z22_2022 f16z23_2022 f16z24_2022 f16z25_2022 f16z26_2022 f16z27_2022 f16z28_2022 f16z29_2022)
replace Is_pa_or_gr_cohabit_2022 = 1 if temp_calculate >= 1
replace Is_pa_or_gr_cohabit_2022 = . if missing(f16z01_2022)
drop temp_calculate

/*
tabm Is_pa_or_gr_cohabit*
*/

* 長輩數：cohabit_num
egen cohabit_num_2022 = rowtotal(f16z01_2022 f16z02_2022 f16z04_2022 f16z05_2022 f16z22_2022 f16z23_2022 f16z24_2022 f16z25_2022 f16z26_2022 f16z27_2022 f16z28_2022 f16z29_2022)
replace cohabit_num_2022 = . if missing(f16z01_2022) | cohabit_num_2022 > 1000

/*
tabm cohabit_num*
*/

* 有無父母輩同居 Is_pa_cohabit
gen Is_pa_cohabit_2022 = 0
egen temp_calculate = rowtotal(f16z01_2022 f16z02_2022 f16z04_2022 f16z05_2022)
replace Is_pa_cohabit_2022 = 1 if temp_calculate >= 1
replace Is_pa_cohabit_2022 = . if missing(f16z01_2022)
drop temp_calculate

/*
tabm Is_pa_cohabit*
*/

* 有無祖父母輩同居 Is_gr_cohabit
gen Is_gr_cohabit_2022 = 0
egen temp_calculate = rowtotal(f16z22_2022 f16z23_2022 f16z24_2022 f16z25_2022 f16z26_2022 f16z27_2022 f16z28_2022 f16z29_2022)
replace Is_gr_cohabit_2022 = 1 if temp_calculate >= 1
replace Is_gr_cohabit_2022 = . if missing(f16z01_2022)
drop temp_calculate

/*
tabm Is_gr_cohabit*
*/

/*************************************************************************
手足數
f11c01_2009 請問您總共有幾個兄弟姊妹(不含受訪者本人)?

f11c01_2009 
*************************************************************************/
clonevar siblings = f11c01_2009
mvdecode siblings, mv(90/99)


