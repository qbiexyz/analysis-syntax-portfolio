* Last Updated: 
* File name: []
* Data: 
* Subject: 


/*****************************
*                            *
*****************************/

* 路徑設定
cd "C:\Dropbox\工作\杏容老師_work\TIGPS_w2" 

**************************************************************************
* 暫存清理
est clear

* 讀取資料
use "10 data\tigps_w2.dta", clear

/*****************************
*       資料清理相關         *
*****************************/

// 以 堅毅Hardiness 處理為例

/***************************************************************************
堅毅 Hardiness

4.請問你同不同意以下的敘述
      □(1)很不同意     □(2)不太同意    □(3)還算同意   □(4)很同意
4-1就算身體有點不舒服或有其他正當理由可以休息，我還是會努力完成每天該做的事。
4-2就算是我不喜歡的事，我也會盡全力做。
4-3就算一件事需要很長時間才會開始看到結果，我仍然會努力維持我在這件事上的表現
***************************************************************************/

tab1 v4_1 v4_2 v4_3, m // 檢查原始變項

clonevar hardiness_1 = v4_1 // 複製一個新的變項 不要動到原始的
mvdecode hardiness_1 , mv(-9)	// 設定缺失值

foreach x of num 1/3 { // `x' 內重複 num 1/3
	clonevar hardiness_`x' = v4_`x' // 複製一個新的變項 不要動到原始的
	mvdecode hardiness_`x', mv(-9)	// 設定缺失值 
}

factor hardiness_*, pcf // 因素分析
estat kmo // 因素分析 kmo 值

alpha hardiness_* // 信度分析

gen HARDINESS = hardiness_1 + hardiness_2 + hardiness_3
egen HARDINESS = rowtotal(hardiness_*), m // 創建堅毅 rowtotal 加總因子

lab var HARDINESS "堅毅" // 變項標籤

*父母婚姻狀態
// 重新編碼
recode v2 (1/3 = 1 "雙親")(4 5 = 2 "離婚")(6 7 = 3 "未婚") ///
		 (8/10 = 4 "過世")(* = .), gen(pmarital)
lab var pmarital "父母婚姻狀態"

* 保留分析變項
keep ///
	student_oid - class ///
	br_v - b_va ///
	hardiness_1 - fclass
	
* 排序變項
order ///
	student_oid - class ///
	br_v - b_va ///
	hardiness_1 - fclass

* 壓縮檔案大小
compress

/*****************************
*      描述統計相關         *
*****************************/

* 卡方
tab br_4 female, chi col nof

* Anova
oneway WHO5 br_4, tab bonferroni scheffe

* 相關表的輸出 
asdoc pwcorr ///
		  CESDR9 CESDR10 EVENT HARDINESS DCOP CR ES ///
		  , star(all) ///
		  save(30 output\cor1)

// 注意!此輸出的顯著值是 *** 0.01 ** 0.05 * 0.1
// 要變較常使用的格式要手動更改
pwcorr ///
		   CESDR10 EVENT HARDINESS DCOP CR ES ///
		  , sig

* t檢定
t2docx BR_FV BR_FA BC_FV BC_FA EVENT CR ES CRESA PROSOCIAL ///
        using "30 output\ttest.docx" ///
		, replace by(female) 

* 描述統計 (兩種輸出方式)
desctable ///
	i.event_1 i.event_2 i.event_3 i.event_4 i.event_5 i.event_6 i.event_7 ///
	cr_1 cr_2 cr_3 es_4 es_5 es_6 CR ES ///
	,filename("30 output\des") ///
	stats(n mean sd min max )
	
dtable  i.edu4 i.worksector3 i.Tempjob3 i.firmsize i.supervising ///
        nightshift holidayshift i.Secondjob inc i.urbanization ///
		if touse == 1 ///
		, cont(,stat(mean sd)) fact( ,stat(fvpercent)) ///
		nformat(%9.2f) export("30 output\des_231121.xlsx", replace) 

/*****************************
*         回歸相關         *
*****************************/
* 統一缺失值
gen touse = !missing(CESD_9, female, feco, SESTEEM, FS, CLASS, SCH) 
keep if touse 

* 回歸
reg CESD_9 female feco  BR_FV BC_FV // 多元回歸
est store m1 // 暫存模型

* 輸出模型
esttab  m* ///
		, b(3) se(3) r2 ar2 obslast nogaps compress  ///
		nonum nobase  mtitles order(_cons) append  

*去中心化
sum SESTEEM, meanonly
gen SESTEEMr = SESTEEM - r(mean)
		

* 調節
reg CESD_9 female feco  ///
	b1.b_rc3 ///
	SESTEEM FS CLASS SCH ///
	b_rc3#c.SESTEEMr b_rc3#c.FSr ///
	b_rc3#c.CLASSr b_rc3#c.SCHr
est store BR_FV	

* 畫圖	
est restore BR_FV			   
quietly margins , at(SESTEEMr = (-2.5(0.5)0.9) b_rc3 =(1, 2, 3))
marginsplot, noci ytitle("憂鬱情緒") xtitle("自尊") ///
	             title("") ylabel(0(5)40) xlabel(-2.5(0.5)0.9)  ///
				 legend(order(1 "只被實體霸凌" ///
			                  2 "只有被網路霸凌" ///
							  3 "只有被網路與實體霸凌") ///
					    col(3) position(6)) ///
			 recast(line)  ///
			 plot1opts(lwidth(thick))  ///
			 plot2opts(lwidth(thick)) ///
			 plot3opts(lwidth(thick)) 


/*****************************
*         L P C相關         *
*****************************/

* LCA
// 2/6 是看你要跑幾個類別
// gsem 後面是放你的變項
// (br_fv_01b - br_fv_08b  b <-, logit) logit是因為裡面變項都是二元0/1
// 假設有連續變項需要另外用 (br_fv_01b - br_fv_08b  b <-, regress) 
// 也有其他請參考help
forvalues i=2/6 {
quietly gsem ///
	        (br_fv_01b - br_fv_08b  bc_fv_01b - bc_fv_07b <-, logit), ///
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

* 模型適配度
// AIC、BIC
estimates stats profile*

// ABIC
forvalues i=2/6 {
quietly gsem ///
	        (br_fv_01b - br_fv_08b  bc_fv_01b - bc_fv_07b <-, logit), ///
	 lclass(C `i') nonrtolerance
eststo profile`i'

scalar SSBIC_class_`i' = -2 * e(ll) + e(rank) * ln((e(N)+2) / 24)
di SSBIC_class_`i'
}

// Entropy
forvalues i=2/6 {
quietly gsem ///
	        (br_fv_01b - br_fv_08b  bc_fv_01b - bc_fv_07b <-, logit), ///
	 lclass(C `i') nonrtolerance
eststo profile`i'


predict profile`i'*, classposteriorpr
local ent = 0

forvalues j = 1/`i' {
	gen temp`j'=(log(profile`i'`j')*(profile`i'`j'*-1))
	sum temp`j', meanonly
	local ent =`ent' + r(sum)
	drop temp`j'
	}
scalar ent=1-(`ent'/(e(N)*ln(e(k))))
scalar list ent

drop profile* 
}

* 看分類狀況 把資訊放到excel整理圖表
quietly gsem ///
	        (br_fv_01b - br_fv_08b  bc_fv_01b - bc_fv_07b <-, logit), ///
	 lclass(C 5) nonrtolerance
estat lcprob, nose // 每類比例
estat lcmean, nose // 每類各個因素的數值

* mlogit 之後的分析
mlogit ///
       bully_5 ///
	   female hlth feco b1.cohabit b1.rank  ///
	   FS CLASS SCH, b(1) 
est store m1

esttab m1 m2 using "30 output\lca\m1_240329.csv" ///
       , b(3) se(3) nogaps nol nonum  nobase replace unstack  ///
       transform(ln*: exp(2*@) exp(2*@) ) ///
       eqlabels("" "var(tenure)" "var(_cons)" "var(Residual)", none) ///
       varlabels(,elist(weight:_cons "{break}{hline @width}")) ///
       varwidth(10)	