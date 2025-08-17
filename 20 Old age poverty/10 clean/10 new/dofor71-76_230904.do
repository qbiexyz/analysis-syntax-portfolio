* Last Updated: 2023. 06. 01
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/
/*
cd "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\"

******************************************************************************
est clear
use "10 data\家庭收支調查\73\inc73.dta",clear
*/
/*
* 若是亂碼
cd "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\10 data\家庭收支調查\77\"
unicode encoding set Big5
unicode translate "inc77.dta" , invalid(ignore) transutf8 nodata
*刪除資料夾
! rmdir /s/q "bak.stunicode"
*/

/*****************************************************************************
# market income =  
	We define market income as the sum of labor earnings and incomes 
	from property.                          
*****************************************************************************/
recode itm* (. = 0) /*(五)六、經常性(收入)支出的代碼*/

* salary (家戶)基本所得（受僱報酬itm190＋產業主所得itm240）
gen salary = itm190 + itm240
la var salary "基本所得"

* netpropertyinc 財產收入淨額 （財產所得itm330-利息支出itm540）
gen propertyinc = itm330 
gen netpropertyinc = itm330 - itm540

lab var propertyinc "財產收入"
lab var netpropertyinc "財產收入淨額"

/*market income (先不用減利息支出吧?)
itm390 租金 */ 
gen market_inc = salary + propertyinc + itm390
lab var market_inc "market income"

/*****************************************************************************
# 經常性移轉收入

移轉收入一共分為四大細項：私人420、政府430、
社會保險受益450、企業440、國外480 

transferpri來自私人 transferpub來自政府 
transferinsurance社會保險 transferother其他（企業和國外）

Private transfer income = (私人+其他)  
	includes income transferred from other households and nongovernment 
	institutions, but mainly consists of transfers from family members 
	living apart.

Public transfer income = (政府+社會保險)
	includes benefits from public pension and public assistance programs. 
                     
*****************************************************************************/
gen transferpri = itm420
gen transferpub = itm430
gen transferinsurance = itm450
gen transferother = itm440 + itm480
lab var transferpri "移轉來自私人"
lab var transferpub "移轉來自政府"
lab var transferinsurance "移轉來自社會保險"
lab var transferother "移轉來自其他（企業和國外）"

gen pri_trinc = transferpri + transferother
lab var pri_trinc "Private transfer income"

gen pub_trinc = transferpub + transferinsurance
lab var pub_trinc "Public transfer income"

/*****************************************************************************
# 非消費支出 
direct taxes paid
不包括私人及企業的經常移轉支出
*****************************************************************************/
gen direct_taxes = itm600 - itm570
lab var direct_taxes "direct taxes paid(非消費支出)"

/*****************************************************************************
# 貧窮率相關計算
先去除加權[iweight = a20]

*****************************************************************************/

*算戶內人口
foreach x of num 1/38{
	recode b4_`x'(0/150 = 1)(* = 0),gen(b4n_`x')
}

egen a8 = anycount(b4n_*),v(1)
drop b4n_*

/**********************************
## poor1 全部淨收入算一個貧窮率336806.2 360821.4 
**********************************/
/* 
計算家戶可支配所得，並排除極端值：
  所得收入總計-非消費支出+私人及企業的經常移轉支出
*/
gen dpi = itm400 - itm600 + itm570
lab var dpi "家戶可支配所得"
sum dpi /*拿掉加權*/

gen ey1 = dpi/(a8^0.5) /*a8 戶內人口數*/

* 去除極端下面，以 ey1平均*0.01 取代
qui sum ey1, de /*拿掉加權*/
gen botlin1 = 0.01*r(mean) 
replace ey1 = botlin1 if ey1 < botlin1

* 去除極端上面，以 dpi的pr50*10 取代
qui sum dpi, de /*拿掉加權*/
gen toplin1 = 10*r(p50) 
replace ey1 = toplin1/(a8^0.5) if dpi > toplin1

* 貧窮率嗎???????????????
qui sum ey1, de /*拿掉加權*/
gen povlin1 = r(p50)*0.6 /*60%*/

* poor1 貧窮 1 = 貧窮 
gen poor1 = 0
replace poor1 = 1 if ey1 < povlin1
lab var poor1 "poor1(dpi)"

* 淨收入貧窮率
egen poor1_rate = mean(poor1)
lab var poor1_rate "淨收入貧窮率"

/**********************************
## poor2 市場收入算一個貧窮率
(語法大致同poor1)
**********************************/
* poor2  market_inc
gen ey2 = market_inc/(a8^0.5) 

