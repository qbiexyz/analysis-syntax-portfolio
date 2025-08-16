***410774205 社學三  吳永健  期末作業



cd "C:\Users\qbie\Desktop\Desktop\大三下\量化研究\practice\science"
use WVS_Cross-National_Wave_7_stata_v1_6_2.dta,clear

keep B_COUNTRY B_COUNTRY_ALPHA A_YEAR Q260 Q262 Q275 Q287 Q51 Q53 Q54 Q289 Q109 defiance disbelief relativism scepticism Q110 Q50 Q75 Q77 Q64 Q79 Q250 Q235 Q236 Q237 Q158 Q159 Q160 Q161 Q162 Q163

use qqq.dta,clear

/*處理變項*/

***個人層級變項
*性別
recode  Q260 (1=1 "male")(2=0 "female"),gen(Gender)
label variable Gender "性別"
*年齡
rename Q262 age
label variable  age "年齡"
*教育程度
rename Q275 edu
label variable  edu "教育程度"

*社會階層
recode Q287(1=5)(2=4)(3=3)(4=2)(5=1),gen(s_class)
label variable s_class "社會階層"

*個人的經濟安全

generate   eco_safe = (Q51+Q53+Q54)/3
label variable eco_safe "個人的經濟安全"

*宗教信仰

recode Q289(0=1)(1=4 "羅馬天主教")(2=3 "新教")(3=1)(4=1)(5=1)(6=1)(7=1)(8=2 "東正教基督教派")(9=1),gen(religion)  

label variable religion "宗教類別"

*世俗價值觀
label variable defiance "對傳統權威的蔑視"
label variable relativism "道德相對主義"
label variable disbelief  "宗教信仰的程度"
label variable scepticism "對國家權威的懷疑"

***依變項

generate sci_o = (Q158+Q159+Q163)/3
label variable sci_o "科學樂觀"
generate sci_r= (Q160+Q161+Q162)/3
label variable sci_r "科學保守"

keep B_COUNTRY B_COUNTRY_ALPHA A_YEAR Gender age edu s_class eco_safe religion defiance relativism  disbelief scepticism sci_o sci_r

save  bbb.dta

use bbb.dta,clear


***國家層級變項
*國家整理
drop if B_COUNTRY ==20 | B_COUNTRY ==50 |  B_COUNTRY ==68 | B_COUNTRY ==104 | B_COUNTRY ==158 | B_COUNTRY ==231 | B_COUNTRY ==300 | B_COUNTRY ==320 | B_COUNTRY ==344 | B_COUNTRY ==360 | B_COUNTRY ==364 | B_COUNTRY ==368 | B_COUNTRY ==398 | B_COUNTRY ==400 | B_COUNTRY ==446 | B_COUNTRY ==558 |  B_COUNTRY ==630 | B_COUNTRY ==688 | B_COUNTRY ==704 | B_COUNTRY ==762 

*遺漏值統一
drop if age==. | edu==. |  s_class==. | eco_safe==. |  religion==. |  defiance==. |  relativism==. |   disbelief==. |  scepticism==. |  sci_o==. |  sci_r==. 


*人類發展指數
gen hdi=0
replace hdi=0.81 if B_COUNTRY==32
replace hdi=0.94 if B_COUNTRY==36
replace hdi=0.74 if B_COUNTRY==76
replace hdi=0.82 if B_COUNTRY==152
replace hdi=0.7 if B_COUNTRY==156
replace hdi=0.72 if B_COUNTRY==170
replace hdi=0.85 if B_COUNTRY==196
replace hdi=0.72 if B_COUNTRY==218
replace hdi=0.92 if B_COUNTRY==276
replace hdi=0.91 if B_COUNTRY==392
replace hdi=0.91 if B_COUNTRY==410
replace hdi=0.62 if B_COUNTRY==417
replace hdi=0.75 if B_COUNTRY==422
replace hdi=0.77 if B_COUNTRY==458
replace hdi=0.78 if B_COUNTRY==484
replace hdi=0.92 if B_COUNTRY==554
replace hdi=0.47 if B_COUNTRY==566
replace hdi=0.52 if B_COUNTRY==586
replace hdi=0.74 if B_COUNTRY==604
replace hdi=0.65 if B_COUNTRY==608
replace hdi=0.97 if B_COUNTRY==642
replace hdi=0.78 if B_COUNTRY==643
replace hdi=0.4 if B_COUNTRY==716
replace hdi=0.72 if B_COUNTRY==764
replace hdi=0.71 if B_COUNTRY==788
replace hdi=0.72 if B_COUNTRY==792
replace hdi=0.74 if B_COUNTRY==804
replace hdi=0.66 if B_COUNTRY==818
replace hdi=0.94 if B_COUNTRY==840
label variable hdi "人類發展指數"

