* Last Updated: 2023. 03. 03
* File name: [Youth Mental Health AI]model
* Data: Youth Mental Health AI
* Subject: clean data

/*****************************
*                  *
*****************************/
cd "D:\Dropbox\工作\杏容老師_work\Youth Mental Health AI"

*******************************************************************************
use "data\Youth Mental Health AI.dta",clear


/*******************************************************************************
                           背景資料
*******************************************************************************/

***確認重複觀察值
duplicates tag onewcid,gen(rep_onewcid)
duplicates tag id,gen(rep_id)
duplicates tag newcid,gen(rep_newcid)
duplicates tag email,gen(rep_email)


***年齡(確認30歲以下)
clonevar age = p12q1t1 
lab var age "age"
drop if age >= 30

***性別
destring p12q2,force replace
recode p12q2 (1 = 0 "女")(2 = 1 "男")(3 = .),gen(male)
replace male = 1 if p12s6t1 == "男性" /*其他回答男性*/
lab var male "male"

***學歷
clonevar edu = p12q5
lab def edu 1 "大一" 2 "大二" 3 "大三" 4 "大四" 5 "延畢生"
lab val edu edu
lab var edu "年級"

***家庭平均月收入(萬)
gen hinc = .
replace hinc = 0 if p13q17 == 1
replace hinc = (p13q17*2 - 3) if p13q17 >= 2 & p13q17 <= 16
replace hinc = 35 if p13q17 == 17
replace hinc = 45 if p13q17 == 18
replace hinc = 75 if p13q17 == 19
replace hinc = 100 if p13q17 == 20
replace hinc = . if p13q17 == -9 | p13q17 == 21
lab var hinc "家庭平均月收入(萬)" /*缺失有點多 注意處理*/

***家庭收入狀況3類
recode p13q14 (1/2 = 1 "差")(3 = 2 "中等")(4/5 = 3 "好")(-9 = .),gen(hinc3)
lab var hinc3 "家庭收入狀況3類"

***族群、身心障礙、曾領過政府補助、助學貸款

/*******************************************************************************
                           分析變項
*******************************************************************************/

***學校類別 schregion
lab var schregion "學校類別"

***系所三大類 depname3
lab var depname3 "科系(三類)"

gen depname3_0 = 1

tab depname3 ,gen(depname3_)
lab var depname3_1 "文哲史"
lab var depname3_2 "社工"
lab var depname3_3 "理工"

/************************************
            心理健康
*************************************/
***幸福感 p2q1sc1 p2q1sc2 p2q1sc3 p2q1sc4 p2q1sc5
global Happiness_f5 "p2q1sc1 p2q1sc2 p2q1sc3 p2q1sc4 p2q1sc5"
mvdecode $Happiness_f5 ,mv(-9)

gen happiness = (p2q1sc1 + p2q1sc2 + p2q1sc3 + p2q1sc4 + p2q1sc5)/5
lab var happiness "幸福感"

***憂鬱情緒
/*
p2q2sc1 p2q2sc2 p2q2sc3 p2q2sc4 p2q2sc5 p2q2sc6 p2q2sc7 p2q2sc8 p2q2sc9 p2q2sc10 p2q2sc11 p2q2sc12 p2q2sc13 p2q2sc14 p2q2sc15 p2q2sc16 p2q2sc17 p2q2sc18 p2q2sc19 p2q2sc20
*/

global Depress_f20 "p2q2sc1 - p2q2sc20"
mvdecode $Depress_f20 ,mv(-9)

gen depress = (p2q2sc1 + p2q2sc2 + p2q2sc3 + p2q2sc4+ p2q2sc5 + p2q2sc6 ///
                     + p2q2sc7 + p2q2sc8 + p2q2sc9 + p2q2sc10 + p2q2sc11 ///
					 + p2q2sc12 + p2q2sc13 + p2q2sc14 + p2q2sc15 + p2q2sc16 ///
					 + p2q2sc17 + p2q2sc18 + p2q2sc19 + p2q2sc20)/20
