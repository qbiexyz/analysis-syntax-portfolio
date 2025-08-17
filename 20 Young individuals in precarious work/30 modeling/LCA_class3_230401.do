* Last Updated: 2023. 04. 10
* File name: [new_analysis]LCA_con_class3
* Data: TYP
* Subject: LCA

/*****************************
*          TYP 2014          *
*****************************/
cd "D:\Dropbox\工作\中研院_工作\! done\TYP_work\new"

*****2014
use data/14/typ2014_work_230401.dta,clear
est clear 

gen touse_14=!mi(Secondjob14, nosubsidy14, Tempjob14,overtime14,  ///
                 inc14, replaced14, worry14)
keep if touse_14

**LCA(原先)
forvalues i=1/4 {
quietly gsem (nosubsidy14 Secondjob14 worry14 <- ,logit) ///
	 (inc14  overtime14 Tempjob14 replaced14 <-, regress), ///
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

drop _est_profile1 - _est_profile3 _est_profile4 
sort id2

ren group3 group3_14
ren group4 group4_14

save data/14/group_14_230401.dta


* Comparing models
log using output/LCA14_230107.txt, text replace
estimates stats profile*

***分三類
quietly gsem (nosubsidy14 Secondjob14 worry14 <- ,logit) ///
	 (inc14 overtime14  Tempjob14 replaced14 <-, regress), ///
	 lclass(C 3) nonrtolerance
estat lcprob
estat lcmean

***分四類
quietly gsem (nosubsidy14 Secondjob14 worry14 <- ,logit) ///
	 (inc14 overtime14  Tempjob14 replaced14 <-, regress), ///
	 lclass(C 4) nonrtolerance
estat lcprob
estat lcmean


***ABIC
forvalues i=1/4 {
quietly gsem (nosubsidy14 Secondjob14 worry14 <- ,logit) ///
	 (inc14  overtime14 Tempjob14 replaced14 <-, regress), ///
	 lclass(C `i') nonrtolerance
eststo profile`i'

scalar SSBIC_class_`i' = -2 * e(ll) + e(rank) * ln((e(N)+2) / 24)
di SSBIC_class_`i'
}

***Entropy
forvalues i=1/4 {
quietly gsem (nosubsidy14 Secondjob14 worry14 <- ,logit) ///
	 (inc14  overtime14 Tempjob14 replaced14 <-, regress), ///
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



log close


/*****************************
*          TYP 2017          *
*****************************/
cd "D:\Dropbox\工作\中研院_工作\! done\TYP_work\new"

*****2017
use data/17/typ2017_work_230401.dta,clear
est clear 

gen touse_17=!mi(Secondjob17, nosubsidy17, Tempjob17, overtime17, ///
                 inc17, replaced17, worry17)
keep if touse_17

**LCA(原先)
forvalues i=1/4 {
quietly gsem (nosubsidy17 Secondjob17 worry17 <- ,logit) ///
	 (inc17  overtime17 Tempjob17 replaced17 <-, regress), ///
	 lclass(C `i') nonrtolerance
eststo profile`i'

***ABIC
scalar SSBIC_class_`i' = -2 * e(ll) + e(rank) * ln((e(N)+2) / 24)
di SSBIC_class_`i'


predict profile`i'*, classposteriorpr
egen max=rowmax(profile`i'*)
gen group`i'=.
forvalues j=1/`i' {
replace group`i'=`j' if profile`i'`j'==max
}
drop profile* max
}

drop _est_profile1 - _est_profile3 _est_profile4 
sort id2

ren group3 group3_17
ren group4 group4_17

save data/17/group_17_230401.dta


* Comparing models
log using output/LCA17_1022.txt, text replace
estimates stats profile*

***分三類
quietly gsem (nosubsidy17 Secondjob17 worry17<- ,logit) ///
	 (inc17 overtime17  Tempjob17 replaced17 <-, regress), ///
	 lclass(C 3) nonrtolerance
estat lcprob
estat lcmean

***分四類
quietly gsem (nosubsidy17 Secondjob17 worry17<- ,logit) ///
	 (inc17 overtime17  Tempjob17 replaced17 <-, regress), ///
	 lclass(C 4) nonrtolerance
estat lcprob
estat lcmean

log close


***ABIC
forvalues i=1/4 {
quietly gsem (nosubsidy17 Secondjob17 worry17 <- ,logit) ///
	 (inc17  overtime17 Tempjob17 replaced17 <-, regress), ///
	 lclass(C `i') nonrtolerance
eststo profile`i'

scalar SSBIC_class_`i' = -2 * e(ll) + e(rank) * ln((e(N)+2) / 24)
di SSBIC_class_`i'
}

***Entropy
forvalues i=1/4 {
quietly gsem (nosubsidy17 Secondjob17 worry17 <- ,logit) ///
	 (inc17 overtime17 Tempjob17 replaced17 <-, regress), ///
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
