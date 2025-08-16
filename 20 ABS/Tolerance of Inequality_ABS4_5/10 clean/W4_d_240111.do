* Last Updated: 2023. 12. 18
* File name: [ABSW4]
* Data: 亞洲民主動態調查
* Subject: 

/*****************************
*                  *
*****************************/
*設定工作路徑
cd "C:\Dropbox\工作\中研院_工作\Tolerance of Inequality_ABS4_5"

*******************************************************************************
est clear
use "10 data\W4_v15_merged20181211_release.dta",clear

/*****************************************************************************
ABSW5
*****************************************************************************/

lab def COUNTRY 2 "Hong_Kong", modify /* 將標籤 Hong Kong 修改成Hong_Kong */
decode country,gen(countryN) /* 將數字以標籤轉成轉成文字 */

numlabel COUNTRY, add 
/*
tab1 country
tab country Year
*/

ren year Year

gen wave = 4
clonevar year_i = Year

/***************************************************
*                  依變項                          *
***************************************************/

*容忍不平等 
recode q155 (1 = 4)(2 = 3)(3 = 2)(4 = 1)(* = .), gen(inc_tor)
lab var inc_tor "覺得國家收入分配公平"

*支持政府收入再分配
recode q156(1 = 4)(2 = 3)(3 = 2)(4 = 1)(* = .),gen(inc_greducen)
lab var  inc_greducen "支持政府收入再分配"

recode inc_greduce (1 = 4)(2 = 3)(3 = 2)(4 = 1),gen(noinc_greduce) 
label var noinc_greduce "不支持收入再分配"

/***************************************************
*                  自變項                          *
***************************************************/

*自變項 q1-q6 
foreach var of varlist  q1-q6{
	recode `var' (-1 7/9=.), gen(`var'_m)
	gen eco_`var' = . 
	replace eco_`var'= 6 - `var'_m
	drop  `var'_m
	lab val `var'	
}

ren eco_q* eco_*

lab var eco_1 "國家經濟條件好"
lab var eco_2 "國家經濟條件比過去更好"
lab var eco_3 "國家經濟條件未來會更好"
lab var eco_4 "家庭經濟條件好"
lab var eco_5 "家庭經濟條件比過去更好"
lab var eco_6 "家庭經濟條件未來會更好"

***對社會層面的經濟看法(+-)
egen othereco = rmean(eco_1 eco_2)
recode othereco(0/3 = 0 "-")(3.5/5 = 1 "+"),gen(othereco_all)

***對個人層面的經濟看法(+-)
egen selfeco = rmean(eco_4 eco_5)
recode selfeco(0/3 = 0 "-")(3.5/5 = 1 "+"),gen(selfeco_all)

gen inequality_all = .
replace inequality_all = 1 if othereco_all == 1 & selfeco_all == 0
replace inequality_all = 3 if othereco_all == 1 & selfeco_all == 1
replace inequality_all = 2 if othereco_all == 0 & selfeco_all == 1
replace inequality_all = 4 if othereco_all == 0 & selfeco_all == 0
lab de inequality_all 1 "自己-社會+" 2 "自己+社會-" ///
                      3 "自己+社會+" 4 "自己-社會-"
lab val  inequality_all inequality_all
lab var inequality_all "自評經濟條件狀況(4類)"

/***************************************************
*                  中介變項                        *
***************************************************/
*向上流動
recode q160(1 = 5)(2 = 4)(3 = 3)(4 = 2)(5 = 1)(* = .), gen(improve)
lab var improve "有向上流動機會"

/***************************************************
*                  控制變項                        *
***************************************************/

***gender /age /years of education/ group of household income 
*gender
recode se2(1=1 "male")(2=0 "female")(* = .),gen(male)
lab var male "male"

*age
recode se3_2 (-1 150/999= .),gen(age)
lab var age "age"

*years of education
recode se5a (-1 35/99 = .),gen(edu)
lab var edu "years of education"

*group of household income  	
mvdecode se14,mv(-1 7/9)
recode se14 (.=6 "other"),gen(fincq)
lab var fincq "group6 of household income"

recode  fincq (1 2 = 1 "low")(3 = 2 "middle")(4/5 = 3 "high") ///
              (6 = 4 "other"),gen(fincq_g4) 
lab var fincq_g4 "group4 of household income"

*sclass
recode se12 (-1 97/99 = .),gen(sclass)
lab var sclass "sclass"	

recode se12a (1/2 = 1 "low")(3 = 2 "middle")(4/5 = 3 "high") ///
             (-1 7/9 = .),gen(sclass_3)
lab var sclass_3 "sclass_3"			 

/***************************************************
*                  國家變項                        *
***************************************************/
/*
1. Japan
2. Hong Kong
3. Korea
4. China
5. Mongolia
6. Philippines
7. Taiwan
8. Thailand
9. Indonesia	
10. Singapore	
11. Vietnam	
12. Cambodia (wave5 沒有)
13. Malaysia	
14. Myanmar	

*/

/*創造國家類別*/
	
gen country_Socialist = 0
replace country_Socialist = 1 if country == 4 | country == 11 | country == 12 
lab var country_Socialist "社會主義國家"	
lab def country_Socialist 0 "其他政治形態國家" 1 "社會主義國家"
lab val country_Socialist country_Socialist	

gen country_lincome = 1
replace country_lincome = 0 if country <= 3 | country == 7 | country == 10
lab var country_lincome "人均收入較低國家"	
lab def country_lincome 0 "人均收入較高國家" 1 "人均收入較低國家"
lab val country_lincome country_lincome	

