* Last Updated: 2023. 04. 01
* File name: [new]17_data_manage
* Data: TYP
* Subject: Data Manage

/*****************************
*          TYP 2017          *
*****************************/
*** TYP 2017
cd "D:\Dropbox\工作\中研院_工作\! done\TYP_work\new"

use data/17/TYP2017_all_原始資料,clear

*只選現在有工作
keep if m3s084000==1 

tab m3sedulevel
recode m3sedulevel (1/5 7 = 0 "未滿大學")(6 8/10=1 "大學以上") ///
              (*=.),gen(edu1_)
drop if edu1_ == .
lab var edu1_ "大學以上"

recode m3sedulevel (6 8 = 0 "大學(專)")(9 10=1 "碩士以上") ///
              (*=.),gen(edu2_)
lab var edu2_ "碩士以上"

recode m3sedulevel (1 = 1 "國中")(2 3 =2 "高中職")(4 5 7 = 3 "大學二年") ///
              (*=.),gen(edu3_)
lab var edu3_ "未滿大學分類"

recode m3sedulevel (1/3 = 4 "高中(職)以下")(4 5 7 = 3 "二年專科")(6 8 = 2 "四年大學") ///
			  (9 10=1 "碩士以上")(*=.),gen(edu4_)
lab var edu4_ "教育類別"

gen q3 = ustrregexs(0) if ustrregexm(m3sedusch, "^[[:alnum:]]{3}")
gen pubcd = ustrregexs(0) if ustrregexm(q3, "[[:alnum:]]{1}$")
drop q3

gen uni_pub = 0
replace uni_pub = 1 if pubcd == "0" | pubcd == "2" ///
                     | pubcd == "3" | pubcd == "4" | pubcd == "5"

recode edu4_ (1/2 = 0)(4 = 1)(3 = 2),gen(edu6_)

replace edu6_ = 3 if edu4_ == 2 
replace edu6_ = 4 if edu4_ == 2 & (uni_pub == 1 | m3sedusch=="999995")
replace edu6_ = 5 if edu4_ == 1 
replace edu6_ = 6 if edu4_ == 1 & (uni_pub == 1 | m3sedusch=="999995")
lab var edu6_ "教育類別6類"

lab def edu6_ 1 "高中(職)以下" 2 "二年專科" 3 "四年大學(私立)" ///
              4 "四年大學(公立)" 5 "碩士以上(私立)" 6 "碩士以上(公立)"
lab val edu6_ edu6_
			  
*性別
recode m3ssex (1=1 "男")(2=0 "女"),gen(gender)
lab var gender "性別"

*樣本群
recode group (1=0 "J1")(3=1 "J3"),gen(J3)
lab var J3 "樣本群"

*頂大VS其他
ren m3sedusch highest_sch
gen topuniv=.
replace topuniv=1 if highest_sch=="000001" /*政治大學*/ | ///
 highest_sch=="000002" /*清華大學*/ | highest_sch=="000003" /*臺灣大學*/ | ///
 highest_sch=="000004" /*臺灣師範大學*/ | highest_sch=="000005" /*成功大學*/ | ///
 highest_sch=="000006" /*中興大學*/ | highest_sch=="000007" /*交通大學*/ | ///
 highest_sch=="000008" /*中央大學*/ | highest_sch=="000009" /*中山大學*/ | ///
 highest_sch=="000012" /*臺灣海洋大學*/ | highest_sch=="000016" /*陽明大學*/ | ///
 highest_sch=="0022" /*臺灣科技大學*/ | highest_sch=="001004" /*中原大學*/ | ///
 highest_sch=="001009" /*長庚大學*/ | highest_sch=="001010" /*元智大學*/ | ///
 highest_sch=="001019" /*高雄醫學大學*/ | highest_sch=="001028" /*臺北醫學大學*/
replace topuniv=2 if highest_sch=="999995"
replace topuniv=0 if topuniv!=1 & topuniv!=2 & highest_sch!="000000"/*跳答*/ & highest_sch!="999999" /*遺漏值*/
replace topuniv=. if edu1_ == 0
lab var topuniv "頂大"
lab define topuniv 0 "其他大學" 1"頂大" 2 "國外大學"
lab val topuniv topuniv