qui sum ey2, de 
gen botlin2 = 0.01*r(mean) 
replace ey2 = botlin2 if ey2 < botlin2

qui sum market_inc, de 
gen toplin2 = 10*r(p50) 
replace ey2 = toplin2/(a8^0.5) if market_inc > toplin2

qui sum ey2, de 
gen povlin2 = r(p50)*0.6 

gen poor2 = 0
replace poor2 = 1 if ey2 < povlin2
lab var poor2 "poor2(market_inc)"

* 市場收入貧窮率
egen poor2_rate = mean(poor2)
lab var poor2_rate "市場收入貧窮率"

/**********************************
## poor3 市場+私人 算一個貧窮率
(語法大致同poor1)
**********************************/
* poor3 
gen  market_pri = market_inc + pri_trinc
lab var market_pri "market + Private"

gen ey3 = market_pri/(a8^0.5) 

qui sum ey3, de 
gen botlin3 = 0.01*r(mean) 
replace ey3 = botlin3 if ey3 < botlin3

qui sum market_pri, de 
gen toplin3 = 10*r(p50) 
replace ey3 = toplin3/(a8^0.5) if market_pri > toplin3

qui sum ey3, de 
gen povlin3 = r(p50)*0.6 

gen poor3 = 0
replace poor3 = 1 if ey3 < povlin3
lab var poor3 "poor3(market_pri)"

* 市場+私人貧窮率
egen poor3_rate = mean(poor3)
lab var poor3_rate "市場+私人貧窮率"

/**********************************
## poor4 市場+私人+公共 算一個貧窮率
(語法大致同poor1)
**********************************/
* poor4 
gen market_pri_pub = market_pri + pub_trinc
lab var market_pri_pub "market + Private + Public"
 
gen ey4 = market_pri_pub/(a8^0.5) 

qui sum ey4, de 
gen botlin4 = 0.01*r(mean) 
replace ey4 = botlin4 if ey4 < botlin4

qui sum market_pri_pub, de 
gen toplin4 = 10*r(p50) 
replace ey4 = toplin4/(a8^0.5) if market_pri_pub > toplin4

qui sum ey4, de 
gen povlin4 = r(p50)*0.6 

gen poor4 = 0
replace poor4 = 1 if ey4 < povlin4
lab var poor4 "poor4(market_pri_pub)"

* 市場+私人+公共貧窮率
egen poor4_rate = mean(poor4)
lab var poor4_rate "市場+私人+公共貧窮率"

/**********************************
## poor5 稅? 算一個貧窮率
(語法大致同poor1)
**********************************/
gen market_pri_pub_taxes = market_pri + pub_trinc - direct_taxes
lab var market_pri_pub_taxes "market + Private + Public - direct_taxes"
 
gen ey5 = market_pri_pub_taxes/(a8^0.5) 

qui sum ey5, de 
gen botlin5 = 0.01*r(mean) 
replace ey5 = botlin5 if ey5 < botlin5

qui sum market_pri_pub_taxes, de 
gen toplin5 = 10*r(p50) 
replace ey5 = toplin5/(a8^0.5) if market_pri_pub_taxes > toplin5

qui sum ey5, de 
gen povlin5 = r(p50)*0.6 

gen poor5 = 0
replace poor5 = 1 if ey5 < povlin5
lab var poor5 "poor5(market_pri_pub_taxes)"

* 市場+私人+公共-稅貧窮率
egen poor5_rate = mean(poor5)
lab var poor5_rate "市場+私人+公共-稅貧窮率"

/*****************************************************************************
* 將資料從寬轉長，
* wide 轉 long 將b系列題組轉為個人變項，example:b1_1~b1_15 > b1_ 

處理newid
******************************************************************************/
reshape long b1_ b2_ b3_ b4_ b5_ b6_ b7_ b8_ b9_ b10_ b11_ b12_ b13_ b14_ ///
			 , i(id) j(rank)

drop if b1_==. | b2_==0

*新建newid

ds id , not(type string)
if "`r(varlist)'" == "id" {
tostring year id b1_ , gen(Y I B)
gen newid = Y + I
gen newid_detail = Y + I + "00" +B
}
else {
tostring year b1_ , gen(Y B)
gen newid = Y + id
gen newid_detail = Y + id + "00" + B
}

/*將newid_detail 長度大於12的取出(家戶編碼多一個0) 後3位*/
gen id_12_3 = ustrregexs(0) if ustrregexm(newid_detail, "[0-9]{3}$") ///
              & length(newid_detail) == 12
	  
