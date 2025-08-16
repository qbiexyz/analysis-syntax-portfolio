* Last Updated: 2024. 03. 29
* File name: []
* Data: 學生AB總檔_0131LABEL
* Subject: 


/*****************************
*                            *
*****************************/
/*
cd "C:\Dropbox\工作\杏容老師_work\TIGPS_w1"

**************************************************************************
est clear

use "10 data\學生AB總檔_0325LABEL.dta" ,clear
*/

/*****************************
*   霸凌相關題目(按順序)     *
*****************************/

/***************************************************************************
（B卷）
七年級以來 ，同學之間有時會發生衝突。當有同學被欺負時，請問你多常做以下的事情？
    (1)從未  (2)偶爾  (3)有時  (4)經常  (5)沒發生過
tabm as49*
當同學被惡意嘲笑時，我會幫忙被嘲笑的人
當同學被威脅、騷擾時，我會保護被威脅的人
當同學被惡意排擠而無法分組或參加活動時，我會設法讓同學不要被排擠
當別人嘲笑特定同學，我不會加入對話，或將這些內容傳給別人
當我知道有同學被威脅、騷擾，我不會有任何反應或行動
當有人被惡意排擠而無法分組或參加活動時，我不會多管閒事
當我收到別人傳來同學的出醜或是不雅照片，我不會傳給別人(先保留)
當同學被惡意嘲笑時，我會跟著一起嘲笑那個人
當同學被威脅、騷擾時，我會跟著做這些行為
當同學被排擠而無法分組或參加活動時，我也不會跟這個同學一組
***************************************************************************/

*幫忙弱者
foreach x in "a" "b" "c" {
	clonevar b_help_`x' = as49`x'
	mvdecode b_help_`x', mv(-999 -9)
	recode b_help_`x' (5 = 0)
}

factor b_help_a - b_help_c, pcf

egen B_HELP = rmean(b_help_a - b_help_c)
lab var B_HELP "幫忙弱者"


*霸凌旁觀
foreach x in "d" "e" "f" "g" {
	clonevar b_bystander_`x' = as49`x'
	mvdecode b_bystander_`x', mv(-999 -9)
	recode b_bystander_`x' (5 = 0)
}

factor b_bystander_d - b_bystander_f, pcf

egen B_BYSTANDER = rmean(b_bystander_d - b_bystander_f)
lab var B_BYSTANDER "霸凌旁觀"

*霸凌跟隨
foreach x in "h" "i" "j" {
	clonevar b_follow_`x' = as49`x'
	mvdecode b_follow_`x', mv(-999 -9)
	recode b_follow_`x' (5 = 0)
}

factor b_follow_h - b_follow_j, pcf

egen B_FOLLOW = rmean(b_follow_h - b_follow_j)
lab var B_FOLLOW "霸凌跟隨"

/***************************************************************************
（B卷）
請問你同不同意以下描述？ 
   (1)很不同意  (2)不太同意  (3)還算同意  (4)很同意
tab1 as50a as50b,m
我認為霸凌是一種不道德的行為
我們班很多同學可以容忍霸凌
***************************************************************************/
clonevar b_immoral = as50a
lab var b_immoral "霸凌是不道德"

clonevar b_tolerant = as50b
lab var b_tolerant "能容忍霸凌"

mvdecode b_immoral b_tolerant, mv(-999 -9)

/***************************************************************************
（AB卷）
as51
上七年級以來，你曾在實際生活中(非網上)，被其他人辱罵、惡意取笑、破壞或搶取東西、肢體攻擊、拒絕加入討論或活動嗎？
(選項1：曾經有、選項2：不曾)

tabm as51a*
上七年級以來，你曾在實際生活中(非網上)遇到這樣的事情嗎？
(從未,偶爾,有時,經常 1,2,3,4)
別人用髒話罵或威脅我
別人說我的壞話
不讓我加入討論、活動或<br>不准別人跟我說話、一起行動"
被嘲笑外表或言行舉止
被嘲笑我喜歡某個人
故意破壞我的東西或故意藏起來
勒索或強要我的東西
別人對我肢體攻擊

*未整理開放題 as51a9
其他霸凌行為(請說明):________________________________
***************************************************************************/
* 是否實體被霸凌
recode as51 (1 = 1 "曾有實體被霸凌")(2 = 0 "不曾實體被霸凌")(* = .), gen(br_v)
lab var br_v "曾有實體被霸凌"

