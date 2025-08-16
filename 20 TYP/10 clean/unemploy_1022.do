* Last Updated: 2022. 10. 22
* File name: [new]unemploy_1022
* Data: TYP
* Subject: 

/*****************************
*          TYP 2014          *
*****************************/


cd "D:\Dropbox\qbiexyz\中研院_工作\TYP_work\new"

use data/14/TYP2014_20161121_stata15.dta,clear


/*
已經排除樣本: 排除現在沒有工作者(m2s003000不是選擇1)、 排除自雇者
keep if m2s003000==1 

recode m2s008000 (0=.)(1/2=1 "公部門")(3=2 "非營利組織")(4=1)(5=3 "私人企業或機構(含人民團體")(6=2)(7/10=4 "自雇者")(11/97=.),gen(worksector)
lab var worksector "工作職務部門"
drop if worksector==4
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

tab1 unemploy,m

/*****************************
*          TYP 2017          *
*****************************/

/*
已經排除樣本: 排除現在沒有工作者(m2s003000不是選擇1)、 排除自雇者
keep if m3s084000==1 

recode m3s089000 (0=.)(1/2=1 "公部門")(3=2 "非營利組織")(4=1)(5=3 "私人企業或機構(含人民團體")(6=2)(7/10=4 "自雇者")(11/97=.),gen(worksector)
lab var worksector "工作職務部門"
drop if worksector==4
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


