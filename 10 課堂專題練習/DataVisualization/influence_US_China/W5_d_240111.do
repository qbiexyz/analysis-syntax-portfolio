* Last Updated: 2023. 07. 10
* File name: [ABSW5]
* Data: 亞洲民主動態調查
* Subject: 

/*****************************
*                  *
*****************************/
*設定工作路徑
cd "C:\Dropbox\DataVisualization\112-2-econDV-practice\30 practice\influence_US_China"

*******************************************************************************
est clear
use "Release_v1_20230417_W5_merge_15.dta",clear

/*****************************************************************************
ABSW5
*****************************************************************************/
/***************************************************
*                  國家變項                        *
***************************************************/
/*
1. Japan
2. Hong Kong
3. Korea
4. China
5. Mongolia
6. Philippines
7. Taiwan
8. Thailand
9. Indonesia	
10. Singapore	
11. Vietnam	
13. Malaysia	
14. Myanmar	
15. Australia	
18. India	
*/
lab def COUNTRY 2 "Hong_Kong", modify /* 將標籤 Hong Kong 修改成Hong_Kong */
decode country,gen(countryN) /* 將數字以標籤轉成轉成文字 */
replace countryN = "Hong Kong" if countryN == "Hong_Kong"

numlabel COUNTRY, add 
drop if country == 4

* 美國 中國對世界影響力
tab1 q176 q178
mvdecode q176 q178, mv(-1 97/99)

bysort country : egen infall_US = mean(q176)
bysort country : egen infall_CH = mean(q178)
gen infall_USCH = infall_US - infall_CH

*美國 中國對該國影響力
tab1 q182 q184
mvdecode q182 q184, mv(-1 7/9)

bysort country : egen infme_US = mean(q182)
bysort country : egen infme_CH = mean(q184)
gen infme_USCH = infme_US - infme_CH

collapse (median) infall_USCH infme_USCH ///
                  infall_US infall_CH infme_US infme_CH country, by(countryN)
		  
*GDPg
gen gdpg = .
replace gdpg = 0.638851191  if country == 1
replace gdpg = -0.591835646 if country == 2
replace gdpg = 2.770339125  if country == 3
replace gdpg = 6.54915846   if country == 4
replace gdpg = 4.957180498  if country == 5
replace gdpg = 6.807310216  if country == 6
replace gdpg = 2.756666667  if country == 7
replace gdpg = 3.505036372  if country == 8
replace gdpg = 5.087788374  if country == 9
replace gdpg = 0.335213545  if country == 10
replace gdpg = 7.031729418  if country == 11
replace gdpg = 5.022998936  if country == 13
replace gdpg = 6.301833991  if country == 14
replace gdpg = 2.631925586  if country == 15
replace gdpg = 5.706890568  if country == 18
lab var gdpg "經濟成長指數"

*GNI
gen gni = .
replace gni = 37329.79527 if country == 1
replace gni = 46351.40261 if country == 2
replace gni = 31228.29347 if country == 3
replace gni = 10127.44246 if country == 4
replace gni = 3844.902841 if country == 5
replace gni = 3801.581391 if country == 6
replace gni = 26421       if country == 7
replace gni = 6765        if country == 8
replace gni = 3773.35723  if country == 9
replace gni = 55010       if country == 10
replace gni = 2925.731152 if country == 11
replace gni = 10943.94843 if country == 13
replace gni = 1531.239935 if country == 14
replace gni = 57283.33871 if country == 15
replace gni = 1925.87073  if country == 18
lab var gni "人均國民所得"


sort infme_USCH

egen country2 = rank(infme_USCH), t

compress
save "ABSW5_infall_USCH.dta", replace