* 累積實體被霸凌的頻率
foreach x of num 1/8 {
	clonevar br_fv_`x' = as51a`x'
	mvdecode br_fv_`x', mv(-999 -9 -8 -6)
	replace br_fv_`x' = br_fv_`x' - 1
}

foreach x of num 1/8 {
	replace br_fv_`x' = . if br_v == 0 | br_v == .
}

egen BR_FV = rowtotal(br_fv_1 - br_fv_8)
lab var BR_FV "累積實體被霸凌頻率"


foreach x of num 1/8 {
	recode br_fv_`x' (0/1 = 0)(2 = 1)(3 = 2)(* = .), gen(br_fv1_`x')
}
egen BR_FV1 = rowtotal(br_fv1_1 - br_fv1_8)
lab var BR_FV1 "累積實體被霸凌頻率(3)"


* 累積實體被霸凌的類型
foreach x of num 1/8 {
	recode br_fv_`x' (0 = 0)(1/3 = 1), gen(br_tv_`x')
}

egen BR_TV = rowtotal(br_tv_1 - br_tv_8)
lab var BR_TV "累積實體被霸凌類型"

replace BR_FV = . if br_v == 0 | br_v == .
replace BR_FV1 = . if br_v == 0 | br_v == .
replace BR_TV = . if br_v == 0 | br_v == .



/*
/***************************************************************************
（AB卷）
實體被霸凌:
tabm as51b*
請問是誰對你這麼做？(可複選)
□同班同學□同校不同班的同學□不同校的朋友□鄰居□其他(請說明)____
***************************************************************************/

foreach x of num 1/5{
	clonevar brv_who_`x' = as51b`x'
	mvdecode brv_who_`x', mv(-999 -9 -8 -6)
}

*整理開放題 aks51b5


/***************************************************************************
（AB卷）
實體被霸凌:
那你實際上如何反應 (可複選)
□好好說明澄清 □要求當事人停止 □忽略這些人與事情
□投入其他有趣或有意義的事情 □因為太困擾，無法做好平日應該要做的事 
□回擊、跟當事人對抗 □告訴其他同學或朋友 □告訴家人 □告訴老師 
□不去會遇到那個人的場所 □改變郵件帳號、電話號碼或網路封鎖讓當事人無法聯繫到我
□其他(請說明)_______
***************************************************************************/
* 創建複選
replace Q2_060 = "." if Q2_060 == "0"
/*
tab Q2_060
*/

gen brv_rea_1 = ustrregexm(Q2_060, "^(1,)|^(1)")
gen brv_rea_1n = ustrregexm(Q2_060, "^(10)|^(11)|^(12)|^(13)|^(14)")
replace brv_rea_1 = 0 if brv_rea_1n == 1
replace brv_rea_1 = . if Q2_060 == "."
drop brv_rea_1n 

gen brv_rea_2 = ustrregexm(Q2_060, "^(2)|^(1,2)")
replace brv_rea_2 = . if Q2_060 == "."

foreach x of num 3/12{
	gen brv_rea_`x' = ustrregexm(Q2_060, "`x',|`x'")
	replace brv_rea_`x' = . if Q2_060 == "."
}

