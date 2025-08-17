* Last Updated: 2024. 10 .01
* File name: []
* Data:ABSW5  
* Subject: data clean

/***************************************************
*                      ABSW5                      *
***************************************************/

cd "C:\Dropbox\工作\中研院_工作\! done\ABSW5 Attitudes toward China\"

do "20 model\10 clean\10 merge macro index_230429"

lab def country_n ///
           1 "Japan" 2 "Hong Kong" 3 "Korea" 4 "China" 5 "Mongolia" ///
           6 "Philippines" 7 "Taiwan" 8 "Thailand" 9 "Indonesia" ///
          10 "Singapore" 11 "Vietnam" 12 "Cambodia" 13 "Malaysia" ///
          14 "Myanmar" 15 "Australia" 18 "India" 19 "Bangladesh" 20 "Srilanka"
lab val country country_n

replace country_nm = "Hong_Kong" if country_nm == "Hong Kong"
replace country_nm = "South_Korea" if country_nm == "Korea"

recode country (15 = 1 "Australia")(4 = 2 "China")(2 = 3 "Hong Kong") ///
               (18 = 4 "India")(9 = 5 "Indonesia")(1 = 6 "Japan") ///
			   (13 = 7 "Malaysia")(5 = 8 "Mongolia")(14 = 9 "Myanmar") ///
			   (6 = 10 "Philippines")(10 = 11 "Singapore") ///
			   (3 = 12 "South Korea")(7 = 13 "Taiwan") ///
			   (8 = 14 "Thailand")(11 = 15 "Vietnam") ///
			   ,gen(country_n)


***Q104(原) Q128(原) Q177(反) Q182 Q184

*Q104 Where would you place our country today? Democracy is suitable or not

recode q104(-1 97/99= .),gen(democracy)
replace democracy = 0 if q104 == 98
lab var democracy "q104 Where would you place our country today? Democracy is suitable or not"
lab def democracy 0 "Can't choose" 1 "Democracy is completely unsuitable" 10 "Democracy is perfectily suitable"
lab val democracy democracy

*Q128  Where would you place China today on this scale? 
recode q128(-1 97/99= .),gen(china_democracy)
replace china_democracy = 0 if q128 == 98
lab var china_democracy "q128 Where would you place China today on this scale?"
lab def china_democracy 0 "Can't choose" 1 "Completely Undemocratic" 10 "Completely democratic"
lab val china_democracy china_democracy

*Q177 Does China do more good or harm to the region? 
recode q177 (-1 7/9= .),gen(q177_m)
gen china_good=.
replace china_good = 4+1-q177_m
replace china_good = 0 if q177 == 8
drop q177_m
lab var china_good "q177 Does China do more good or harm to the region?"
lab def china_good 0 "Can't choose" 1 "Much more harm than good" 4 "Much more good than harm"
lab val china_good china_good

*Q182 General speaking, the influence China has on our country is?
recode q182 (-1 7/9= .),gen(q182_m)
gen china_influence=.
replace china_influence = 6+1-q182_m
replace china_influence = 0 if q182 == 8
drop q182_m
lab var china_influence "q182 General speaking, the influence China has on our country is?"
lab def china_influence 0 "Can't choose" 1 "Very negative" 6 "Very positive"
lab val china_influence china_influence

*Q184 General speaking, the influence United States has on our country is?
recode q184 (-1 7/9= .),gen(q184_m)
gen USA_influence=.
replace USA_influence = 6+1-q184_m
replace USA_influence = 0 if q184 == 8
drop q184_m
lab var USA_influence "q184 General speaking, the influence United States has on our country is?"
lab def USA_influence 0 "Can't choose" 1 "Very negative" 6 "Very positive"
lab val USA_influence USA_influence

*Q181 How much influence does China have on our country?
recode q181 (-1 7/9= .),gen(q181_m)
gen china_ginfluence=.
replace china_ginfluence = 4+1-q181_m
replace china_ginfluence = 0 if q181 == 8
drop q181_m
lab var china_ginfluence "Q181 How much influence does China have on our country?"
lab def china_ginfluence 0 "Can't choose" 1 "No influence at all" 4 "A great deal of influence"
lab val china_ginfluence china_ginfluence