*科系
gen bcode=substr(m3sedudep, 1, 2)
gen bcode4=substr(m3sedudep, 1, 4)
destring bcode, replace
replace bcode=. if m3sedudep <"100000" | m3sedudep  >"900000" | bcode== 43 | edu1_ == 0

#delimit ;
lab def bcode
14 "教育學門"
21 "藝術學門"
22 "人文學門"
23 "設計學門"
31 "社會及行為科學學門"
32 "傳播學門"
34 "商業及管理學門"
38 "法律學門"
42 "生命科學學門"
44 "自然科學學門"
46 "數學及電算機科學類"
48 "電算機學門"
52 "工程學門"
54 "工程學門2"
58 "建築及都市規劃學門"
62 "農業科學學門 "	
64 "獸醫學門"
72 "醫藥衛生學門"
76 "社會服務學門"
81 "民生學門"
84 "運輸服務學門"
85 "環境保護學門"
86 "軍警國防安全學門";
#delimit cr
lab val bcode bcode

* Major
recode bcode (14/32 76/81=1    "人文社科") ///
             (34/38=2          "金融商管") ///
             (44/58 84/86=3       "工程理化") ///
             (42 62/72=4      "生科醫學")(*=.), gen(major)
replace major=2 if bcode4=="3101" //經濟學類
lab var major "主修科系"

*工作職務性質
/*
recode m3s089000 (0=.)(1/2=1 "公部門")(3=2 "非營利組織")(4=1)(5=3 "私人企業或機構(含人民團體")(6=2)(7/10=4 "自雇者")(11/97=.),gen(worksector)
*/

merge 1:1 id2 using "data/14/gtest_230401.dta"
drop if _merge == 2
drop _merge

recode m3s089000 (0=.)(1/2 = 0)(3 = 2)(4 = 0)(5 = 3)(6 = 2)(7/10 = 4) ///
                 (11 90/97=.),gen(worksector)
				 
replace worksector = 1 if worksector == 0 & m2s013009 == 1

lab var worksector "工作職務部門"
lab def worksector 0 "公部門(沒政府考試)" 1 "公部門(有政府考試)" 2 "非營利組織" ///
                   3 "私人企業或機構(含人民團體)" 4 "自雇者"
lab val worksector worksector

*排除自雇者
drop if worksector==4

*員工人數
recode m3s091000 (0=.)(1/3=1 "9人以下")(4/5 30=2 "10-99人")(6/7=3 "100-499人")(8/9=4 "500人以上")(97 98 99=.),gen(firmsize)
lab var firmsize "員工人數"

*工作需管多少人?
recode m3s092000 (0=.)(1=1 "0人")(2=2 "1-4人")(3=3 "5-9人")(4/9=4 "10人以上")(97/99=.),gen(supervising)
lab var supervising "工作需管多少人" 

*晚上工作
recode m3s096000 (0=.)(1=4 "經常需要")(2=3 "有時需要")(3=2 "很少需要")(4=1 "從不需要")(9=.),gen(nightshift)
lab var nightshift "晚上工作"

*假日工作
recode m3s097000 (0=.)(1=4 "經常需要")(2=3 "有時需要")(3=2 "很少需要")(4=1 "從不需要"),gen(holidayshift)
lab var holidayshift "假日工作"

*****依變項

*工作身分
recode m3s090000 (0=.)(1=0 )(2=0.5 )(3/6=1 )(7=.),gen(Tempjob)
replace Tempjob=0 if m3s090000_open =="受訓合格後才算正職（高考通過正在養成）"
replace Tempjob=0.5 if m3s090000_open == "學生（博士生）（教授雇用）"  
replace Tempjob=1 if  m3s090000_open =="有案子才需上班" | m3s090000_open =="補習班無契約" 
lab var Tempjob "Tempjob"


*除了這份工作之外，你目前還有其他工作嗎（含兼差、打零工等）？
recode m3s114000(2 = 0 "沒有其他工作")(1 = 1 "有其他工作")(* = .),gen(Secondjob)
lab var Secondjob "有其他工作"

*包括加班每星期工作時數
recode m3s095010 (0 648 997/999=.), gen(workhrs)
lab var workhrs "工作總工時"