lab var brv_rea_1 "被實際霸凌反應:好好說明澄清"
lab var brv_rea_2 "被實際霸凌反應:要求當事人停止"
lab var brv_rea_3 "被實際霸凌反應:忽略這些人與事情"
lab var brv_rea_4 "被實際霸凌反應:投入其他有趣或有意義的事情"
lab var brv_rea_5 "被實際霸凌反應:因為太困擾，無法做好平日應該要做的事 "
lab var brv_rea_6 "被實際霸凌反應:回擊、跟當事人對抗"
lab var brv_rea_7 "被實際霸凌反應:告訴其他同學或朋友"
lab var brv_rea_8 "被實際霸凌反應:告訴家人"
lab var brv_rea_9 "被實際霸凌反應:告訴老師"
lab var brv_rea_10 "被實際霸凌反應:不去會遇到那個人的場所"
lab var brv_rea_11 "被實際霸凌反應:改變郵件帳號、電話號碼或網路封鎖讓對方找不倒我"
lab var brv_rea_12 "被實際霸凌反應:其他"

* 整理開放題
gen brv_rea_12o = ustrregexs(0) if ustrregexm(Q2_060, "[\u4e00-\u9fa5]+")
replace brv_rea_12o = "空白" if brv_rea_12o == "" & brv_rea_12 == 1
lab var brv_rea_12o "被實際霸凌反應:其他_詳細"

/*
brow Q2_060 Q2_060_1 - Q2_060_12n
*/
*/
/***************************************************************************
（AB卷）
tab1 as52,m
上七年級以來，你曾在實際生活中(非網上)，對別人辱罵、惡意取笑、破壞或搶取東西、肢體攻擊、拒絕讓某個人加入討論或活動嗎？
(選項1：曾經有、選項2：不曾)

tabm as52a*
上七年級以來，你曾在實際生活中(非網上)遇到這樣的事情嗎？
(從未,偶爾,有時,經常 1,2,3,4)
用髒話罵或威脅某人
說某人的壞話
不讓某人加入活動、討論事情或不准別人跟某人說話、一起行動
嘲笑某人的外貌或言行舉止
嘲笑某人他喜歡某個人
故意破壞某人的東西或故意藏起來
勒索或強要某人的東西
對某人肢體攻擊

*未整理開放題 Q2_063
其他霸凌行為(請說明):________________________________
***************************************************************************/
* 是否實體霸凌他人
recode as52 (1 = 1 "曾有實體霸凌他人")(2 = 0 "不曾實體霸凌他人") ///
             (* = .), gen(br_a)
lab var br_a "曾有實體霸凌他人"

* 累積實體霸凌他人的頻率
foreach x of num 1/8 {
	clonevar br_fa_`x' = as52a`x'
	mvdecode br_fa_`x', mv(-999 -9 -8 -6)
	replace br_fa_`x' = br_fa_`x' - 1
}

foreach x of num 1/8 {
	replace br_fa_`x' = . if br_a == 0 | br_a == .
}

egen BR_FA = rowtotal(br_fa_1 - br_fa_8)
lab var BR_FA "累積實體霸凌他人頻率"

* 累積實體霸凌他人的類型
foreach x of num 1/8 {
	recode br_fa_`x' (0 = 0)(1/3 = 1), gen(br_ta_`x')
}

egen BR_TA = rowtotal(br_ta_1 - br_ta_8)
lab var BR_TA "累積實體霸凌他人類型"

/*
/***************************************************************************
（AB卷）
實體霸凌他人:
請問你曾對誰這麼做？(可複選)
□同班同學□同校不同班的同學□不同校的朋友□鄰居□其他(請說明)____
***************************************************************************/
* 創建複選
replace Q2_064 = "." if Q2_064 == "0"
/*
tab Q2_064
*/

