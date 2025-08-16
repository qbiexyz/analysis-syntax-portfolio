* Last Updated: 2024. 03. 29
* File name: []
* Data: 學生AB總檔_0131LABEL
* Subject: 


/*****************************
*                            *
*****************************/
cd "C:\Dropbox\工作\杏容老師_work\TIGPS2023"

***************************************************************************
est clear

use "10 data\學生AB總檔_0325LABEL.dta", clear

/***************************************************************************
                                
***************************************************************************/

do "20 model\10 clean\學生AB總檔\學生AB總檔_01 霸凌變項_240329.do"
do "20 model\10 clean\學生AB總檔\學生AB總檔_02 其他變項_240329.do"
do "20 model\10 clean\學生AB總檔\學生AB總檔_03 保留變項_240329.do"


/*
gen touse_14=!mi(Secondjob14, Tempjob14,overtime14,  ///
                 inc14, replaced14, worry14)
keep if touse_14
*/


****************************************************************************
* 1/0
foreach x of num 1/8 {
	clonevar br_fv_0`x'b = br_fv_`x'
	replace br_fv_0`x'b = 0 if br_v == 0
	recode br_fv_0`x'b (0 = 0)(1/3 = 1)
}

foreach x of num 1/7 {
	clonevar bc_fv_0`x'b = bc_fv_`x'	
	replace bc_fv_0`x'b = 0 if bc_v == 0	
	recode bc_fv_0`x'b (0 = 0)(1/3 = 1)
}

* LCA
forvalues i=2/6 {
quietly gsem ///
	        (br_fv_01b - br_fv_08b  bc_fv_01b - bc_fv_07b <-, logit), ///
	 lclass(C `i') nonrtolerance
eststo profile`i'

predict profile`i'*, classposteriorpr
egen max=rowmax(profile`i'*)
gen group`i'=.
forvalues j=1/`i' {
replace group`i'=`j' if profile`i'`j'==max
}
drop profile* max
}

* Comparing models
estimates stats profile*

save "10 data\lca5_n_240329.dta", replace

****************************************************************************
use "10 data\lca5_n_240329.dta", clear


***分5類
quietly gsem ///
	        (br_fv_01b - br_fv_08b  bc_fv_01b - bc_fv_07b <-, logit), ///
	 lclass(C 5) nonrtolerance
estat lcprob, nose 
estat lcmean, nose 


****************************************************************************
***ABIC
forvalues i=2/6 {
quietly gsem ///
	        (br_fv_01b - br_fv_08b  bc_fv_01b - bc_fv_07b <-, logit), ///
	 lclass(C `i') nonrtolerance
eststo profile`i'

scalar SSBIC_class_`i' = -2 * e(ll) + e(rank) * ln((e(N)+2) / 24)
di SSBIC_class_`i'
}

***Entropy
forvalues i=2/6 {
quietly gsem ///
	        (br_fv_01b - br_fv_08b  bc_fv_01b - bc_fv_07b <-, logit), ///
	 lclass(C `i') nonrtolerance
eststo profile`i'


predict profile`i'*, classposteriorpr
local ent = 0

forvalues j = 1/`i' {
	gen temp`j'=(log(profile`i'`j')*(profile`i'`j'*-1))
	sum temp`j', meanonly
	local ent =`ent' + r(sum)
	drop temp`j'
	}
scalar ent=1-(`ent'/(e(N)*ln(e(k))))
scalar list ent

drop profile* 
}


