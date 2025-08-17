* Last Updated: 2023. 05 . 12
* File name: [tscs0818_modeling]
* Data:tscs018  
* Subject: clean data
* qbie

/***************************************************
*                     tscs18                       *
***************************************************/

cd "C:\Dropbox\工作\中研院_工作\! done\社會距離\"

use tscs0818_data\tscs182\tscs182.dta,clear


/*
recode b15a1 - b15c7(1 = 1)(2 = 0)(* = .)
*加總 /*三題都要回答*/
foreach x  of numlist 1/7 {
	gen social_dis_s`x' = b15a`x' + b15b`x' + b15c`x'
	
}

*平均

foreach x  of numlist 1/7 {
	egen social_dis_m`x' = mean(social_dis_s`x')
	
}
*/

lab def good 1 "好" 0 "不好"

foreach y of num 1/7 {
	foreach z in "a" "b" "c"{
		clonevar social_dis`z'_`y' = b15`z'`y'
		recode social_dis`z'_`y'(1 = 1)(2 = 0)(* = .)
		lab val social_dis`z'_`y' good
	}
}

*log using "tscs0818_output\社會距離(三類)18_230510.txt" ,text replace

*format social_dis_m* %3.1f
foreach x in "a" "b" "c"{
	tab1 social_dis`x'_7 social_dis`x'_6 social_dis`x'_5 ///
	     social_dis`x'_4 social_dis`x'_3 social_dis`x'_2 social_dis`x'_1
}

*log close

/**************************************************************************

***************************************************************************/

*sex.
recode a1 (1 = 1 "男")(2 = 0 "女"),gen(sex)
lab var sex "性別"

*age 年齡
mvdecode a2y,mv(97 98)
gen age=.
replace age= year_m-a2y

*educ
recode a11 (1/9=1 "高中/職以下")(10/19=2 "大學/專生")(20/21=3 "研究所以上") ///
			(22=2)(* = .),gen(educ3)
lab var educ3 "教育程度(三組)"

*父親族群
clonevar f_ethnic = a7
mvdecode f_ethnic, mv(90/99)
lab var f_ethnic "父親族群"

*eng ability
recode b23* (1 = 7)(2 = 6)(3 = 5)(4 = 4)(5 = 3)(6 = 2)(7 = 1)(* = .)

/*
gen eng_a = ( b23a+ b23b +b23c)/3
sum eng_a
*/

factor b23a b23b b23c, pcf
estat kmo
predict eng_a
lab var eng_a "英文能力"

*home income
gen inc_h=.
replace inc_h=0 if h28==1
replace inc_h=(h28-2)*1+.5 if h28>=2 & h28<=21
replace inc_h=(h28-22)*10+25 if h28>=22 & h28<=25
replace inc_h=70 if h28==26
replace inc_h=100 if h28==27
replace inc_h=. if h28>90
lab var inc_h "全家平均收入(萬)"

recode inc_h (0/3.5=1 "低")(3.6/7.5=2 "中")(8.5/100=3 "高")(.=4 "其他"),gen(inc_h4)
lab var inc_h4 "全家平均收入(四組)"

*internet
recode g7 (9990/9999 = 0),gen(internetuse)
gen intuse = internetuse/60
lab var intuse "上網時間"


*travel
recode b13* (1 = 1)(2 = 0)(* = .)

gen travel = 0
replace travel = 2 if b13a == 1 | b13b ==1
replace travel = 3 if b13c == 1 | b13d == 1
replace travel = 4 if b13e == 1 
replace travel = 5 if (b13a == 1 | b13b ==1) == 1 & (b13c == 1 | b13d == 1)
replace travel = 6 if (b13a == 1 | b13b ==1) == 1 & b13e == 1 
replace travel = 7 if b13e == 1 & (b13c == 1 | b13d == 1)
replace travel = 8 if (b13a == 1 | b13b ==1) == 1 & (b13c == 1 | b13d == 1) & b13e == 1 
replace travel = 1 if b13f == 1 | b13g == 1
lab var travel "出國旅遊"
lab def travel 0"沒有出過國" 1"有出國，跨洲" 2"只有中國" 3"只有東北亞" 4"只有東南亞" ///
 5"只有中國+東北亞" 6"只有中國+東南亞" 7"只有東北亞+東南亞" 8"只有中國+東北亞+東南亞"
lab val travel travel


gen travel_AE = 1 if b13f == 1 | b13g == 1

gen travel_Aisa = 0
replace travel_Aisa = 1 if b13f == 1 | b13g == 1
replace travel_Aisa = 2 if b13a == 1 | b13b == 1 | b13c == 1 | b13d == 1  | b13e == 1




*meet
recode b14* (1 = 1)(2 = 0)(* = .)
gen meet = 0
replace meet = 2 if b14a == 1 | b14b ==1
replace meet = 3 if b14c == 1 | b14d == 1
replace meet = 4 if b14e == 1 
replace meet = 5 if (b14a == 1 | b14b ==1) == 1 & (b14c == 1 | b14d == 1)
replace meet = 6 if (b14a == 1 | b14b ==1) == 1 & b14e == 1 
replace meet = 7 if b14e == 1 & (b14c == 1 | b14d == 1)
replace meet = 8 if (b14a == 1 | b14b ==1) == 1 & (b14c == 1 | b14d == 1) & b14e == 1 
replace meet = 1 if b14f == 1 | b14g == 1
lab var meet "認識外國人"
lab def meet 0"沒有認識" 1"有認識，跨洲" 2"只有中國" 3"只有東北亞" 4"只有東南亞" ///
 5"只有中國+東北亞" 6"只有中國+東南亞" 7"只有東北亞+東南亞" 8"只有中國+東北亞+東南亞"
lab val meet meet

/*
lab var social_dis_s1 "日本"
lab var social_dis_s2 "韓國"
lab var social_dis_s3 "中國"
lab var social_dis_s4 "香港澳門"
lab var social_dis_s5 "東南亞"
lab var social_dis_s6 "歐洲"
lab var social_dis_s7 "美洲"
*/

* urbanization
ren stratum2 urbanization

keep id sex age educ3 f_ethnic eng_a inc_h inc_h4 intuse travel meet ///
     urbanization social_disa_1 - social_disc_7

order id sex age educ3 f_ethnic eng_a inc_h inc_h4 intuse travel meet ///
	  urbanization social_disa_1 - social_disc_7
	  
compress