foreach x of num 1/5{
	gen bra_who_`x' = ustrregexm(Q2_064, "`x',|`x'")
	replace bra_who_`x' = . if Q2_064 == "."
}

lab var bra_who_1 "實際霸凌誰:同班同學"
lab var bra_who_2 "實際霸凌誰:同校不同班的同學"
lab var bra_who_3 "實際霸凌誰:不同校的朋友"
lab var bra_who_4 "實際霸凌誰:鄰居"
lab var bra_who_5 "實際霸凌誰:其他"

*整理開放題
gen bra_who_5o = ustrregexs(0) if ustrregexm(Q2_064, "[\u4e00-\u9fa5]+")
replace bra_who_5o = "空白" if bra_who_5o == "" & bra_who_5 == 1
lab var bra_who_5o "實際霸凌誰:其他_詳細"

/*
brow Q2_064 Q2_064_1 - Q2_064_5n
*/
*/
/***************************************************************************
（AB卷）
as53
七年級以來，你曾在網路上，被其他人辱罵、惡意取笑、拒絕加入討論、散布丟臉的影片、發布不實的訊息嗎？
(選項1：曾經有、選項2：不曾)

as53a
上七年級以來，你曾在網上遇到這樣的事情嗎？
(從未,偶爾,有時,經常 1,2,3,4)
別人用髒話罵或威脅我
別人說我的壞話
不讓我加入討論
被嘲笑外貌、言行舉止
被嘲笑我喜歡某人
在網路散布使我丟臉的照片或影片
假冒我的社交帳號或是電子郵件，在網路上發布不實訊息

*未整理開放題 as53a8
其他霸凌行為(請說明):________________________________
***************************************************************************/
* 是否網路被霸凌
recode as53 (1 = 1 "曾有網路被霸凌")(2 = 0 "不曾網路被霸凌")(* = .), gen(bc_v)
lab var bc_v "曾有網路被霸凌"

* 累積網路被霸凌的頻率
foreach x of num 1/7 {
	clonevar bc_fv_`x' = as53a`x'
	mvdecode bc_fv_`x', mv(-999 -9 -8 -6)
	replace bc_fv_`x' = bc_fv_`x' - 1
}

foreach x of num 1/7 {
	replace bc_fv_`x' = . if bc_v == 0 | bc_v == .
}

egen BC_FV = rowtotal(bc_fv_1 - bc_fv_7)
lab var BC_FV "累積網路被霸凌頻率"

foreach x of num 1/7 {
	recode bc_fv_`x' (0/1 = 0)(2 = 1)(3 = 2)(* = .), gen(bc_fv1_`x')
}
egen BC_FV1 = rowtotal(bc_fv1_1 - bc_fv1_7)
lab var BC_FV1 "累積網路被霸凌頻率(3)"

* 累積網路被霸凌的類型
foreach x of num 1/7 {
	recode bc_fv_`x' (0 = 0)(1/3 = 1), gen(bc_tv_`x')
}

egen BC_TV = rowtotal(bc_tv_1 - bc_tv_7)
lab var BC_TV "累積網路被霸凌類型"

* 處理邏輯問題
/*
brow bc_v bc_fv_01- bc_fv_07 BC_FV if bc_v == 0 & BC_FV != 0
brow bc_v bc_fv_01- bc_fv_07 BC_FV Q2_065 if bc_v == 0 & Q2_065 != "."

brow bc_v bc_fv_01 - bc_fv_07 Q2_065 ///
     if (bc_v == 0 | bc_v == .) ///
	              & (bc_fv_01 != . | bc_fv_02 != . | bc_fv_03 != . ///
                   | bc_fv_04 != . | bc_fv_05 != . | bc_fv_06 != . ///
                   | bc_fv_07 != . )

keep if bc_v == 0 & (bc_fv_01 != . | bc_fv_02 != . | bc_fv_03 != . ///
                   | bc_fv_04 != . | bc_fv_05 != . | bc_fv_06 != . ///
                   | bc_fv_07 != . )
*/

replace BC_FV = . if bc_v == 0 | bc_v == .
replace BC_FV1 = . if bc_v == 0 | bc_v == .
replace BC_TV = . if bc_v == 0 | bc_v == .
/*
/***************************************************************************
（AB卷）
網路被霸凌
問是誰對你這麼做？(可複選) 
□同班同學□同校不同班的同學□不同校的朋友□鄰居□其他(請說明)____
***************************************************************************/
* 創建複選
replace Q2_068 = "." if Q2_068 == "0"
/*
tab Q2_068
*/

