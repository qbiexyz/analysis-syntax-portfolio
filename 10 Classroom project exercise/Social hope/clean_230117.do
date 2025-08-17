* Last Updated: 2023. 01 .17
* File name: WVS_W7_modeling
* Data:  
* Subject: clean

/***************************************************
                  clean data
***************************************************/
*設定工作路徑
cd "D:\Dropbox\學習\碩士\WVS_W7"

***************************************************
use "WVS_W7_data\WVS_Cross-National_Wave_7_Stata_v5_0.dta",clear

/*************************
      合併國家指標& 
**************************/	 
/*v2xeg_eqdr*/
mvdecode hdi  v2xeg_eqdr  ,mv(-9999)

sort B_COUNTRY
merge m:1 B_COUNTRY using  "WVS_W7_data\country\country index.dta"
drop _merge

***hdi

replace hdi = (0.916 + 0.911)/2 if B_COUNTRY == 158 /*taiwan*/
replace hdi =  0.922  if B_COUNTRY == 446 /*Macau SAR */

/***************************************************
                     依變項
***************************************************/

/*************************
         社會希望
**************************/	 

***Income equality
gen inc_eq = .
replace inc_eq = 11 - Q106 if Q106 >= 1
replace inc_eq = . if Q106 < 0
lab var inc_eq "want income equality"

***Government  responsibility
gen gov_care = .
replace gov_care = 11 - Q108 if Q108 >= 1
replace gov_care = . if Q108 < 0
lab var gov_care "Government responsibility to care our life"

egen nohope_sco1 = rmean(inc_eq gov_care)
recode nohope_sco1 (1/5 = 1)(5.5/10 = 0),gen(nohope_sco)

/***
recode Q241 Q244 Q247(-9/-1 = .)
*/
/*************************
         個人希望
**************************/	 

*** Success: hard work vs luck
gen workhard = .
replace workhard = 11 - Q110 if Q110 >= 1
replace workhard = . if Q110 < 0
lab var workhard "努力工作生活會更好"
recode workhard (1/5 = 1)(6/10 = 0),gen(noworkhard)


*** Satisfaction with your life 
recode Q49(-9/-1 = .),gen(life_sta)
lab var life_sta "Satisfaction with your life"

*** Satisfaction with financial situation of household
recode Q50(-9/-1 = .),gen(inc_sta)
lab var inc_sta " financial Satisfaction"

***主觀收入層級
recode Q288(-9/-1 = .),gen(inc_level)

egen deprivation1 = rmean(life_sta inc_sta inc_level)
recode deprivation1 (1/5 = 1)(5.1/10 = 0),gen(deprivation)

gen nohope = .
replace nohope = 1 if nohope_sco == 1 & noworkhard == 1 & deprivation == 1
replace nohope = 1 if nohope_sco == 1 & noworkhard == 1 & deprivation == 0
replace nohope = 1 if nohope_sco == 1 & noworkhard == 0 & deprivation == 1
replace nohope = 2 if nohope_sco == 1 & noworkhard == 0 & deprivation == 0
replace nohope = 3 if nohope_sco == 0 & noworkhard == 1 & deprivation == 1
replace nohope = 4 if nohope_sco == 0 & noworkhard == 1 & deprivation == 0
replace nohope = 4 if nohope_sco == 0 & noworkhard == 0 & deprivation == 1
replace nohope = 4 if nohope_sco == 0 & noworkhard == 0 & deprivation == 0


lab def nohope 1 "社會-個人-" 2 "社會-個人+" 3 "社會+個人-" 4 "社會+個人+"
lab val nohope nohope

/*************************
         政治行動
**************************/	 

*** change social
recode Q42 (-9/-1 = .)(2 = 1 "gradually improved") ///
           (1 = 3 "radically changed")(3 = 2 "no chamge"),gen(cha_soc) 



***政治行動 未來可做
recode Q209 Q210 Q211 Q212 ///
       (-9/-2 = .)(3 = 2)(-1 2 = 1)(1 = 3)
 
/*Q218*/

/***************************************************
                     自變項
***************************************************/

/*************************
     個人基本變項
**************************/	 
	 
***sex 
recode Q260(-9/-1 = .)(1 = 1 "male")(2 = 0 "female"),gen(male)
lab var male "male"
	 
***age
recode Q262(-9/-1 = .),gen(age)	
lab var age "age" 

