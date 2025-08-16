* Last Updated: 2023. 07. 10
* File name: [ABSW5]
* Data: 亞洲民主動態調查
* Subject: 

/*****************************
*                  *
*****************************/
*設定工作路徑
cd "C:\Dropbox\工作\中研院_工作\Tolerance of Inequality_ABS4_5"

*******************************************************************************
est clear
use "10 data\Release_v1_20230417_W5_merge_15.dta",clear

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

gen wave = 5
clonevar year_i = Year

/*刪除澳洲*/
* drop if country == 15

/***************************************************
*                  依變項                          *
***************************************************/

*容忍不平等 
recode q159 (1 = 4)(2 = 3)(3 = 2)(4 = 1)(* = .), gen(inc_tor)
lab var inc_tor "覺得國家收入分配公平"

*支持政府收入再分配
recode q160a (1 = 4)(2 = 3)(3 = 2)(4 = 1)(* = .),gen(inc_greduce)
lab var  inc_greduce "支持政府收入再分配"

recode inc_greduce (1 = 4)(2 = 3)(3 = 2)(4 = 1),gen(noinc_greduce) 
label var noinc_greduce "不支持政府收入再分配"

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
recode q164(1 = 5)(2 = 4)(3 = 3)(4 = 2)(5 = 1)(* = .), gen(improve)
lab var improve "有向上流動機會"

/***************************************************
*                  控制變項                        *
***************************************************/
***gender /age /years of education/ group of household income 
*gender
recode SE2(1=1 "male")(2=0 "female")(* = .),gen(male)
lab var male "male"

*age
recode SE3_1 (-1 150/999= .),gen(age)
lab var age "age"

*years of education
recode SE5A (-1 35/99 = .),gen(edu)

lab var edu "years of education"

*group of household income  	
mvdecode SE14,mv(-1 7/9)
recode SE14 (.=6 "other"),gen(fincq)
lab var fincq "group6 of household income"

recode  fincq (1 2 = 1 "low")(3 = 2 "middle")(4/5 = 3 "high") ///
               (6 = 4 "other"),gen(fincq_g4) 
lab var fincq_g4 "group4 of household income"

*sclass
recode SE12 (-1 97/99 = .),gen(sclass)
lab var sclass "sclass"	

recode SE12 (1/4 = 1 "low")(5/6 = 2 "middle")(7/10 = 3 "high") ///
             (-1 97/99 = .),gen(sclass_3)
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
13. Malaysia	
14. Myanmar	
15. Australia	
18. India	
*/

/*創造國家類別*/
	
gen country_Socialist = 0
replace country_Socialist = 1 if country == 4 | country == 11 
lab var country_Socialist "社會主義國家"	
lab def country_Socialist 0 "非社會主義國家" 1 "社會主義國家"
lab val country_Socialist country_Socialist	

gen country_lincome = 1
replace country_lincome = 0 if country <= 3 | country == 7 | country == 10
lab var country_lincome "人均收入較低國家"	
lab def country_lincome 0 "人均收入較高國家" 1 "人均收入較低國家"
lab val country_lincome country_lincome	

*GDPg
gen gdpg = .
replace gdpg = 0.638851191  if country == 1
replace gdpg = -0.591835646 if country == 2
replace gdpg = 2.770339125  if country == 3
replace gdpg = 6.54915846   if country == 4
replace gdpg = 4.957180498  if country == 5
replace gdpg = 6.807310216  if country == 6
replace gdpg = 2.756666667  if country == 7
replace gdpg = 3.505036372  if country == 8
replace gdpg = 5.087788374  if country == 9
replace gdpg = 0.335213545  if country == 10
replace gdpg = 7.031729418  if country == 11
replace gdpg = 5.022998936  if country == 13
replace gdpg = 6.301833991  if country == 14
replace gdpg = 2.631925586  if country == 15
replace gdpg = 5.706890568  if country == 18
lab var gdpg "經濟成長指數"