/*將 原先過長的 以newid 加上正常家戶編碼*/			  
replace newid_detail = newid + id_12_3 if length(newid_detail) == 12

drop id_12_3

/*****************************************************************************
# 戶內狀況
個人性別 female

個人教育程度
戶內高教育數 highedunum

個人年齡 agegroup
戶內青年數 youthnum
戶內小孩數 childnum
戶內壯年數 middlenum
戶內老年數 oldnum

與戶長關係 headrelation
*****************************************************************************/
*個人性別 female
recode b3_ (1 = 0 "男")(2 = 1 "女")(* = .),gen (female)
lab var female "性別(女)"

*個人教育程度
recode b5_ (1 = 18)(2 = 16)(3 = 14)(4 5 = 12)(6 7 = 9)(8 = 6) ///
           (9 = 3)(10 = 0)(* = .), gen(eduy)
lab var eduy "教育年數"

recode b5_ (6/10 = 1 "國家以下")(4/5 = 2 "高中職")(1/3 =3 "大專/學以上") ///
           (* = .), gen(educ)
lab var educ "教育程度"

*戶內高教育數
gen highedu = 0
replace highedu = 1 if educ == 3
lab var highedu "高教育(大專/學以上)"

bys id: egen highedunum = sum(highedu)
lab var highedunum "戶內高教育數"

*個人年齡 agegroup
gen age = b4_
lab var age "年齡"
recode b4_ (0/17 = 1 "未滿18")(18/29 = 2 "青年") ///
           (30/59 = 3 "壯年")(60/150 = 4 "60以上")(* = .), gen(agegroup)
lab var agegroup "年齡(4類)"

*戶內青年數
gen youth = 0
replace youth = 1 if agegroup == 2 
lab var youth "青年(18/29)"

bys id: egen youthnum = sum(youth)
lab var youthnum "戶內青年數"

*戶內小孩數(未滿18)
gen child = 0
replace child = 1 if agegroup == 1 
lab var child "小孩(未滿18)"

bys id: egen childnum = sum(child)
lab var childnum "戶內小孩數(未滿18)"

*戶內壯年數
gen middle = 0
replace middle = 1 if agegroup == 3 
lab var middle "壯年(30/59)"

bys id: egen middlenum = sum(middle)
lab var middlenum "戶內壯年數"

*戶內老年數(60以上)
gen old_60 = 0
replace old_60 = 1 if agegroup == 4
lab var old_60 "老年(60以上)"

bys id: egen old_60_num = sum(old_60)
lab var old_60_num "戶內老年數(60以上)"

*戶內老年數(65以上)
gen old_65 = 0
replace old_65 = 1 if b4_ >= 65 & b4_ <= 150
lab var old_65 "老年(65以上)"

bys id: egen old_65_num = sum(old_65)
lab var old_65_num "戶內老年數(65以上)"

*戶內老年數(75以上)
gen old_75 = 0
replace old_75 = 1 if b4_ >= 75 & b4_ <= 150
lab var old_75 "老年(75以上)"

bys id: egen old_75_num = sum(old_75)
lab var old_75_num "戶內老年數(75以上)"

*檢查
gen num = youthnum + childnum + middlenum + old_60_num
gen missing1 = num - a8
/*戶內人口數可能有問題!!!!!!!!!!!! 先以num為後續*/


*與戶長關係
recode b2_ (1 3 = 0 "本人/配偶")(5 = 1 "子女")(2 = 2 "父母輩") ///
           (* = 3 "其他"),gen(headrelation)
lab var headrelation "與戶長關係"
*今年配偶有特別多貌似key錯的狀況
replace headrelation = 1 if headrelation == 0 & age < 18	
lab var headrelation "與戶長關係"


/*****************************************************************************
# 戶長相關
性別
婚姻狀態
戶長婚姻狀態
教育年數/程度
年齡
家戶結構
*****************************************************************************/
* 戶長性別 
gen headfemale0 = 0
replace headfemale0 = 1 if b2_ == 1 & female == 1
bys id: egen headfemale = sum(headfemale0)
lab def headfemale 0 "男" 1 "女"
lab val headfemale headfemale
lab var headfemale "戶長性別(女)"

///headmarried：經濟戶長性別婚姻狀態0"已婚" 1"男性單身" 2"女性單身" ///
recode b2_(3 = 1)(else = 0),gen(partner0)
replace partner0 = 0 if partner0 == 1 & age < 18
bys id:egen married = sum(partner0)
replace married = . if married > 1

gen headmarried0 = 0
replace headmarried0 = 1 if married == 1 & b2_ == 1
replace headmarried0 = . if married == .
bys id: egen headmarried1 = sum(headmarried0)