foreach x of num 1/5{
	gen bcv_who_`x' = ustrregexm(Q2_068, "`x',|`x'")
	replace bcv_who_`x' = . if Q2_068 == "."
}

lab var bcv_who_1 "被誰網路霸凌:同班同學"
lab var bcv_who_2 "被誰網路霸凌:同校不同班的同學"
lab var bcv_who_3 "被誰網路霸凌:不同校的朋友"
lab var bcv_who_4 "被誰網路霸凌:鄰居"
lab var bcv_who_5 "被誰網路霸凌:其他"

* 整理開放題
gen bcv_who_5o = ustrregexs(0) if ustrregexm(Q2_068, "[\u4e00-\u9fa5]+")
replace bcv_who_5o = "空白" if bcv_who_5o == "" & bcv_who_5 == 1
lab var bcv_who_5o "被誰網路霸凌:其他_詳細"

/*
brow Q2_068 Q2_068_1 - Q2_068_5n
*/

/***************************************************************************
網路被霸凌
那你實際上 如何反應(可複選)
□好好說明澄清 □要求當事人停止 □忽略這些人與事情
□投入其他有趣或有意義的事情 □因為太困擾，無法做好平日應該要做的事 
□回擊、跟當事人對抗 □告訴其他同學或朋友 □告訴家人 □告訴老師 
□不去會遇到那個人的場所 □改變郵件帳號、電話號碼或網路封鎖讓當事人無法聯繫到我
□其他(請說明)_______
****************************************************************************/
* 創建複選
replace Q2_069 = "." if Q2_069 == "0"
/*
tab Q2_069
*/

gen bcv_rea_1 = ustrregexm(Q2_069, "^(1,)|^(1)")
gen bcv_rea_1n = ustrregexm(Q2_069, "^(10)|^(11)|^(12)|^(13)|^(14)")
replace bcv_rea_1 = 0 if bcv_rea_1n == 1
replace bcv_rea_1 = . if Q2_069 == "."
drop bcv_rea_1n 

gen bcv_rea_2 = ustrregexm(Q2_069, "^(2)|^(1,2)")
replace bcv_rea_2 = . if Q2_069 == "."

foreach x of num 3/12{
	gen bcv_rea_`x' = ustrregexm(Q2_069, "`x',|`x'")
	replace bcv_rea_`x' = . if Q2_069 == "."
}

lab var bcv_rea_1 "被網路霸凌反應:好好說明澄清"
lab var bcv_rea_2 "被網路霸凌反應:要求當事人停止"
lab var bcv_rea_3 "被網路霸凌反應:忽略這些人與事情"
lab var bcv_rea_4 "被網路霸凌反應:投入其他有趣或有意義的事情"
lab var bcv_rea_5 "被網路霸凌反應:因為太困擾，無法做好平日應該要做的事 "
lab var bcv_rea_6 "被網路霸凌反應:回擊、跟當事人對抗"
lab var bcv_rea_7 "被網路霸凌反應:告訴其他同學或朋友"
lab var bcv_rea_8 "被網路霸凌反應:告訴家人"
lab var bcv_rea_9 "被網路霸凌反應:告訴老師"
lab var bcv_rea_10 "被網路霸凌反應:不去會遇到那個人的場所"
lab var bcv_rea_11 "被網路霸凌反應:改變郵件帳號、電話號碼或網路封鎖讓對方找不倒我"
lab var bcv_rea_12 "被網路霸凌反應:其他"

* 整理開放題
gen bcv_rea_12o = ustrregexs(0) if ustrregexm(Q2_069, "[\u4e00-\u9fa5]+")
replace bcv_rea_12o = "空白" if bcv_rea_12o == "" & bcv_rea_12 == 1
lab var bcv_rea_12o "被網路霸凌反應:其他_詳細"

