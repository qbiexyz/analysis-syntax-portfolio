* Last Updated: 2023. 04. 01
* File name: [new]14_data_manage
* Data: TYP
* Subject: Data Manage

/*****************************
*          TYP 2014          *
*****************************/

cd "D:\Dropbox\工作\中研院_工作\! done\TYP_work\new"

use data/14/TYP2014_20161121_stata15.dta,clear


*只選現在有工作
keep if m2s003000==1 

*教育程度
tab m2sedu
recode m2sedu (1/5 7 = 0 "未滿大學")(6 8/10=1 "大學以上") ///
              (*=.),gen(edu1_)
drop if edu1_ == .
lab var edu1_ "大學以上"

recode m2sedu (6 8 = 0 "大學(專)")(9 10=1 "碩士以上") ///
              (*=.),gen(edu2_)
lab var edu2_ "碩士以上"

recode m2sedu (1 = 1 "國中")(2 3 =2 "高中職")(4 5 7 = 3 "大學二年") ///
              (*=.),gen(edu3_)
lab var edu3_ "未滿大學分類"

recode m2sedu (1/3 = 4 "高中(職)以下")(4 5 7 = 3 "二年專科")(6 8 = 2 "四年大學") ///
			  (9 10=1 "碩士以上")(*=.),gen(edu4_)
lab var edu4_ "教育類別4類"

gen q3 = ustrregexs(0) if ustrregexm(m2sedusch, "^[[:alnum:]]{3}")
gen pubcd = ustrregexs(0) if ustrregexm(q3, "[[:alnum:]]{1}$")
drop q3

gen uni_pub = 0
replace uni_pub = 1 if pubcd == "0" | pubcd == "2" ///
                     | pubcd == "3" | pubcd == "4" | pubcd == "5"

recode edu4_ (1/2 = 0)(4 = 1)(3 = 2),gen(edu6_)

replace edu6_ = 3 if edu4_ == 2  
replace edu6_ = 4 if edu4_ == 2 & (uni_pub == 1 | m2sedusch=="999995")
replace edu6_ = 5 if edu4_ == 1 
replace edu6_ = 6 if edu4_ == 1 & (uni_pub == 1 | m2sedusch=="999995")
*(uni_pub == 1 | m2sedusch == "999995")

lab var edu6_ "教育類別6類"

lab def edu6_ 1 "高中(職)以下" 2 "二年專科" 3 "四年大學(私立)" ///
              4 "四年大學(公立)" 5 "碩士以上(私立)" 6 "碩士以上(公立)"
lab val edu6_ edu6_

*性別
recode m2ssex (1=1 "男")(2=0 "女"),gen(gender)
lab var gender "性別"

*樣本群
recode m2sgroup(1=0 "J1")(3=1 "J3"),gen(J3)
lab var J3 "樣本群"

*頂大VS其他
ren m2sedusch highest_sch
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
lab define topuniv 0 "其他學校" 1"頂大" 2 "國外大學"
lab val topuniv topuniv

*科系
gen bcode=substr(m2sedudep, 1, 2)
gen bcode4=substr(m2sedudep, 1, 4)
destring bcode, replace
replace bcode=. if m2sedudep <"100000" | m2sedudep  >"900000" | bcode== 33 | edu1_ == 0

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
recode m2s008000 (0=.)(1/2=1 "公部門")(3=2 "非營利組織")(4=1)(5=3 "私人企業或機構(含人民團體")(6=2)(7/10=4 "自雇者")(11/97=.),gen(worksector)
*/

recode m2s008000 (0=.)(1/2 = 0)(3 = 2)(4 = 0)(5 = 3)(6 = 2)(7/10 = 4) ///
                 (11 90/97=.),gen(worksector)
				 
replace worksector = 1 if worksector == 0 & m2s013009 == 1

lab var worksector "工作職務部門"
lab def worksector 0 "公部門(沒政府考試)" 1 "公部門(有政府考試)" 2 "非營利組織" ///
                   3 "私人企業或機構(含人民團體)" 4 "自雇者"
lab val worksector worksector

*排除自雇者
drop if worksector==4


*員工人數
recode m2s010000 (0=.)(1/3=1 "9人以下")(4/5=2 "10-99人")(6/7=3 "100-499人")(8/9=4 "500人以上")(97=.),gen(firmsize)
lab var firmsize "員工人數"

*工作需管多少人?
recode m2s011000 (0=.)(1=1 "0人")(2=2 "1-4人")(3=3 "5-9人")(4/9=4 "10人以上")(97=.),gen(supervising)
lab var supervising "工作需管多少人" 

