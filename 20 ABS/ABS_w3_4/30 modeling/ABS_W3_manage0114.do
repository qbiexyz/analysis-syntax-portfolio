* Last Updated: 2022 . 01 14
* File name: [ABSW3_4_modeling]
* Data: ABS3
* Subject: Data Manage_new

/***************************************************
*                        ABS3                    *
***************************************************/


cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\"
*/
use ABSW3_4_data/ABS3.dta,clear
keep if country == 4 | country == 8 | country == 11 | country == 12

***依變項
/*
recode q153(-1 5/9=.)(1=4)(2=3)(3=2)(4=1),gen(forgood_hurt)
lab var forgood_hurt "Foreign goods are hurting the local community"
lab def forgood_hurt 1 "sd" 2 "d" 3 "a" 4 "sa"
lab val forgood_hurt forgood_hurt
*/

recode q152(-1 5/9=.)(1=4)(2=3)(3=2)(4=1),gen(protectworkern)
lab var protectworkern "Protecting Farmers and Workers"
lab def protectworkern 1 "sd" 2 "d" 3 "a" 4 "sa"
lab val protectworkern protectworkern

***自變項 

*economic condition
foreach var of varlist  q1-q6{
	recode `var' (-1 7/9=.),gen(`var'_m)
	gen economic`var'=.
	replace economic`var'=5+1-`var'_m
	replace economic`var'=3 if economic`var'==.
	drop  `var'_m
	lab val `var'	
}
ren economicq* economic*
lab var economic3 "Expected eco. condition of family"
lab var economic6 "Expected eco. condition of country"
ren  economic3 ecocountry
ren  economic6 ecofamily

*Collectivism
foreach var of varlist  q51-q52{
	recode `var' (-1 7/9=.),gen(`var'_m)
	gen collectivism`var'=.
	replace collectivism`var'=4+1-`var'_m
	drop  `var'_m
	lab val `var'	
}

gen collectivism=.
replace collectivism=(collectivismq51+collectivismq52)/2
lab var collectivism "Collectivism"
ren collectivismq51 collectivismq1
ren collectivismq52 collectivismq2


*Political Trust 
recode q9 (-1 7/9=.)(1=4 "sa")(2=3 "a")(3=2 "d")(4=1 "sd"),gen(trustg)
recode q136 (-1 7/9=.)(1=4 "sa")(2=3 "a")(3=2 "d")(4=1 "sd"),gen(truste)
lab var trustg "Trust in government"
lab var truste "Trust in elite"


recode q137 (-1 7/9=.)(1=4 "sa")(2=3 "a")(3=2 "d")(4=1 "sd"),gen(loyal)



*Global exposure
recode q149(-1 7/9=3)(5=1 "Not at all")(4=2 "Very little")(3=3 "Not too closely") ///
					 (2=4 "Somewhat closely")(1=5 "Very closely"),gen(globalexposure)
lab var globalexposure "Global exposure"



***控制變項

*性別
recode se2(-1=.)(1=1 "male")(2=0 "female"),gen(male)
lab var male "Male(=1)"

*年齡
mvdecode se3a,mv(-1)
ren se3a age
lab var age "Age"
keep if age>=18 & age<=65	

*教育年數

recode se5a (-1 90 98 99 =.), gen(eduyear)
drop if eduyear >= 25 & eduyear <= 51    
lab var eduyear "Educational Year"
forvalues i = 1/13 {
 sum eduyear if country ==`i' & (age >=18 & age <= 65), detail
 replace eduyear = r(p50) if eduyear ==. & country ==`i' & (age >=18 & age <= 65)
}



*是否就業
recode se9c(10000=1000),gen(qwe) /*查看se9c_2編號*/
mvdecode se9c,mv(-1 0 12 9999)
mvdecode se9 se9a se9e,mv(-1 0 7/9)
drop if se9 == . & se9a == . & se9c == .

gen employment = .
replace employment = 0 if se9c == 1 | se9c == 2
replace employment = 1 if se9c == 3
replace employment = 2 if se9c == 7 | se9c == 8 | se9c == 9 
replace employment = 3 if se9c == 10 | se9c == 11
replace employment = 4 if  se9 == 1 & se9c == . & se9e == .
replace employment = 5 if  se9 == . & se9c == .
replace employment = 5 if  se9 == 2
replace employment = 5 if  se9 == 1 & se9e!=.
lab var employment "Employment(Higher white collar=0)"
lab  def  employment 0 "Higher white collar" 1 "Lower white collar" ///
					 2 "Worker" 3 "Peasants" 4 "Others(Employed)" 5 "Others(Unemployed)"
lab  val  employment employment

*china only se9 se9e

gen employment_C = .
replace employment_C = 0 if se9 == 1 
replace employment_C = 1 if se9 == 2 & se9e == 5
replace employment_C = 2 if se9a==4
replace employment_C = 3 if  employment_C == .
lab var employment_C "Employment China(Employed=0)"
lab  def  employment_C 0 "Employed" 1 "Unemployed" 2 "Peasants"  3 "Others"
lab  val  employment_C employment_C



 
 
 
*Urban residence 
recode level3(-1=.)(2=0 "Rural")(1=1 "Urban"),gen(urban)
lab var urban "Urban"

*家庭收入(等級) fincq.6
mvdecode se13,mv(-1 7/9)
recode se13 (.=3 "Missing")(1/2=0 "Low")(3=1 "Middle")(4/5=2 "High"),gen(finc4n)
lab var finc4n "Family income(low=0)"


gen wave4=0



keep country wave4 idnumber protectworker forgood_hurt ///
	 finc4n age male edu globalexposure employment employment_C urban ///
	 ecofamily ecocountry collectivismq1 collectivismq2 collectivism trustg truste loyal

order country wave4 idnumber protectworker forgood_hurt ///
	 finc4n age male edu globalexposure employment employment_C urban ///
	 ecofamily ecocountry collectivismq1 collectivismq2 collectivism trustg truste loyal
/*	 
keep if age>=18 & age<=65	 
keep if country == 4 | country == 8 | country == 11 | country == 12
sort idnumber
*/
compress
/*
save ABSW3_4_data/ABS_W3_220114_DependentV2.dta
*/

save ABSW3_4_data/ABS_W3_220114.dta


/*
log using "ABSW3_4_output/220107_ Thailandwork.txt" , text replace 

by country : list se9 - se9e if se9==1 & se9e!=. & se9e!=0

log close

*/
/*
log using "AABSW3_4_output/2201013_ work3.txt" , text replace 

tab1 se9 se9a se9c se9e
by country :tab1 se9 se9a se9c se9e
log close
*/


globalexposure ecocountry ecofamily edu