replace workhrs=m3s095000 if workhrs==. & m3s084000==1 & ///
                             m3s095000<990 & m3s095010!=648
drop if workhrs == 149 | workhrs == 168
gen over_workhrs = workhrs - 40 if workhrs >= 40
replace over_workhrs = 0 if workhrs < 40
recode 	workhrs (0/40 = 0)(41/45 = 0.33)(46/50 = 0.66) ///
                (51/200 = 1),gen(overtime)							 
							 
/*							 
recode workhrs (0=.)(1/40=0)(41/50=0.5)(51/200=1)(648/999=.),gen(overtime)
lab var overtime "每星期工作時數(包括加班)超過正常時數"
*/

*有加班嗎/加班有補貼或補休嗎
gen nosubsidy=.
replace nosubsidy=1 if m3s095020==1 &  m3s095021==0 & m3s095022==0  & m3s095023==0
replace nosubsidy=2 if m3s095020==2 & (m3s095021==1 | m3s095022==1) & m3s095023==2
replace nosubsidy=3 if m3s095020==2 & (m3s095021==2 & m3s095022==2) & m3s095023==1
lab var nosubsidy "有加班沒有有補貼或補休"


replace nosubsidy=1 if m3s095020==1 & m3s095021==2 & m3s095022==2 & m3s095023==2
replace nosubsidy=2 if m3s095020==2 & m3s095021==2 & m3s095022==1 & m3s095023==1
replace nosubsidy=1 if m3s095020==1 & m3s095021==2 & m3s095022==2 & m3s095023==1
replace nosubsidy=2 if m3s095020==1 & m3s095021==2 & m3s095022==1 & m3s095023==2

recode nosubsidy (1/2=0)(3=1)
lab define nosubsidy 0 "沒有加班或加班有補貼、補休" 1 "有加班沒有補貼或補休" 
lab val nosubsidy nosubsidy

*賺錢能力(時薪)
gen inc=.
replace inc=0 if m3s098000==0
replace inc=100*25*(2*m3s098000-1) if m3s098000>=1 & m3s098000<=10
replace inc=(m3s098000-6)*10000+5000 if m3s098000>=11 & m3s098000<=20
replace inc=175000 if m3s098000==21
replace inc=225000 if m3s098000==22
replace inc=. if m3s098000>90

clonevar inc_month = inc

replace inc = inc / 100000
recode inc (1.15/2.25 = 1.5)
lab var inc "工作平均月收(十萬元)"

/*
gen 	hourate=.
replace hourate=(inc)/(workhrs*4.348)
lab var hourate "時薪"

gen hourate500_ = hourate / 500
lab var hourate500_ "時薪(每500元)"
*/


*工作取代性
recode m3s112000 (1=1 )(2=0.75)(3=0.5)(4=0.25)(5=0)(0 7=.),gen(replaced)
lab var replaced "工作容易被取代"

*擔心失去工作
recode m3s113000 (0=.)(1/3 = 1)(4=0),gen(worry)
lab var worry "擔心失去工作"

recode m3s086000 (0 993/998 = .)(117 = 116),gen(zipcd)
sort zipcd

merge m:1 zipcd using "other/2020台灣社會變遷城鄉分級金馬_new.dta"
recode tscs_lv7_all (1/2 = 1 "metro_urban")(3/4 = 2 "local_manufacturing")(5/7 = 3 "rural_town")(* = 4 "other"),gen(urbanization) 
lab var urbanization "都市化程度"

drop if _merge == 2

*******************************************************************************
/*
已經排除樣本: 排除現在沒有工作者(m2s003000不是選擇1)、 排除自雇者
*/

mvdecode m3s085001 m3s115a13 m3s115b13 m3s115c13 m3s115d13 m3s115e13 m3s115f13 ,mv(997/999) 
mvdecode m3s085002 m3s115a14 m3s115b14 m3s115c14 m3s115d14 m3s115e14 m3s115f14,mv(13/99)
mvdecode m3s085001,mv(0)

/*現在這份工作開始年*100+月-之前做過其他工作結束年*100+月
  等於1或0代表無縫接軌，仍然屬於沒有失業*/