/*
brow Q2_069 Q2_069_1 - Q2_069_12n
*/
*/
/***************************************************************************
（AB卷）
as54
上七年級以來，你曾在網路上，對別人辱罵、惡意取笑、拒絕加入討論、散布丟臉的影片、發布不實訊息等事情嗎？
(選項1：曾經有、選項2：不曾)

as54a
上七年級以來，你曾網上遇到這樣的事情嗎？
(從未,偶爾,有時,經常 1,2,3,4)
用髒話罵或威脅某人
說某人的壞話
不讓某人加入討論
嘲笑某人的外貌、言行舉止
嘲笑某人喜歡某個人
在網路散布使某人丟臉的照片或影片
用某人的社交帳號或是電子郵件，發布不實的訊息給其他人

*未整理開放題 Q2_072
其他霸凌行為(請說明):________________________________
***************************************************************************/
* 是否網路霸凌他人
recode as54 (1 = 1 "曾有網路霸凌他人")(2 = 0 "不曾網路霸凌他人") ///
             (* = .), gen(bc_a)
lab var bc_a "曾有網路霸凌他人"

* 累積網路霸凌他人的頻率
foreach x of num 1/7 {
	clonevar bc_fa_`x' = as54a`x'
	mvdecode bc_fa_`x', mv(-999 -9 -8 -6)
	replace bc_fa_`x' = bc_fa_`x' - 1
}

foreach x of num 1/7 {
	replace bc_fa_`x' = . if bc_a == 0 | bc_a == .
}

egen BC_FA = rowtotal(bc_fa_1 - bc_fa_7)
lab var BC_FA "累積網路霸凌他人頻率"

* 累積網路霸凌他人的類型
foreach x of num 1/7 {
	recode bc_fa_`x' (0 = 0)(1/3 = 1), gen(bc_ta_`x')
}

egen BC_TA = rowtotal(bc_ta_1 - bc_ta_7)
lab var BC_TA "累積網路霸凌他人類型"

/*
/***************************************************************************
（AB卷）
網路霸凌他人
請問你曾對誰這麼做？(可複選)
□同班同學□同校不同班的同學□不同校的朋友□鄰居□其他(請說明)____
***************************************************************************/
* 創建複選
replace Q2_073 = "." if Q2_073 == "0"
/*
tab Q2_073
*/