gen headmarried =0 
replace headmarried = 1 if headmarried1 == 0 & headfemale == 0
replace headmarried = 2 if headmarried1 == 0 & headfemale == 1
lab define headmar 0 "已婚" 1 "男性單身" 2 "女性單身"  
lab val headmarried headmar
la var headmarried "戶長婚姻狀態"
tab headmarried

* headeduy:戶長教育年數 
gen headeduy0 = 0
replace headeduy0 = eduy if b2_==1 
bys id: egen headeduy = sum(headeduy0)
lab var headeduy "戶長教育年數"

recode headeduy (0/9 = 1 "國家以下")(10/12 = 2 "高中職") ///
                (13/28 =3 "大專/學以上") ///
                (* = .), gen(headeduc)
lab var headeduc "戶長教育程度"

* headage:經濟戶長年齡 
gen headage0 = 0
replace headage0 = age if b2_ == 1 
bys id: egen headage = sum(headage0)
lab var headage "戶長年齡"

* 戶內人口數 
gen houholnum = num
lab var houholnum "戶內人口數"

* 就業人口數employment 
recode b13_ (1 3 = 1)(2 0 = 0),gen (employment0)
bys id:egen employment = sum(employment0)
lab var employment "戶內就業人口數"

* 家戶結構


///先設定若干條件 ///
gen snd1 = 0
replace snd1 = 1 if  b2_ == 5
bys id: egen snd = sum(snd1)
la var snd "與戶長關係為子女數"

gen elsemember0 = 0
replace elsemember0 = 1 if b2_ == 4 | inrange(b2_, 5, 12)
bys id:egen elsemember= sum(elsemember0) 
la var elsemember "與戶長關係為其他人數"

gen parents0 = 0
replace parents0 = 1 if b2_ == 2
bys id: egen parents= sum (parents0) 
la var parents "與戶長關係為父母數"

gen singleman = 0
replace singleman=1 if headmarried==1 & houholnum==1 
tab singleman

gen singlewoman=0
replace singlewoman=1 if headmarried==2 & houholnum==1 
tab singlewoman 

gen singledad=0
replace singledad=1 if headmarried ==1 & snd>0 & elsemember==0
tab singledad

gen singlemom=0
replace singlemom=1 if headmarried ==2 & snd>0 & elsemember==0
tab singlemom

gen corefami=0 
replace corefami=1 if headmarried==0 & snd>0  & elsemember==0 & parents==0
tab corefami

gen coupled=0 
replace coupled=1 if headmarried==0 & snd==0 & elsemember==0 & houholnum==2
tab coupled

gen youngwpar2=0
replace youngwpar2=1 if parents==2 & snd==0 & headmarried~=0
tab youngwpar2

gen youngwpar1=0
replace youngwpar1=1 if parents==1 & snd==0 & headmarried~=0
tab youngwpar1

gen hcomposit =9
replace hcomposit=1 if singledad
replace hcomposit=2 if singleman
replace hcomposit=3 if singlemom
replace hcomposit=4 if singlewoman
replace hcomposit=5 if corefami
replace hcomposit=6 if coupled
replace hcomposit=7 if youngwpar2
replace hcomposit=8 if youngwpar1
 
lab var hcomposit "家戶結構"

lab define hclabel 1"single man w/children" 2"single man w/o children" ///
                   3"single woman w/children" 4"single woman w/o children" ///
				   5"copuled with children" 6"copuled w/o children" ///
				   7"young adult w/coupled parents" ///
				   8"young adult w/single parent" 9"others"
lab val hcomposit hclabel

/*****************************************************************************
# 
*****************************************************************************/

*產業
recode b8_ (0 = 0) (11/13 = 1) (2/5 = 2) (6/10 = 3), gen(industry_t3)
lab def industry_t3 0 "無業者" 1 "農業" 2 "製造業" 3 "服務業"
lab val industry_t3 industry_t3
lab var industry_t3 "工作產業三分類"

*健保為公職(本人及眷屬)
gen nhi_pub = 0
replace nhi_pub = 1 if b7_== 1 | b7_== 2
lab var nhi_pub "健保為公職(本人及眷屬)"		
lab def nhi_pub 0 "否" 1 "是"
lab val nhi_pub nhi_pub


*受雇型態1
*無酬家屬工作者為自雇
recode b12_ (0 6 7 8 9 = 0) (1 = 1) (2 = 2) (3 4 = 4) (5 = 5), gen(hire)
replace hire = 3 if hire == 2 & nhi_pub == 0
lab def hire 0 "非勞動力" 1 "雇主" 2 "受雇於公部門" 3 "受雇於私部門" ///
             4 "自雇" 5 "失業"
