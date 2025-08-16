* Last Updated: 2023. 05 . 12
* File name: [tscs0818_modeling]
* Data:tscs08   
* Subject: clean data
* qbie

cd "C:\Dropbox\工作\中研院_工作\! done\社會距離\"

/***************************************************
*                     tscs08                       *
***************************************************/

use tscs0818_data\tscs082\tscs082.dta,clear

drop j1c j2c j3c

*
global country "JPN KOR CHN SA EU NA"
lab def good 1 "好" 0 "不好"

foreach y in "a" "b" "d" "e" "f" "g"{
	foreach z of num 1/3{
		clonevar social_dis`z'_`y' = j`z'`y'
		recode social_dis`z'_`y'(1 = 1)(2 = 0)(* = .)
		lab val social_dis`z'_`y' good
	}
}

*log using "tscs0818_output\社會距離(三類)08_230510.txt" ,text replace

*format social_dis_m* %3.1f
foreach x of num 1/3{
	tab1 social_dis`x'_g social_dis`x'_f social_dis`x'_e ///
	     social_dis`x'_d social_dis`x'_b social_dis`x'_a
}

*log close

/**************************************************************************

***************************************************************************/
*sex.
recode v1 (1 = 1 "男")(2 = 0 "女"),gen(sex)
lab var sex "性別"

*age 年齡

*educ
recode v12 (1/9=1 "高中/職以下")(10/19=2 "大學/專生")(20/21=3 "研究所以上") ///
			(22=2)(* = .),gen(educ3)
lab var educ3 "教育程度(三組)"

*父親族群
recode v7 (1 = 1 "台灣閩南人")(2 = 2 "台灣客家人")(3 = 4 "大陸各省市") ///
          (4 = 3 "台灣原住民")(5 = 5 "其他")(* = .),gen(f_ethnic)
lab var f_ethnic "父親族群"

*eng ability
recode o* (1 = 5)(2 = 4)(3 = 3)(4 = 2)(5 = 1)(6 = 0)(* = .)

/*
gen eng_a = (o1+o2+o3)/3
sum eng_a
*/
factor o1 o2 o3, pcf
estat kmo
predict eng_a
lab var eng_a "英文能力"

egen qqqq= rmean(o1 o2 o3)
egen q33 = std(qqqq)

*home income
gen inc_h=.
replace inc_h=0 if u19==1
replace inc_h=(u19-2)*1+.5 if u19>=2 & u19<=21
replace inc_h=(u19-22)*10+25 if u19>=22 & u19<=25
replace inc_h=70 if u19==26
replace inc_h=100 if u19==27
replace inc_h=. if u19>90
lab var inc_h "全家平均收入(萬)"

recode inc_h (0/3.5=1 "低")(3.6/7.5=2 "中")(8.5/100=3 "高")(.=4 "其他"),gen(inc_h4)
lab var inc_h4 "全家平均收入(四組)"

*internet

recode t4b (1500/2000 = .)(9999 = 0),gen(internetuse)
gen intuse = internetuse/60
lab var intuse "上網時間"

*travel
recode i1* (1 = 1)(2 = 0)(* = .)

gen travel = 0
replace travel = 2 if i1a == 1 
replace travel = 3 if i1b == 1 | i1c == 1
replace travel = 4 if i1e == 1 
replace travel = 5 if i1a == 1 & (i1b == 1 | i1c == 1)
replace travel = 6 if i1a == 1 & i1e == 1 
replace travel = 7 if i1e == 1 & (i1b == 1 | i1c == 1)
replace travel = 8 if i1a == 1 & (i1b == 1 | i1c == 1) & i1e == 1 
replace travel = 1 if i1f == 1 | i1g == 1
lab var travel "出國旅遊"
lab def travel 0"沒有出過國" 1"有出國，跨洲" 2"只有中國" 3"只有東北亞" 4"只有東南亞" ///
 5"只有中國+東北亞" 6"只有中國+東南亞" 7"只有東北亞+東南亞" 8"只有中國+東北亞+東南亞"
lab val travel travel


gen travel_AE = 1 if i1f == 1 | i1g == 1

gen travel_Aisa = 0
replace travel_Aisa = 1 if i1f == 1 | i1g == 1
replace travel_Aisa = 2 if i1a == 1 | i1b == 1 | i1c == 1 | i1e == 1 


*meet
recode i2* (1 = 1)(2 = 0)(* = .)
gen meet = 0
replace meet = 2 if i2a == 1 
replace meet = 3 if i2b == 1 | i2c == 1
replace meet = 4 if i2e == 1 
replace meet = 5 if i2a == 1 & (i2b == 1 | i2c == 1)
replace meet = 6 if i2a == 1 & i1e == 1 
replace meet = 7 if i2e == 1 & (i2b == 1 | i2c == 1)
replace meet = 8 if i2a == 1 & (i2b == 1 | i2c == 1) & i2e == 1 
replace meet = 1 if i2f == 1 | i2g == 1
lab var meet "認識外國人"
lab def meet 0"沒有認識" 1"有認識，跨洲" 2"只有中國" 3"只有東北亞" 4"只有東南亞" ///
 5"只有中國+東北亞" 6"只有中國+東南亞" 7"只有東北亞+東南亞" 8"只有中國+東北亞+東南亞"
lab val meet meet

/*
lab var social_dis_sa "日本"
lab var social_dis_sb "韓國"
lab var social_dis_sd "中國"
lab var social_dis_se "東南亞"
lab var social_dis_sf "歐洲"
lab var social_dis_sg "美洲"
*/

* urbanization
ren stratum2 urbanization


keep id weight sex age educ3 f_ethnic eng_a inc_h inc_h4 intuse ///
     travel meet urbanization ///
     social_dis1_a - social_dis3_g

order id weight sex age educ3 f_ethnic eng_a inc_h inc_h4 intuse ///
      travel meet urbanization ///
      social_dis1_a - social_dis3_g

compress
