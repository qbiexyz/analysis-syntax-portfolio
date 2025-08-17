* Last Updated: 2024. 03 . 09
* File name: [tscs0818_modeling]
* Data:tscs08 18  
* Subject: rey reg
* qbie


cd "C:\Dropbox\工作\中研院_工作\! done\社會距離"

/***************************************************
*                     tscs08                       *
***************************************************/
do "tscs0818_modeling\10 clean data 08.do"
est clear
* 方便製表
recode f_ethnic 4 = 0

gen touse = !missing(sex, age, educ3, inc_h4, urbanization, ///
                     travel, meet, eng_a, intuse, ///
					 f_ethnic)
	
foreach x in "a" "b" "d" "e" "f" "g"  {
	foreach y of num 1/3{
		logit social_dis`y'_`x' sex age b1.educ3 b1.inc_h4 b6.urbanization ///
		        b0.travel b0.meet eng_a intuse b0.f_ethnic, vce(robust)   
        est store m`y'`x'
	}	
}

logit social_dis2_a sex age b1.educ3 b1.inc_h4 b6.urbanization ///
      b0.travel b0.meet eng_a intuse b0.f_ethnic if touse, vce(robust) 


esttab m1a m1b m1f m1g m1d m1e ///
       using "tscs0818_output\2008_m1_240309.csv" , ///
       b(2) star(* 0.05 ** 0.01 *** 0.01) pr2 aic bic  ///
	   nogaps compress  ///
	   nodepvars nonumbers not ///
	   replace  
	   
esttab m2a m2b m2f m2g m2d m2e ///
       using "tscs0818_output\2008_m2_240309.csv" , ///
       b(2) star(* 0.05 ** 0.01 *** 0.01) pr2 aic bic  ///
	   nogaps compress ///
	   nodepvars nonumbers not ///
	   replace  
	   
esttab m3a m3b m3f m3g m3d m3e ///
       using "tscs0818_output\2008_m3_240309.csv" , ///
       b(2) star(* 0.05 ** 0.01 *** 0.01) pr2 aic bic  ///
	   nogaps compress ///
	   nodepvars nonumbers not ///
	   replace 

*eform 	   
/***************************************************
*                     tscs18                       *
***************************************************/
est clear
cd "C:\Dropbox\工作\中研院_工作\! done\社會距離"
do "tscs0818_modeling\10 clean data 18.do"

* 方便製表
recode f_ethnic 4 = 0 

gen touse = !missing(sex, age, educ3, inc_h4, urbanization, ///
                     travel, meet, eng_a, intuse, ///
					 f_ethnic)
/*
tab travel meet,chi2
recode travel(0 = 0)(1 = 1)(2/4 = 3)(5/8 = 4),gen(travel3)
recode meet(0 = 0)(1 = 1)(2/4 = 3)(5/8 = 4),gen(meet3)
*/

foreach x of num 1/7  {
	foreach y in "a" "b" "c" {
		logit social_dis`y'_`x' sex age b1.educ3 b1.inc_h4 b6.urbanization ///
		        b0.travel b0.meet eng_a intuse b0.f_ethnic, vce(robust) 
        est store m`y'`x'
	}	
}

esttab ma1 ma2 ma6 ma7 ma3 ma4 ma5 ///
       using "tscs0818_output\2018_ma_240309.csv" , ///
       b(2) star(* 0.05 ** 0.01 *** 0.01) pr2 aic bic  ///
	   nogaps compress  ///
	   nodepvars nonumbers not ///
	   replace  
	   
esttab mb1 mb2 mb6 mb7 mb3 mb4 mb5 ///
       using "tscs0818_output\2018_mb_240309.csv" , ///
       b(2) star(* 0.05 ** 0.01 *** 0.01) pr2 aic bic  ///
	   nogaps compress ///
	   nodepvars nonumbers not ///
	   replace  
	   
esttab mc1 mc2 mc6 mc7 mc3 mc4 mc5 ///
       using "tscs0818_output\2018_mc_240309.csv" , ///
       b(2) star(* 0.05 ** 0.01 *** 0.01) pr2 aic bic  ///
	   nogaps compress ///
	   nodepvars nonumbers not ///
	   replace 