*Q183 How much influence does the United States have on our country?
recode q183 (-1 7/9= .),gen(q183_m)
gen USA_ginfluence=.
replace USA_ginfluence = 4+1-q183_m
replace USA_ginfluence = 0 if q183 == 8
drop q183_m
lab var USA_ginfluence "Q183 How much influence does the United States have on our country?"
lab def USA_ginfluence 0 "Can't choose" 1 "No influence at all" 4 "A great deal of influence"
lab val USA_ginfluence USA_ginfluence

***Q1 Q2 Q3 Q4 Q5 Q6 
foreach var of varlist q1-q6{
	recode `var' (-1 7/9= .),gen(`var'_m)
	gen eco`var'=.
	replace eco`var' = 5+1-`var'_m
	replace eco`var' = 0 if `var' == 8
	drop `var'_m
}

ren ecoq1 ecoQ1
ren ecoq2 ecoQ2
ren ecoq3 ecoQ3
ren ecoq4 ecoQ4
ren ecoq5 ecoQ5
ren ecoq6 ecoQ6

lab def ecoQ1 0 "Can't choose" 1 "Very bad" 5 "Very good"
lab val ecoQ1 ecoQ1
lab val ecoQ4 ecoQ1 
lab def ecoQ2 0 "Can't choose" 1 "Very bad" 5 "Much better"
lab val ecoQ2 ecoQ2 
lab val ecoQ3 ecoQ2 
lab val ecoQ5 ecoQ2 
lab val ecoQ6 ecoQ2 
lab var ecoQ1 "q1 How would you rate the overall economic condition of our country today?"
lab var ecoQ2 "q2 How would you describe the change in the economic condition of our country over the last few years?"
lab var ecoQ3 "q3 What do you think will be the state of our country’s economic condition a few years from now?"
lab var ecoQ4 "q4 As for your own family, how do you rate the economic situation of your family today? "
lab var ecoQ5 "q5 How would you compare the current economic condition of your family with what it was a few years ago?"
lab var ecoQ6 "q6 What do you think the economic situation of your family will be a few years from now? "

***nationalism Q156 Q156a Q157 Q157a(反) Q158(原) 
gen nationalism_1 = .
replace nationalism_1 = 1 if q156 == 2 & q156a == 1
replace nationalism_1 = 2 if q156 == 2 & q156a == 2
replace nationalism_1 = 3 if q156 == 1 & q156a == 2
replace nationalism_1 = 4 if q156 == 1 & q156a == 1
replace nationalism_1 = 0 if q156 == 8 
lab var nationalism_1 "q156 Our country should defend our way of life instead of becoming more and more like other countries."
lab def nationalism_1 0 "Can't choose" 1 "Strongly disagree" 4 "Strongly agree"
lab val nationalism_1 nationalism_1

gen nationalism_2 = .
replace nationalism_2 = 1 if q157 == 2 & q157a == 1
replace nationalism_2 = 2 if q157 == 2 & q157a == 2
replace nationalism_2 = 3 if q157 == 1 & q157a == 2
replace nationalism_2 = 4 if q157 == 1 & q157a == 1
replace nationalism_2 = 0 if q157 == 8 
lab var nationalism_2 "q157 Do you agree or disagree with the following statement: “We should protect our farmers and workers by limiting the import of foreign goods.” "
lab def nationalism_2 0 "Can't choose" 1 "Strongly disagree" 4 "Strongly agree"
lab val nationalism_2 nationalism_2

recode q158(-1 7/9= .),gen(nationalism_3)
replace nationalism_3 = 0 if q158 == 8 
lab var nationalism_3 "q158 Do you think the government should increase or decrease the inflow of foreign immigrants into the country?"
lab def nationalism_3 0 "Can't choose" 1 "The government should increase the inflow of foreigners" 4 "The government should not allow any more foreigners"
lab val nationalism_3 nationalism_3

***government efficiency Q86 Q87 Q88 Q89 Q90(反)

foreach var of varlist q86 - q90{
	recode `var' (-1 7/9= .),gen(`var'_m)
	gen g_effect`var'=.
	replace g_effect`var' = 4+1-`var'_m
	replace g_effect`var' = 0 if `var' == 8 
	drop `var'_m
}

ren g_effectq86 g_effect_1
lab var g_effect_1 "q86 Over the long run, our system of government is capable of solving the problems our country faces."
lab def g_effect_1 0 "Can't choose" 1 "Strongly disagree" 4 "Strongly agree"
lab val g_effect_1 g_effect_1

ren g_effectq87 g_effect_2
lab var g_effect_2 "q87 Thinking in general, I am proud of our system of government."
lab val g_effect_2 g_effect_1

ren g_effectq88 g_effect_3
lab var g_effect_3 "q88 A system like ours, even if it runs into problems, deserves the people's support."
lab val g_effect_3 g_effect_1

ren g_effectq89 g_effect_4
lab var g_effect_4 "q89 I would rather live under our system of government than any other that I can think of."
lab val g_effect_4 g_effect_1

ren g_effectq90 g_effect_5
lab var g_effect_5 "q90 Compared with other systems in the world, would you say our system of government?"
lab def g_effect_5 0 "Can't choose" 1 "Should be replaced" 4 "It works fine, not need to change"
lab val g_effect_5 g_effect_5

***authoritarian Q137 Q138 Q139 Q140 (反)
foreach var of varlist q137 - q140{
	recode `var' (-1 7/9= .),gen(`var'_m)
	gen authoritarian`var'=.
	replace authoritarian`var' = 4+1-`var'_m
	replace authoritarian`var' = 0 if `var' == 8 
	drop `var'_m
}

ren authoritarianq137 authoritarian_1
lab var authoritarian_1 "q137 We should get rid of parliament and elections and have a strong leader decide things."
lab def authoritarian_1 0 "Can't choose" 1 "Strongly disagree" 4 "Strongly agree"
lab val authoritarian_1 authoritarian_1

ren authoritarianq138 authoritarian_2
lab var authoritarian_2 "q138 Only one political party should be allowed to stand for election and hold office."
lab val authoritarian_2 authoritarian_1

ren authoritarianq139 authoritarian_3
lab var authoritarian_3 "q139 The army (military) should come in to govern the country."
lab val authoritarian_3 authoritarian_1

ren authoritarianq140 authoritarian_4
lab var authoritarian_4 "q140 We should get rid of elections and parliaments and have experts make decisions on behalf of the people."
lab val authoritarian_4 authoritarian_1

mvdecode china_influence - authoritarian_4, mv(0)

generate authoritarian = (authoritarian_1 + authoritarian_2 + authoritarian_3 + authoritarian_4)/4
generate nationalism= (nationalism_1 + nationalism_2 + nationalism_3)/3
generate g_effect = (g_effect_1 + g_effect_2 + g_effect_3 + g_effect_4 + g_effect_5)/5


***gender /age /years of education/ group of household income 
*gender
recode SE2(1=1 "male")(2=0 "female")(* = .),gen(male)
lab var male "male"

*age
recode SE3_1 (-1 150/999= .),gen(age)
lab var age "age"

gen ageage = (age * age )/100
lab var ageage "age*age"

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


mvdecode q180,mv(-1 90/99)
**********
keep if  age > 17 & age < 80 
/*
keep if  age > 17 & age < 86
*/
**樣本數加權

recode country (1 = 984)(2 = 1069)(3 = 1257)(4 = 4778)(5 = 1279) ///
               (6 = 1185)(7 = 1178)(8 = 1179)(9 = 1510)(10 = 986) ///
			   (11 = 1200)(13 = 1232)(14 = 1604)(15 = 1483)(18 = 5238), ///
			   gen(weight)
			    
gen weightfac = 26162/weight
gen weightfac_nochina = 21384/weight if country != 4

keep country_n country_nm country Year HDI - economic_freedom USA_influence china_influence china_ginfluence USA_ginfluence china_good china_democracy democracy ecoQ1 - fincq_g4 weight weightfac weightfac_nochina  authoritarian nationalism g_effect q174 q180

order country_n country_nm country Year HDI - economic_freedom USA_influence china_influence china_ginfluence USA_ginfluence china_good china_democracy democracy ecoQ1 - fincq_g4 weight weightfac weightfac_nochina  authoritarian nationalism g_effect q174 q180

compress

save "10 data/Attitudes_toward_China.dta", replace



