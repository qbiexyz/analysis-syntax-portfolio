* Last Updated: 2021. 09. 10
* File name: [new_analysis]LCA
* Data: TYP
* Subject: LCA

/*****************************
*          TYP 2014          *
*****************************/
cd "D:\desktop\Desktop\中研院_工作\TYP_work\new_analysis"
*****2014
use maindata14,clear
keep if touse

gen covertime14 = .   
replace covertime14 = overtime14-40   

**LCA(原先)
forvalues i=1/5 {
gsem (covertime14 <-, regress) ///
     (nosubsidy14 <- ,logit) ///
	 (loghourate14 replaced14 worry14 <-, regress), ///
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
log using LCA14_1.txt, text replace
estimates stats profile*

***分三組
quietly gsem (covertime14 <-, regress) ///
			 (nosubsidy14 <- ,logit) ///
			 (loghourate14 replaced14 worry14 <-, regress), ///
			 lclass(C 3) nonrtolerance
estat lcprob
estat lcmean
log close


/*
**LCA(0、1)
forvalues i=1/5 {
gsem (iovertime14 nosubsidy14 ihourate14 ireplaced14 iworry14 <-),logit lclass(C `i') nonrtolerance
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
log using LCA14.txt, text replace
estimates stats profile*
log close

log using LCA14.txt, text append
***分三組
quietly gsem (iovertime14 nosubsidy14 ihourate14 ireplaced14 iworry14 <- ),logit lclass(C 3) nonrtolerance
estat lcprob
estat lcmean
log close
*/

******

gsem (iovertime14 nosubsidy14 ihourate14 ireplaced14 iworry14 <- ),logit lclass(C 3) nonrtolerance

eststo profile3

predict profile3*, classposteriorpr
egen max=rowmax(profile3*)
gen group3=.
forvalues j=1/3 {
replace group3=`j' if profile3`j'==max
}
drop profile* max

/*
*畫圖
rename (iovertime14 nosubsidy14 ihourate14 ireplaced14 iworry14 inightshift14 iholidayshift14) var#, addnumber


collapse var1 var2 var3 var4 var5 var6 var7, by(group2)
reshape long var, i(group2) j(number)

twoway (line var number if group2==1, lpattern(solid)) ///
       (line var number if group2==2, lpattern(dash)), ///
        ytitle("平均分數") xtitle("") xlabel(1(1)7, valuelabel) ///
        legend(order(1 "group1" 2 "group2") rows(1))
graph export "Item Probability_2014.tif", width(1440) height(900) replace
*/
 


/*****************************
*          TYP 2017          *
*****************************/
cd "D:\desktop\Desktop\中研院_工作\TYP_work\new_analysis"

*****2017
use maindata17,clear
keep if touse

/*
recode nightshift17 (1/2=0)(3/4=1),gen(inightshift17) 
recode holidayshift17(1/2=0)(3/4=1),gen(iholidayshift17)
*/

gen covertime17 = .   
replace covertime17 = overtime17-40   


**LCA(原先)
forvalues i=1/5 {
gsem (covertime17 <-, regress) ///
     (nosubsidy17 <- ,logit) ///
	 (loghourate17 replaced17 worry17 <-, regress), ///
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
log using LCA17_1.txt, text replace
estimates stats profile*

***分三組
quietly gsem (covertime17 <-, regress) ///
			 (nosubsidy17 <- ,logit) ///
			 (loghourate17 replaced17 worry17 <-, regress), ///
			 lclass(C 3) nonrtolerance
estat lcprob
estat lcmean
log close



/*
**LCA(0、1)
forvalues i=1/5 {
gsem (iovertime17 nosubsidy17 ihourate17 ireplaced17 iworry17 <-),logit lclass(C `i') nonrtolerance
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
log using LCA17.txt, text replace
estimates stats profile*
log close

log using LCA17.txt, text append
***分三組
quietly gsem (iovertime17 nosubsidy17 ihourate17 ireplaced17 iworry17 <- ),logit lclass(C 3) nonrtolerance
estat lcprob
estat lcmean
log close
*/








***************************解釋****************************************
forvalues i=1/5 {
, logit lclass(C `i') /*按變項的特徵分為i群人*/
eststo profile`i' /*看大致的情況*/

predict profile`i'*, classposteriorpr
egen max=rowmax(profile`i'*) /*創造變項為各類最大值*/
gen group`i'=.  /*根據最大值分類*/
forvalues j=1/`i' {
replace group`i'=`j' if profile`i'`j'==max
}
drop profile* max /*把不需要的刪掉*/
}


*畫圖
rename (earningability_2017_1  overtime_2017_2 noworkovertimepay_2017 nrepl_2017 nworry_2017) var#, addnumber

preserve   /*保存現在資料*/
zscore var*
collapse z_var3-z_var5, by(group3) /*collapse 把資料用group3統整 */
reshape long z_var, i(group3) j(number) /*變長資料 (才能把五個變項分類成一個)*/

twoway (line z_var number if group3==1, lpattern(solid)) /// /* lpattern=每條現不同的樣式*/
       (line z_var number if group3==2, lpattern(dash)) ///
       (line z_var number if group3==3, lpattern(vshortdash)), ///
        ytitle("標準化分數") xtitle("") xlabel(1(1)5, valuelabel) ///
        legend(order(1 "group1" 2 "group2" 3 "group3") rows(1))
graph export "Item Probability_2017.tif", width(1440) height(900) replace
restore  /*回復到剛剛保存時資料*/