*GINI (用2014)
gen gini = .
replace gini = 28.6  if country == 1
replace gini = 39.7  if country == 2
replace gini = 33.1  if country == 3
replace gini = 38.2  if country == 4
replace gini = 32.7  if country == 5
replace gini = 42.3  if country == 6
replace gini = 33.8  if country == 7
replace gini = 35.65 if country == 8
replace gini = 37.6  if country == 9
replace gini = 38.6  if country == 10  
replace gini = 35.7  if country == 11
replace gini = 41.2  if country == 13
replace gini = 30.7  if country == 14
replace gini = 34.3  if country == 15
replace gini = 35    if country == 18
lab var gini "基尼係數" 

*GNI
gen gni = .
replace gni = 37329.79527 if country == 1
replace gni = 46351.40261 if country == 2
replace gni = 31228.29347 if country == 3
replace gni = 10127.44246 if country == 4
replace gni = 3844.902841 if country == 5
replace gni = 3801.581391 if country == 6
replace gni = 26421       if country == 7
replace gni = 6765        if country == 8
replace gni = 3773.35723  if country == 9
replace gni = 55010       if country == 10
replace gni = 2925.731152 if country == 11
replace gni = 10943.94843 if country == 13
replace gni = 1531.239935 if country == 14
replace gni = 57283.33871 if country == 15
replace gni = 1925.87073  if country == 18
lab var gni "人均國民所得"

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
gen wei_a = .
replace wei_a = 1/(1045/20003) if country== 1
replace wei_a = 1/(1200/20003) if country== 2
replace wei_a = 1/(1268/20003) if country== 3
replace wei_a = 1/(4941/20003) if country== 4
replace wei_a = 1/(1284/20003) if country== 5
replace wei_a = 1/(1200/20003) if country== 6
replace wei_a = 1/(1259/20003) if country== 7
replace wei_a = 1/(1200/20003) if country== 8
replace wei_a = 1/(1540/20003) if country== 9
replace wei_a = 1/(1002/20003) if country== 10
replace wei_a = 1/(1200/20003) if country== 11
replace wei_a = 1/(1237/20003) if country== 13
replace wei_a = 1/(1627/20003) if country== 14
label var wei_a "權數(all)"


gen wei_a2 = .
replace wei_a2 = 1/(1045/26951) if country== 1
replace wei_a2 = 1/(1200/26951) if country== 2
replace wei_a2 = 1/(1268/26951) if country== 3
replace wei_a2 = 1/(4941/26951) if country== 4
replace wei_a2 = 1/(1284/26951) if country== 5
replace wei_a2 = 1/(1200/26951) if country== 6
replace wei_a2 = 1/(1259/26951) if country== 7
replace wei_a2 = 1/(1200/26951) if country== 8
replace wei_a2 = 1/(1540/26951) if country== 9
replace wei_a2 = 1/(1002/26951) if country== 10
replace wei_a2 = 1/(1200/26951) if country== 11
replace wei_a2 = 1/(1237/26951) if country== 13
replace wei_a2 = 1/(1627/26951) if country== 14
replace wei_a2 = 1/(1630/26951) if country== 15
replace wei_a2 = 1/(5318/26951) if country== 18
label var wei_a2 "權數2(all)"

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

*******************
/*
*排除退休
drop if SE9E == 3

*排除年齡
keep if  age >= 18 & age <= 64
*/
*******************

keep ///
     country countryN country_gni Year year_i wave ///
	 gdpg gdpgc gini ginic gni lgni lgnic ///
     improvec country_Socialist country_lincome inc_tor inc_greduce ///
	 noinc_greduce eco_1 - inequality_all improve male age edu ///
	 fincq fincq_g4 sclass sclass_3 wei_a wei_a2

order ///
     country countryN country_gni Year year_i wave ///
	 gdpg gdpgc gini ginic gni lgni lgnic ///
     improvec country_Socialist country_lincome inc_tor inc_greduce ///
	 noinc_greduce eco_1 - inequality_all improve male age edu ///
	 fincq fincq_g4 sclass sclass_3 wei_a wei_a2
compress

save "10 data\ABSW5_inq_231227.dta", replace