foreach x in a b c d e f{
    gen month_1`x' = .
	replace month_1`x' =  (m3s085001*100 + m3s085002) - (m3s115`x'13*100 + m3s115`x'14) if m3s115`x'14 != 0
	gen  month_`x' = 1 if month_1`x' == 0 | month_1`x' == 1
	drop month_1`x'
}

gen unemploy = .
/*17年現在工作開始時間84-104年*/
replace unemploy = 0 if m3s085001 >=  84  & m3s085001 <= 104

/*17年現在工作開始時間105年以上，中間沒有做過其他工作*/						
replace unemploy = 0 if (m3s085001 >=  105  & m3s085001 <= 107) & m3s115a13 == 0 & m3s115b13 == 0 ///
						& m3s115c13 == 0 & m3s115d13 == 0 & m3s115e13 == 0 & m3s115f13 == 0

/*17年現在工作開始時間105年以上，中間有做過其他工作*/						
replace unemploy = 1 if (m3s085001 >=  105  & m3s085001 <= 107) & ((m3s115a13 != 0 & m3s115a13 != .) ///
						| (m3s115b13 != 0 & m3s115b13 != .) | (m3s115c13 != 0 & m3s115c13 != .) ///
						| (m3s115d13 != 0 & m3s115d13 != .) | (m3s115e13 != 0 & m3s115e13 != .) ///
						| (m3s115f13 != 0 & m3s115f13 != .)) 
						
/*17現在工作開始時間105年以上，中間有做過其他工作，但無縫接軌*/							
replace unemploy = 0 if (m3s085001 >=  105  & m3s085001 <= 107) & ((m3s115a13 != 0 & month_a == 1) ///
						| (m3s115b13 != 0 & month_b == 1) | (m3s115c13 != 0 & month_c == 1) ///
						| (m3s115d13 != 0 & month_d == 1) | (m3s115e13 != 0 & month_e == 1) ///
						| (m3s115f13 != 0 & month_f == 1)) 													
								
/*剩下缺失為現在工作開始時間或做過其他工作結束時間資料有缺失*/
					
lab var unemploy "失業"
lab def unemploy 1 "失業" 0 "沒失業"

/*

tab1 J3 nosubsidy Secondjob worry gender edu6_ worksector firmsize supervising urbanization unemploy  
		  
sum inc_month over_workhrs  Tempjob  replaced ///
     nightshift holidayshift 		  


gen touse_17=!mi(Secondjob, Tempjob,overtime,  ///
                 inc, replaced, worry)
keep if touse_17

log using "output\14_17_平均月收入(原始).txt", text append

tab inc_month

log close	 
*/





*******************************************************************************
keep id2 edu1_ edu2_ edu3_ edu4_ edu6_ gender J3 topuniv major worksector ///
    firmsize supervising nightshift holidayshift  zipcd urbanization unemploy ///
	Secondjob nosubsidy  Tempjob  overtime inc  replaced worry  

order id2 edu1_ edu2_ edu3_ edu4_ edu6_ gender J3 topuniv major worksector ///
    firmsize supervising nightshift holidayshift  zipcd urbanization unemploy ///
	Secondjob nosubsidy  Tempjob  overtime inc  replaced worry  
	
ren (edu1_ edu2_ edu3_ edu4_ edu6_ gender J3 topuniv major worksector ///
    firmsize supervising nightshift holidayshift  zipcd urbanization unemploy ///
	Secondjob nosubsidy  Tempjob  overtime inc  replaced worry ) =17

compress
save data/17/typ2017_work_230401.dta

save data/17/typ2017_work_nosubsidy_230410.dta

 
/*
****10/15 工作滿意度
mvdecode m3s110*,mv(0 7/9)
foreach var of varlist m3s110*{
	replace `var'=4+1-`var'
	lab val `var'
}

ren m3s1100(#)0 jobatt#_
lab var jobatt1_ "工作收入"
lab var jobatt2_ "工作環境"
lab var jobatt3_ "工作內容"
lab var jobatt4_ "工作時間"
lab var jobatt5_ "上司"
lab var jobatt6_ "同事"
lab var jobatt7_ "福利"
lab var jobatt8_ "升遷機會"
lab var jobatt9_ "工作整體的狀況"
*/ 