lab var depress "憂鬱情緒"

/************************************
            不同壓力源
*************************************/
***課業壓力 p3q1sc1 p3q1sc2 p3q1sc3 p3q1sc4 p3q1sc5
global Pre_aca_f5 "p3q1sc1 p3q1sc2 p3q1sc3 p3q1sc4 p3q1sc5"
mvdecode $Pre_aca_f5 ,mv(-9)

gen pre_aca = (p3q1sc1 + p3q1sc2 + p3q1sc3 + p3q1sc4 + p3q1sc5)/5
lab var pre_aca "課業壓力"

***就業壓力 p3q1sc18 p3q1sc19 p3q1sc20 p3q1sc21 p3q1sc22 p3q1sc23
global Pre_job_f6 "p3q1sc18 p3q1sc19 p3q1sc20 p3q1sc21 p3q1sc22 p3q1sc23"
mvdecode $Pre_job_f6 ,mv(-9)

gen pre_job = (p3q1sc18 + p3q1sc19 + p3q1sc20 + p3q1sc21 + p3q1sc22 ///
                    + p3q1sc23)/6
lab var pre_job "就業壓力"

***人際壓力 p3q1sc10 p3q1sc11 p3q1sc12 p3q1sc13
global Pre_per_f4 "p3q1sc10 p3q1sc11 p3q1sc12 p3q1sc13"
mvdecode $Pre_per_f4 ,mv(-9)

gen pre_per = (p3q1sc10 + p3q1sc11 + p3q1sc12 + p3q1sc13)/4
lab var pre_per "人際壓力"

/************************************
            壓力因應策略
*************************************/
***問題取向積極因應 p4q1sc1 p4q1sc2 p4q1sc3 p4q1sc4 p4q1sc5 p4q1sc6
global Coping_pro_p_f6 "p4q1sc1 p4q1sc2 p4q1sc3 p4q1sc4 p4q1sc5 p4q1sc6"
mvdecode $Coping_pro_p_f6 ,mv(-9)

gen coping_pro_p = (p4q1sc1 + p4q1sc2 + p4q1sc3 + p4q1sc4 + p4q1sc5 ///
                    + p4q1sc6)/6
lab var coping_pro_p "問題取向積極因應"

***問題取向消極因應 p4q1sc7 p4q1sc8 p4q1sc9 p4q1sc10 
global Coping_pro_n_f4 "p4q1sc7 p4q1sc8 p4q1sc9 p4q1sc10"
mvdecode $Coping_pro_n_f4 ,mv(-9)

gen coping_pro_n = (p4q1sc7 + p4q1sc8 + p4q1sc9 + p4q1sc10)/4
lab var coping_pro_n "問題取向消極因應"

***情緒取向積極因應 p4q1sc11 p4q1sc12 p4q1sc13 p4q1sc14 
global Coping_emo_p_f4 "p4q1sc11 p4q1sc12 p4q1sc13 p4q1sc14"
mvdecode $Coping_emo_p_f4 ,mv(-9)

gen coping_emo_p = (p4q1sc11 + p4q1sc12 + p4q1sc13 + p4q1sc14)/4
lab var coping_emo_p "情緒取向積極因應"

***情緒取向消極因應 p4q1sc15 p4q1sc16 p4q1sc17 p4q1sc18
global Coping_emo_n_f4 "p4q1sc15 p4q1sc16 p4q1sc17 p4q1sc18"
mvdecode $Coping_emo_n_f4 ,mv(-9)

gen coping_emo_n = (p4q1sc15 + p4q1sc16 + p4q1sc17 + p4q1sc18)/4
lab var coping_emo_n "情緒取向消極因應"

/************************************
            社會支持(得到)
*************************************/

***情感性支持
/*p5q1sc3 p5q1sc4 p5q1sc5 p5q1sc7 p5q1sc9 p5q1sc11 p5q1sc12 p5q1sc13 p5q1sc14*/
global SupGet_emo_f9 "p5q1sc3 p5q1sc4 p5q1sc5 p5q1sc7 p5q1sc9 p5q1sc11 p5q1sc12 p5q1sc13 p5q1sc14"
mvdecode $SupGet_emo_f9 ,mv(-9)