*GDPg
gen gdpg = .
replace gdpg = 0.870219652 if country == 1
replace gdpg = 2.439891099 if country == 2
replace gdpg = 3.058755233 if country == 3
replace gdpg = 7.411080878 if country == 4
replace gdpg = 10.61798717 if country == 5
replace gdpg = 6.665156832 if country == 6
replace gdpg = 3.14 	   if country == 7
replace gdpg = 3.638253543 if country == 8
replace gdpg = 4.97201997  if country == 9
replace gdpg = 4.05635775  if country == 10
replace gdpg = 6.028275472 if country == 11
replace gdpg = 7.204976935 if country == 12
replace gdpg = 5.391299555 if country == 13
replace gdpg = 7.803252304 if country == 14
lab var gdpg "經濟成長指數"

*GINI
gen gini = .
replace gini = 32.9  if country == 1
replace gini = 42  if country == 2
replace gini = 31.3  if country == 3
replace gini = 38.6  if country == 4
replace gini = 32    if country == 5
replace gini = 44.6  if country == 6
replace gini = 33.6  if country == 7
replace gini = 37    if country == 8
replace gini = 38.6  if country == 9
replace gini = 41    if country == 10  
replace gini = 35.05 if country == 11
replace gini = 29.5  if country == 12
replace gini = 41.2  if country == 13
replace gini = 38.1  if country == 14
lab var gini "基尼係數" 

*GNI
gen gni = .
replace gni = 36810.3484  if country == 1
replace gni = 43217.01657 if country == 2
replace gni = 28822.10397 if country == 3
replace gni = 7978.179507 if country == 4
replace gni = 3535.134222 if country == 5
replace gni = 3198.531532 if country == 6
replace gni = 23492       if country == 7
replace gni = 5538.787307 if country == 8
replace gni = 3346.541617 if country == 9
replace gni = 51849.69106 if country == 10
replace gni = 1954.093198 if country == 11
replace gni = 1091.700691 if country == 12
replace gni = 9280.000353 if country == 13
replace gni = 1149.317213 if country == 14
lab var gni "國民所得"

gen lgni = log(gni)
lab var lgni "國民所得(log)"

/*創造互動項*/
sum gdpg ,meanonly
gen gdpgc = gdpg - r(mean)	
label var gdpgc "gdpg中心化"

sum gini ,meanonly
gen ginic = gini - r(mean)	
label var ginic "gini中心化"

sum lgni ,meanonly
gen lgnic = lgni - r(mean)	
label var lgnic "lgni中心化"

sum improve ,meanonly
gen improvec = improve - r(mean)	
label var improvec "代間流動中心化"

/*創造權數*/
gen wei_a=.
replace wei_a=1/(1081/20667) if country== 1
replace wei_a=1/(1217/20667) if country== 2
replace wei_a=1/(1200/20667) if country== 3
replace wei_a=1/(4068/20667) if country== 4
replace wei_a=1/(1228/20667) if country== 5
replace wei_a=1/(1200/20667) if country== 6
replace wei_a=1/(1657/20667) if country== 7
replace wei_a=1/(1200/20667) if country== 8
replace wei_a=1/(1550/20667) if country== 9
replace wei_a=1/(1039/20667) if country== 10
replace wei_a=1/(1200/20667) if country== 11
replace wei_a=1/(1200/20667) if country== 12
replace wei_a=1/(1207/20667) if country== 13
replace wei_a=1/(1620/20667) if country== 14
label var wei_a "權數(all)"

gen country_gni = .
replace country_gni = 1 if countryN == "Australia"
replace country_gni = 2 if countryN == "Singapore"
replace country_gni = 3 if countryN == "Hong_Kong"
replace country_gni = 4 if countryN == "Japan"
replace country_gni = 5 if countryN == "Korea"
replace country_gni = 6 if countryN == "Taiwan"
replace country_gni = 7 if countryN == "Malaysia"
replace country_gni = 8 if countryN == "China"
replace country_gni = 9 if countryN == "Thailand"
replace country_gni = 10 if countryN == "Mongolia"
replace country_gni = 11 if countryN == "Indonesia"
replace country_gni = 12 if countryN == "Philippines"
replace country_gni = 13 if countryN == "Vietnam"
replace country_gni = 14 if countryN == "India"
replace country_gni = 15 if countryN == "Myanmar"
replace country_gni = 16 if countryN == "Cambodia"

lab def country_gni ///
1 "Australia" ///
2 "Singapore" ///
3 "Hong_Kong" ///
4 "Japan" ///
5 "Korea" ///
6 "Taiwan" ///
7 "Malaysia" ///
8 "China" ///
9 "Thailand" ///
10 "Mongolia" ///
11 "Indonesia" ///
12 "Philippines" ///
13 "Vietnam" ///
14 "India" ///
15 "Myanmar" ///
16 "Cambodia"
lab val country_gni country_gni

keep ///
     country countryN country_gni Year year_i wave ///
	 gdpg gdpgc gini ginic gni lgni lgnic ///
     improvec country_Socialist country_lincome inc_tor inc_greduce ///
	 noinc_greduce eco_1 - inequality_all improve male age edu ///
	 fincq fincq_g4 sclass sclass_3 wei_a 

order ///
     country countryN country_gni Year year_i wave ///
	 gdpg gdpgc gini ginic gni lgni lgnic ///
     improvec country_Socialist country_lincome inc_tor inc_greduce ///
	 noinc_greduce eco_1 - inequality_all improve male age edu ///
	 fincq fincq_g4 sclass sclass_3 wei_a 
compress

save "10 data\ABSW4_inq_231227.dta", replace