*晚上工作
recode m2s017000 (0=.)(1=4 "經常需要")(2=3 "有時需要")(3=2 "很少需要")(4=1 "從不需要")(9=.),gen(nightshift)
lab var nightshift "晚上工作"

*假日工作
recode m2s018000 (0=.)(1=4 "經常需要")(2=3 "有時需要")(3=2 "很少需要")(4=1 "從不需要"),gen(holidayshift)
lab var holidayshift "假日工作"

*****依變項

*工作身分
recode m2s009000 (0=.)(1=0 )(2=0.5 )(3/6=1 )(7=.),gen(Tempjob)
replace Tempjob=0 if m2s009000_open =="生管，設備、生產管理"  |  m2s009000_open =="記帳員" 
replace Tempjob=1 if  m2s009000_open =="實習" | m2s009000_open =="實習教師" | m2s009000_open =="直銷員" | m2s009000_open =="試用期" 
lab var Tempjob "Tempjob"

*除了這份工作之外，你目前還有其他工作嗎（含兼差、打零工等）？
recode m2s036000(2 = 0 "沒有其他工作")(1 = 1 "有其他工作"),gen(Secondjob)
lab var Secondjob "Secondjob"


*包括加班每星期工作時數
gen workdays = .
replace workdays = m2s015000/10 if m2s015000 != 0 & m2s015000 != 97

recode m2s016001 (0 997/999=.), gen(workhrs)
lab var workhrs "工作總工時"
replace workhrs=m2s016000 if workhrs==. & m2s016000!=0 & m2s016000<=168

drop if workhrs == 144 | workhrs == 168

gen over_workhrs = workhrs - 40 if workhrs >= 40
replace over_workhrs = 0 if workhrs < 40

recode 	workhrs (0/40 = 0)(41/45 = 0.33)(46/50 = 0.66) ///
                (51/200 = 1),gen(overtime)


/*						 
recode workhrs (0=.)(1/40=0)(41/50 = 0.5)(51/200=1)(648/999=.),gen(overtime)
lab var overtime "每星期工作時數(包括加班)超過正常時數"
*/

*有加班嗎/加班有補貼或補休嗎
gen nosubsidy=.
replace nosubsidy=1 if m2s016002==1 &  m2s016a01==0 & m2s016a02==0  & m2s016a03==0
replace nosubsidy=2 if m2s016002==2 & (m2s016a01==1 | m2s016a02==1) & m2s016a03==2
replace nosubsidy=3 if m2s016002==2 &  m2s016a01==2 & m2s016a02==2  & m2s016a03==1
lab var nosubsidy "有加班沒有補貼或補休"

replace nosubsidy=1 if m2s016002==1 & m2s016a01==2 & m2s016a02==2 & m2s016a03==2
replace nosubsidy=2 if m2s016002==2 & m2s016a01==2 & m2s016a02==1 & m2s016a03==1
replace nosubsidy=3 if m2s016002==2 & m2s016a01==2 & m2s016a02==2 & m2s016a03==2
replace nosubsidy=2 if m2s016002==1 & m2s016a01==1 & m2s016a02==2 & m2s016a03==2
replace nosubsidy=1 if m2s016002==1 & m2s016a01==2 & m2s016a02==2 & m2s016a03==1
replace nosubsidy=2 if m2s016002==1 & m2s016a01==1 & m2s016a02==1 & m2s016a03==2
recode nosubsidy (1/2=0)(3=1)
lab def nosubsidy 0 "沒有加班或加班有補貼、補休" 1 "有加班沒有補貼或補休"
lab val nosubsidy nosubsidy


*時薪

gen inc=.
replace inc=0 if m2s019000==0
replace inc=100*25*(2*m2s019000-1) if m2s019000>=1 & m2s019000<=10
replace inc=(m2s019000-6)*10000+5000 if m2s019000>=11 & m2s019000<=20
replace inc=175000 if m2s019000==21
replace inc=225000 if m2s019000==22
replace inc=. if m2s019000>90

clonevar inc_month = inc

replace inc = inc/100000
recode inc (1.15/2.25 = 1.5)

lab var inc "工作平均月收(十萬元)"



/*
gen hourate=.
replace hourate=(inc)/(workhrs*4.348)
lab var hourate "時薪"


gen hourate500_ = hourate / 500
lab var hourate500_ "時薪(每500元)"
*/

*工作取代性
recode m2s034000 (1=1 )(2=0.75 )(3=0.5 )(4=0.25 )(5=0 )(0 7=.),gen(replaced)
lab var replaced "工作容易被取代"