gen SupGet_emo = (p5q1sc3 + p5q1sc4 + p5q1sc5 + p5q1sc7 + p5q1sc9 ///
                     + p5q1sc11 + p5q1sc12 + p5q1sc13 + p5q1sc14)/9
lab var SupGet_emo "情感性支持(得到)"

***實質性支持 p5q1sc1 p5q1sc8
global SupGet_Tgb_f2 "p5q1sc1 p5q1sc8"
mvdecode $SupGet_Tgb_f2 ,mv(-9)

gen SupGet_Tgb = (p5q1sc1 + p5q1sc8)/2
lab var SupGet_Tgb "實質性支持(得到)"

***資訊性支持 p5q1sc2 p5q1sc6 p5q1sc10 p5q1sc15
global SupGet_info_f4 "p5q1sc2 p5q1sc6 p5q1sc10 p5q1sc15"
mvdecode $SupGet_info_f4 ,mv(-9)

gen SupGet_info = (p5q1sc2 + p5q1sc6 + p5q1sc10 + p5q1sc15)/4
lab var SupGet_info "資訊性支持 (得到)"

/************************************
            正念
*************************************/
/* p6q1sc1 - p6q1sc15 (都要反向) */
global Mindfulness_f15 "p6q1sc1 - p6q1sc15"
mvdecode $Mindfulness_f15 ,mv(-9)

foreach var of varlist p6q1sc1 - p6q1sc15{
	clonevar `var'n = `var'
	replace `var'n = 6 + 1 - `var'n
}

gen mindfulness = (p6q1sc1n + p6q1sc2n + p6q1sc3n + p6q1sc4n + p6q1sc5n ///
                   + p6q1sc6n + p6q1sc7n + p6q1sc8n + p6q1sc9n + p6q1sc10n ///
				   + p6q1sc11n + p6q1sc12n + p6q1sc13n + p6q1sc14n + p6q1sc15n)/15

drop p6q1sc1n -	p6q1sc15n			   
				   
lab var mindfulness "正念"

/************************************
            線上遊戲動機
*************************************/
***有沒有玩 (確認跳答) p9q1
* brow p9q2sc1 - p9q2sc14 p9q3sc1 -p9q3sc10 if p9q1 == -9 /*檢查*/
/*p9q1 遺漏(-9) 後續都有填有玩 將其歸類為 有玩線上遊戲*/


global GameMoti_f14 "p9q2sc1 - p9q2sc14"
mvdecode $GameMoti_f14 ,mv(-9)

