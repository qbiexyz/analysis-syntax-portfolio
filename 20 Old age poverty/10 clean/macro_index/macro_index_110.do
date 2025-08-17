* Last Updated: 2023. 04. 11
* File name: [Old age poverty]
* Data: 家庭收支調查
* Subject: append macro_index 110

/*****************************
*                  *
*****************************/

cd "D:\Dropbox\工作\翠莪老師_work\Old age poverty"

*******************************************************************************
use "10 data\macro_index\old\macro_index.dta",clear
set more off

/*******************************************************************************
*******************************************************************************/
/*新增一個空的觀察值*/
set obs 41
replace year = 110 in 41

/*新增110年各種指標*/
replace year2 = 2021 if year == 110
replace wave = 41 if year == 110
replace cpi = 104.32 if year == 110

replace yoy = 3.39 if year == 109 /*109年後來應該有修正*/
replace yoy = 6.53 if year == 110

replace unemp = 3.95 if year == 110

replace gni = if year == 110
replace gdpnt = if year == 110

replace gdp_totalsocexp_ = 11.1 if year == 110

replace gdp_totalsocexpnoadmin_ = if year == 110
replace yeagdp_elder_r2 = if year == 110
replace gdp_elder_ = if year == 110
replace gdp_family_ = if year == 110
replace gdp_unemp_ = if year == 110

save "10 data\macro_index\macro_index_11070.dta" ,replace