foreach x of num 1/5{
	gen bca_who_`x' = ustrregexm(Q2_073, "`x',|`x'")
	replace bca_who_`x' = . if Q2_073 == "."
}

lab var bca_who_1 "網路霸凌誰:同班同學"
lab var bca_who_2 "網路霸凌誰:同校不同班的同學"
lab var bca_who_3 "網路霸凌誰:不同校的朋友"
lab var bca_who_4 "網路霸凌誰:鄰居"
lab var bca_who_5 "網路霸凌誰:其他"

* 整理開放題
gen bca_who_5o = ustrregexs(0) if ustrregexm(Q2_073, "[\u4e00-\u9fa5]+")
replace bca_who_5o = "空白" if bca_who_5o == "" & bca_who_5 == 1
lab var bca_who_5o "網路霸凌誰:其他_詳細"

/*
brow Q2_073 Q2_073_1 - Q2_073_5n
*/
*/
/***************************************************************************
（AB卷）

霸凌類別整理

A1過去只有被實體霸凌(任何一種都可以)，只有被網路霸凌，以及兩種都有的
A2只有實體霸凌別人(任何一種都可以)，只有網路霸凌別人，以及實體網路都有霸凌別人的
A3.過去有同時被霸凌或霸凌別人者
(網路與實體的變化請納入考量)             
***************************************************************************/
/*
tab1 br_v bc_v br_a bc_a,m
*/


* 實體霸凌
gen br_4 = .
replace br_4 = 1 if br_v == 1 & br_a != 1
replace br_4 = 2 if br_v != 1 & br_a == 1
replace br_4 = 3 if br_v == 1 & br_a == 1
replace br_4 = 4 if br_v != 1 & br_a != 1
replace br_4 = . if br_v == . & br_a == .
lab def br_4 1 "只有被實體霸凌" 2 "只有實體霸凌他人" ///
                   3 "兩種實體霸凌都有" 4 "兩種實體霸凌沒都有"
lab val br_4 br_4
lab var br_4 "實體霸凌四類"
/*
tab1 br_v  br_4, m
*/

* 網路霸凌
gen bc_4 = .
replace bc_4 = 1 if bc_v == 1 & bc_a != 1
replace bc_4 = 2 if bc_v != 1 & bc_a == 1
replace bc_4 = 3 if bc_v == 1 & bc_a == 1
replace bc_4 = 4 if bc_v != 1 & bc_a != 1
replace bc_4 = . if bc_v == . & bc_a == .
lab def bc_4 1 "只有被網路霸凌" 2 "只有網路霸凌他人" ///
                   3 "兩種網路霸凌都有" 4 "兩種網路霸凌沒都有"
lab val bc_4 bc_4
lab var bc_4 "網路霸凌四類"
/*
tab1 bc_v  bc_a bc_4, m
*/
tab br_4 bc_4 , cell


egen b_rc16 = count(1), by(br_4 bc_4)

recode b_rc16 (1143 = 1 "只被實體霸凌")(170 = 2 "只有被網路霸凌") ///
			  (224 = 3 "只有被網路與實體霸凌")(* = .), gen(b_rc3)

* 被霸凌經驗
gen b_v = .
replace b_v = 1 if br_v == 1 & bc_v != 1
replace b_v = 2 if br_v != 1 & bc_v == 1
replace b_v = 3 if br_v == 1 & bc_v == 1
replace b_v = 4 if br_v != 1 & bc_v != 1
replace b_v = . if br_v == . & bc_v == .
lab def b_v 1 "只有被實體霸凌" 2 "只有被網路霸凌" ///
                   3 "兩種都有" 4 "兩種沒都有"
lab val b_v b_v
lab var b_v "被霸凌經驗"

* 霸凌別人經驗
gen b_a = .
replace b_a = 1 if br_a == 1 & bc_a != 1
replace b_a = 2 if br_a != 1 & bc_a == 1
replace b_a = 3 if br_a == 1 & bc_a == 1
replace b_a = 4 if br_a != 1 & bc_a != 1
replace b_a = . if br_a == . & bc_a == .
lab def b_a 1 "只有實體霸凌別人" 2 "只有網路霸凌別人" ///
                   3 "兩種都有" 4 "兩種沒都有"
lab val b_a b_a
lab var b_a "霸凌別人經驗"

* 結合 
tab b_v b_a , cell

egen b_va = count(1), by(b_v b_a)

/*
/***************************************************************************
（A卷）
24. 請問你使用網路搜尋過哪些健康議題？（可複選）
□(1)皮膚健康  □(2)身材體態  □(3) 營養 □(4)性教育 □(5)憂鬱  □(6)焦慮  
□(7)壓力調適  □(8)其他(請說明)_______   □(9)都沒有      

這題很奇怪 選項邏輯設計錯誤
"選項1：皮膚健康、選項2：身材體態、選項3：營養、選項4：性教育、
選項5：憂鬱、選項6：焦慮、選項7：壓力調適、選項8：都沒有、選項9：其他 (請說明)"    
***************************************************************************/
* 創建複選


foreach x of num 1/9{
	clonevar ihealth_`x' = as36_`x'
}


foreach x of num 1/8 {
	replace ihealth_`x' = 0 if ihealth_9 == 1
}

egen ihealth = rowtotal(ihealth_1 - ihealth_9),m
lab var ihealth "網路搜查健康議題(個數)"
*/