foreach x in 1/14{
	drop if p9q1 == 2 & p9q2sc`x' != .  /*確認跳答*/
}

***逃避 p9q2sc13 p9q2sc14
global GameMoti_esc_f2 "p9q2sc13 p9q2sc14"
gen GameMoti_esc = (p9q2sc13 + p9q2sc14)/2
lab var GameMoti_esc "線上遊戲_逃避"

***追求成就 p9q2sc1 - p9q2sc6
global GameMoti_ach_f6 "p9q2sc1 - p9q2sc6"
gen GameMoti_ach = (p9q2sc1 + p9q2sc2 + p9q2sc3 + p9q2sc4 + p9q2sc5 ///
                    + p9q2sc6)/6
lab var GameMoti_ach "線上遊戲_追求成就"

***社交動機 p9q2sc7 - p9q2sc11
global GameMoti_sco_f5 "p9q2sc7 - p9q2sc11"
gen GameMoti_sco = (p9q2sc7 + p9q2sc8 + p9q2sc9 + p9q2sc10 + p9q2sc11)/5
lab var GameMoti_sco "線上遊戲_社交"

/************************************
            社團參與
*************************************/
lab var p12q8c1 "「國小時期」，曾參加校內的社團活動"
lab var p12q8c2 "「國中時期」，曾參加校內的社團活動"
lab var p12q8c3 "「高中職時期（涵蓋專一~專三）時期」，曾參加校內的社團活動"
lab var p12q8c4 "「大學時期」，曾參加校內的社團活動"
lab var p12q8c5 "都沒有"
lab var p12q9 "請問您上大學至今參加的學校社團是什麼性質？"
lab def p12q9 1 "無 " 2 "綜合性（例如：系學會）" ///
              3 "康樂性（例如：吉他社、熱舞社）" 4 "學術文藝性" 5 "體能性 " ///
			  6 "服務性" 7 "其他（請說明）"
lab val p12q9 p12q9
lab var p12s2t1 "請問您上大學至今參加的學校社團是什麼性質？其他（請說明）"
 
lab var p12q10c1 "接續上題，在學校社團中，您有沒有實際學到「組織和規劃活動」？"
lab var p12q10c2 "接續上題，在學校社團中，您有沒有實際學到「與人相處及合作」？"
lab var p12q10c3 "接續上題，在學校社團中，您有沒有實際學到「蒐集和整理資料」？"
lab var p12q10c4 "接續上題，在學校社團中，您有沒有實際學到「增加學科或術科相關的知識」？"
lab var p12q10c5 "接續上題，在學校社團中，您有沒有實際學到「增加對社會或自然的關懷」？"
lab var p12q10c6 "接續上題，在學校社團中，您有沒有實際學到什麼？「其他」"
lab var p12s1t1 "接續上題，在學校社團中，您有沒有實際學到什麼？其他（請說明）"

lab var p12q11c1 "接續上題，請問您在社團中，有沒有曾經擔任過「組員」？"
lab var p12q11c2 "接續上題，請問您在社團中，有沒有曾經擔任過「正副社長以外的幹部（如活動組長或副組長）」？"
lab var p12q11c3 "接續上題，請問您在社團中，有沒有曾經擔任過「副社長」？"
lab var p12q11c4 "接續上題，請問您在社團中，有沒有曾經擔任過「社長」？"
lab var p12q12 "接續上題，社團活動的參與程度？"
lab def p12q12 1 "只去過兩、三次" 2 "偶爾才去" ///
              3 "每周規律去社團，偶爾有事才沒去" ///
			  4 "除了社團時間之外，額外花很多時間在社團相關的活動或是人際互動上"
lab val p12q12 p12q12
mvdecode p12q12,mv(-9)

/*******************************************************************************
                             global
*******************************************************************************/
/*
DV: happiness depress D1 D2
IV: pre_aca pre_job pre_per I1 I2 I3
MV:
	coping_pro_p coping_pro_n coping_emo_p coping_emo_n M11 M12 M13 M14
	SupGet_emo SupGet_Tgb SupGet_info M21 M22 M23
	mindfulness M30
	GameMoti_esc GameMoti_ach GameMoti_sco M41 M42 M43
dp  depname3_0 depname3_1 depname3_2 depname3_3 d0 d1 d2 d3
*/

global D1 "happiness"
global D2 "depress"
global DV "D1 D2"

global I1 "pre_aca"
global I2 "pre_job"
global I3 "pre_per"
global IV "I1 I2 I3"

global M11 "coping_pro_p"
global M12 "coping_pro_n"
global M13 "coping_emo_p"
global M14 "coping_emo_n"
global M21 "SupGet_emo"
global M22 "SupGet_Tgb"
global M23 "SupGet_info"
global M30 "mindfulness"
global M41 "GameMoti_esc"
global M42 "GameMoti_ach"
global M43 "GameMoti_sco"
global MV_1_2 "M11 M12 M13 M14 M21 M22 M23"
global MV_1_2_3 "M11 M12 M13 M14 M21 M22 M23 M30"
global MV "M11 M12 M13 M14 M21 M22 M23 M30 M41 M42 M43"

global d0 "depname3_0"
global d1 "depname3_1"
global d2 "depname3_2"
global d3 "depname3_3"
global dep3 "d1 d2 d3"
global dep4 "d0 d1 d2 d3"

compress