mvdecode X003R X003R2,mv(-9/-1)
ren X003R ageg6
ren X003R2 ageg3

***married
recode Q273(-9/-1 = .)(1 = 1 "married")(2/6 = 0 "others"),gen(married)	
lab var married "married" 
	 
***edug3 (lower == 1)
/*初级中等教育 高中 大學以上*/
clonevar edug3 = Q275R
recode edug3(-9/-1 = .)
lab var edug3 "edu group3"
	 
***Employment status 
recode Q279 (-9/-1 = .)(1 = 1 "Full time")(3 = 2 "Self employed") ///
            (2 = 3 "Part time")(4 = 4 "Retired")(5 = 5 "Homemaker") ///
            (6/8 = 6 "Unemployed/Other"),gen(employment)
lab var employment "employment"

***How many children do you have 
/*有些國家可能沒問*/
recode Q274 (-9/-1 = .)(0 = 0 "No children")(1/24 = 1 "have children") ///
            ,gen(children) 
lab var children "have children"

***subjective Social class /*類別 */
recode Q287 (-9/-1 = .)(1 = 5 "Upper class")(2 = 4 "Upper middle class ") ///
            (3 = 3 "Lower middle class")(4 = 2 "Working class") ///\
			(5 = 1 "Lower class"),gen(sclass)
lab var sclass "subjective Social class"

*** Importance of democracy
recode Q250(-9/-1 = .),gen(dem_import)
lab var dem_import "Importance of democracy"

***How democratically is this country being governed today 
recode Q251(-9/-1 = .),gen(dem_country)
lab var dem_country "How democratically is this country"

*** Satisfaction with the political system performance
recode Q252(-9/-1 = .),gen(political_sta)
lab var political_sta "Satisfaction with the political"



/*
***Post-Materialist index 12-item 
recode Y001 (-2 = .),gen(post_m)
lab var post_m "Post-Materialist"

***rural
recode H_URBRURAL(-9/-1 = .)(1 = 0 "urban")(2 = 1 "rural"),gen(rural) 
lab var rural "rural"
***Religious denominations  Q289

***Importance of God 
recode Q164 (-9/-1 = .),gen(god)
lab var god "Importance of God"

*** Most people can be trusted 
recode Q57(-9/-1 = .)(1 = 1)(2 = 0),gen(trust)
lab var trust "social trust"

***Standard of living comparing with your parents (Worse off = 2)
recode Q56(-9/-1 = .)(2 = 1 "worse")(3 = 2 "same")(1 = 3 "Better") ///
          ,gen(compare_live)
lab var compare_live "生活水準相較父母更好"

***How much freedom of choice and control
recode Q48(-9/-1 = .),gen(freedom)

*/


/***************************************************
                 missing 
***************************************************/
gen touse = !missing( ///
            hdi, v2xeg_eqdr, gdpg , cha_soc, nohope, ///
			male, age, ageg6, ageg3, married, edug3, ///
			employment, children, sclass,  ///
			dem_import, dem_country, political_sta,  ///
			Q209, Q210, Q211, Q212 ///
			)
			
drop if B_COUNTRY == 434 /*Libya*/
drop if touse == 0

/***************************************************
      country_n               
***************************************************/

keep  B_COUNTRY B_COUNTRY_ALPHA countrycode A_YEAR   ///
            hdi v2xeg_eqdr gdpg nohope cha_soc ageg6 sclass  ///
			male age ageg3 married edug3 employment children  ///
			dem_import dem_country political_sta  ///
			Q209 Q210 Q211 Q212 
			
order  B_COUNTRY B_COUNTRY_ALPHA countrycode A_YEAR   ///
            hdi v2xeg_eqdr gdpg nohope cha_soc ageg6 sclass  ///
			male age ageg3 married edug3 employment children ///
			dem_import dem_country political_sta ///
			Q209 Q210 Q211 Q212 

compress			
save   "WVS_W7_data\WVSW7_clean_230117.dta"

/*

***pweight
sort countrycode
merge m:1 countrycode using  "WVS_W7_data\country\pweight.dta"
drop _merge

forvalues i=5/9 {
gsem (workhard freedom life_sta inc_sta inc_level ///
      gov_care inc_eq Q247 Q241 Q244 <-, regress), ///
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
estimates stats profile*
*/	  