*民主發展指數
gen dem=0
replace dem=89.5 if B_COUNTRY==32
replace dem=67.4 if B_COUNTRY==36
replace dem=70.4 if B_COUNTRY==76
replace dem=84.5 if B_COUNTRY==152
replace dem=18.2 if B_COUNTRY==156
replace dem=54.6 if B_COUNTRY==170
replace dem=89 if B_COUNTRY==196
replace dem=55.2 if B_COUNTRY==218
replace dem=91.5 if B_COUNTRY==276
replace dem=85.9 if B_COUNTRY==392
replace dem=81.4 if B_COUNTRY==410
replace dem=27.9 if B_COUNTRY==417
replace dem=48.5 if B_COUNTRY==422
replace dem=47.1 if B_COUNTRY==458
replace dem=54.7 if B_COUNTRY==484
replace dem=92.5 if B_COUNTRY==554
replace dem=53.6 if B_COUNTRY==566
replace dem=43.5 if B_COUNTRY==586
replace dem=67.3 if B_COUNTRY==604
replace dem=64.7 if B_COUNTRY==608
replace dem=72.4 if B_COUNTRY==642
replace dem=27.4 if B_COUNTRY==643
replace dem=24.3 if B_COUNTRY==716
replace dem=46.6 if B_COUNTRY==764
replace dem=56.1 if B_COUNTRY==788
replace dem=58.2 if B_COUNTRY==792
replace dem=57.7 if B_COUNTRY==804
replace dem=39.4 if B_COUNTRY==818
replace dem=91.5 if B_COUNTRY==840
label variable dem "民主發展指數"


*國家科技產出指數
gen kcl=.
replace kcl=53.1 if B_COUNTRY==32
replace kcl=37.7 if B_COUNTRY==36
replace kcl=36.3 if B_COUNTRY==76
replace kcl=40.6 if B_COUNTRY==152
replace kcl=44.7 if B_COUNTRY==156
replace kcl=37.4 if B_COUNTRY==170
replace kcl=49.3 if B_COUNTRY==196
replace kcl=32.8 if B_COUNTRY==218
replace kcl=55.8 if B_COUNTRY==276
replace kcl=52.2 if B_COUNTRY==392
replace kcl=53.3 if B_COUNTRY==410
replace kcl=27 if B_COUNTRY==417
replace kcl=35.5 if B_COUNTRY==422
replace kcl=46.9 if B_COUNTRY==458
replace kcl=36.8 if B_COUNTRY==484
replace kcl=54.5 if B_COUNTRY==554
replace kcl=26.6 if B_COUNTRY==566
replace kcl=23.3 if B_COUNTRY==586
replace kcl=36 if B_COUNTRY==604
replace kcl=31.2 if B_COUNTRY==608
replace kcl=40.3 if B_COUNTRY==642
replace kcl=37.2 if B_COUNTRY==643
replace kcl=24 if B_COUNTRY==716
replace kcl=37.6 if B_COUNTRY==764
replace kcl=35.8 if B_COUNTRY==788
replace kcl=36 if B_COUNTRY==792
replace kcl=35.8 if B_COUNTRY==804
replace kcl=28.5 if B_COUNTRY==818
replace kcl=60.3 if B_COUNTRY==840
label variable kcl "國家科技產出指數"

*伊斯蘭教國家
gen muslim =0
replace muslim=1 if B_COUNTRY==417 | B_COUNTRY==422 | B_COUNTRY==458 | B_COUNTRY==586 | B_COUNTRY==788 | B_COUNTRY==792 | B_COUNTRY==818
label variable muslim "伊斯蘭教國家"

*後蘇聯國家
gen p_soviet =0
replace p_soviet=1 if B_COUNTRY==417 | B_COUNTRY==642 | B_COUNTRY==643 | B_COUNTRY==804
label variable p_soviet "後蘇聯國家"

save all.dta
***分析開始
use all.dta,clear
*科學樂觀
xtmixed sci_o || B_COUNTRY: ,var mle cov(unstr)
est store model11
xtmrho
xtmixed sci_o Gender age edu s_class eco_safe i.religion defiance relativism scepticism disbelief || B_COUNTRY: ,var mle cov(unstr)
est store model12
xtmrho
mltrsq
xtmixed sci_o hdi dem kcl muslim p_soviet Gender age edu s_class eco_safe i.religion defiance relativism scepticism disbelief || B_COUNTRY: ,var mle cov(unstr)
est store model13
xtmrho
mltrsq


*科學保守
xtmixed sci_r || B_COUNTRY: ,var mle  cov(unstr)
est store model21
xtmrho

xtmixed sci_r Gender age edu s_class eco_safe i.religion defiance relativism scepticism disbelief || B_COUNTRY: ,var mle cov(unstr)
est store model22
xtmrho
mltrsq
xtmixed sci_r hdi dem kcl muslim p_soviet Gender age edu s_class eco_safe i.religion defiance relativism scepticism disbelief || B_COUNTRY: ,var mle cov(unstr)
est store model23
xtmrho
mltrsq