lab val hire hire
lab var hire "受雇型態"

*受雇型態2
*無酬家屬工作者為自雇
recode hire(0 = 0)(1 = 1)(2/3 = 2)(4 = 3)(5 = 4), gen(hire5)
lab def hire5 0 "非勞動力" 1 "雇主" 2 "受雇" ///
              3 "自雇" 4 "失業"
lab val hire5 hire5
lab var hire5 "受雇型態5"

*階級
gen class = hire
replace class = 3 if hire == 2 | hire == 3
replace class = 2 if ( (b9_ >= 1 & b9_ <= 3) | b9_ == 11| b9_ == 13 ) & ///
                     ( hire == 2 | hire == 3 )
lab var class "階級"	
lab def class 0 "非勞動力" 1 "雇主" 2 "技術工人" 3 "非技術工人" 4 "自雇" 5 "失業"
lab val class class

/*個人基本所得：受僱hiredinc+ownerinc產業主，需要將個人戶口代號 b1_與itm 101-109配對，*/
/*先求得個人所屬代號的itm次序，再依序配對*/
gen match = 0
replace match = 1 if itm101 == b1_
replace match = 2 if itm102 == b1_
replace match = 3 if itm103 == b1_
replace match = 4 if itm104 == b1_
replace match = 5 if itm105 == b1_
replace match = 6 if itm106 == b1_
replace match = 7 if itm107 == b1_
replace match = 8 if itm108 == b1_
replace match = . if match == 0 & b14_ != 2 //意謂將不是非所得收入者卻match至0者列為遺漏值

gen hiredinc = 0 if match != .
replace hiredinc = itm191 if match == 1
replace hiredinc = itm192 if match == 2
replace hiredinc = itm193 if match == 3
replace hiredinc = itm194 if match == 4
replace hiredinc = itm195 if match == 5
replace hiredinc = itm196 if match == 6
replace hiredinc = itm197 if match == 7
replace hiredinc = itm198 if match == 8
lab var hiredinc "受雇收入"

gen ownerinc = 0 if match != .
replace ownerinc = itm241 if match == 1
replace ownerinc = itm242 if match == 2
replace ownerinc = itm243 if match == 3
replace ownerinc = itm244 if match == 4
replace ownerinc = itm245 if match == 5
replace ownerinc = itm246 if match == 6
replace ownerinc = itm247 if match == 7
replace ownerinc = itm248 if match == 8
sum ownerinc 
lab var ownerinc "產業主收入"

gen income = hiredinc + ownerinc
sum income
lab var income "個人基本所得"

///只顯示家戶 Head_of_Household
gen HH = 0
replace HH = 1 if b2_ == 1

keep ///
     newid newid_detail year HH salary propertyinc netpropertyinc ///
     market_inc transferpri transferpub transferinsurance transferother ///
	 pri_trinc pub_trinc direct_taxes dpi povlin1 poor1 poor1_rate povlin2 ///
	 poor2 poor2_rate market_pri povlin3 poor3 poor3_rate market_pri_pub ///
	 povlin4 poor4 poor4_rate market_pri_pub_taxes povlin5 poor5 ///
	 poor5_rate headfemale headeduy headeduc headage headmarried ///
	 married hcomposit houholnum employment highedunum youthnum childnum ///
	 middlenum old_60_num old_65_num old_75_num female eduy educ highedu ///
	 age agegroup youth child middle old_60 old_65 old_75 headrelation ///
	 industry_t3 nhi_pub hire hire5 class hiredinc ownerinc income missing1

order ///
     newid newid_detail year HH salary propertyinc netpropertyinc ///
     market_inc transferpri transferpub transferinsurance transferother ///
	 pri_trinc pub_trinc direct_taxes dpi povlin1 poor1 poor1_rate povlin2 ///
	 poor2 poor2_rate market_pri povlin3 poor3 poor3_rate market_pri_pub ///
	 povlin4 poor4 poor4_rate market_pri_pub_taxes povlin5 poor5 ///
	 poor5_rate headfemale headeduy headeduc headage headmarried ///
	 married hcomposit houholnum employment highedunum youthnum childnum ///
	 middlenum old_60_num old_65_num old_75_num female eduy educ highedu ///
	 age agegroup youth child middle old_60 old_65 old_75 headrelation ///
	 industry_t3 nhi_pub hire hire5 class hiredinc ownerinc income missing1

compress