*擔心失去工作
recode m2s035000 (0=.)(1/3 = 1)(4=0),gen(worry)
lab var worry "擔心失去工作"

/*
m2s005000
*/
recode m2s005000 (0 993/998 = .)(117 = 116),gen(zipcd)
sort zipcd

merge m:1 zipcd using "other/2020台灣社會變遷城鄉分級金馬_new.dta"
recode tscs_lv7_all (1/2 = 1 "metro_urban")(3/4 = 2 "local_manufacturing")(5/7 = 3 "rural_town")(* = 4 "other"),gen(urbanization) 
lab var urbanization "都市化程度"

drop if _merge == 2
drop _merge

*******************************************************************************
/*
已經排除樣本: 排除現在沒有工作者(m2s003000不是選擇1)、 排除自雇者
*/

mvdecode m2s004000 m2s037a13 m2s037b13 m2s037c13 m2s037d13 m2s037e13 m2s037f13 ,mv(997/999) 
mvdecode m2s004001 m2s037a14 m2s037b14 m2s037c14 m2s037d14 m2s037e14 m2s037f14,mv(13/99)
mvdecode m2s004000,mv(0)

/*現在這份工作開始年*100+月-之前做過其他工作結束年*100+月
  等於1或0代表無縫接軌，仍然屬於沒有失業*/
foreach x in a b c d e f{
    gen month_1`x' = .
	replace month_1`x' =  (m2s004000*100 + m2s004001) - (m2s037`x'13*100 + m2s037`x'14) if m2s037`x'14 != 0
	gen  month_`x' = 1 if month_1`x' == 0 | month_1`x' == 1
	drop month_1`x'
}

gen unemploy = .
/*14年現在工作開始時間84-101年*/
replace unemploy = 0 if m2s004000 >=  84  & m2s004000 <= 101

/*14年現在工作開始時間102年以上，中間沒有做過其他工作*/						
replace unemploy = 0 if (m2s004000 >=  102  & m2s004000 <= 104) & m2s037a13 == 0 & m2s037b13 == 0 ///
						& m2s037c13 == 0 & m2s037d13 == 0 & m2s037e13 == 0 & m2s037f13 == 0

/*14年現在工作開始時間102年以上，中間有做過其他工作*/						
replace unemploy = 1 if (m2s004000 >=  102  & m2s004000 <= 104) & ((m2s037a13 != 0 & m2s037a13 != .) ///
						| (m2s037b13 != 0 & m2s037b13 != .) | (m2s037c13 != 0 & m2s037c13 != .) ///
						| (m2s037d13 != 0 & m2s037d13 != .) | (m2s037e13 != 0 & m2s037e13 != .) ///
						| (m2s037f13 != 0 & m2s037f13 != .)) 
						
/*14年現在工作開始時間102年以上，中間有做過其他工作，但無縫接軌*/							
replace unemploy = 0 if (m2s004000 >=  102  & m2s004000 <= 104) & ((m2s037a13 != 0 & month_a == 1) ///
						| (m2s037b13 != 0 & month_b == 1) | (m2s037c13 != 0 & month_c == 1) ///
						| (m2s037d13 != 0 & month_d == 1) | (m2s037e13 != 0 & month_e == 1) ///
						| (m2s037f13 != 0 & month_f == 1)) 													
								
/*剩下缺失為現在工作開始時間或做過其他工作結束時間資料有缺失*/
					
lab var unemploy "失業"
lab def unemploy 1 "失業" 0 "沒失業"


/*

tab1 J3 nosubsidy Secondjob worry gender edu6_ worksector firmsize supervising urbanization unemploy  
		  
sum inc_month over_workhrs  Tempjob  replaced ///
     nightshift holidayshift 		  

	 
gen touse_14=!mi(Secondjob, Tempjob,overtime,  ///
                 inc, replaced, worry)
keep if touse_14

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
	Secondjob nosubsidy  Tempjob  overtime inc  replaced worry ) =14


compress
save data/14/typ2014_work_230401.dta


save data/14/typ2014_work_nosubsidy_230410.dta



*******************************************************************************

use data/14/TYP2014_20161121_stata15.dta,clear
keep id2 m2s013009

save data/14/gtest_230401.dta





/*
****10/15 工作滿意度
mvdecode m2s031*,mv(0 7/9)
foreach var of varlist m2s031*{
	replace `var'=4+1-`var'
	lab val `var'
}

ren m2s03100# jobatt#_
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

  