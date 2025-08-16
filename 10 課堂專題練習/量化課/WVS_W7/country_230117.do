* Last Updated: 2023. 01 .17
* File name: WVS_W7_modeling
* Data:  
* Subject:  clean country

/***************************************************
                  clean country
***************************************************/
*設定工作路徑
cd "D:\Dropbox\qbiexyz\學習\碩士\WVS_W7"

***************************************************
use "WVS_W7_data\WVS_Cross-National_Wave_7_Stata_v5_0.dta",clear

*** Iraq  Libya  Netherlands  New Zealand Egypt  Great Britain Northern Ireland 

duplicates drop B_COUNTRY,force

sort B_COUNTRY

keep B_COUNTRY B_COUNTRY_ALPHA A_YEAR
clonevar countrycode = B_COUNTRY
lab val countrycode .

order B_COUNTRY B_COUNTRY_ALPHA countrycode A_YEAR

sort B_COUNTRY_ALPHA

save "WVS_W7_data\country\country.dta"


***************************************************
import excel "D:\Dropbox\qbiexyz\學習\碩士\WVS_W7\WVS_W7_雜\API_NY.GDP.MKTP.KD.ZG_DS2_en_excel_v2_4770547.xls", sheet("Data") firstrow clear

save "WVS_W7_data\country\gdpg.dta"

***************************************************

use "WVS_W7_data\country\country.dta",clear

***gdpg
merge 1:1 B_COUNTRY_ALPHA using "WVS_W7_data\country\gdpg.dta"

drop if _merge == 2
		
egen gdpg17 = rmean(Y2017 Y2016 Y2015) if A_YEAR == 2017
egen gdpg18 = rmean(Y2018 Y2017 Y2016) if A_YEAR == 2018
egen gdpg19 = rmean(Y2019 Y2018 Y2017) if A_YEAR == 2019
egen gdpg20 = rmean(Y2020 Y2019 Y2018) if A_YEAR == 2020
egen gdpg21 = rmean(Y2021 Y2020 Y2019) if A_YEAR == 2021 | A_YEAR == 2022

gen gdpg = .
replace gdpg = gdpg17 if A_YEAR == 2017 & gdpg17 != .
replace gdpg = gdpg18 if A_YEAR == 2018 & gdpg18 != .
replace gdpg = gdpg19 if A_YEAR == 2019 & gdpg19 != .
replace gdpg = gdpg20 if A_YEAR == 2020 & gdpg20 != .
replace gdpg = gdpg21 if A_YEAR == 2021 & gdpg21 != .
replace gdpg = gdpg21 if A_YEAR == 2022 & gdpg21 != .
replace gdpg = (3.12 + 1.89 + 2.27)/3 if B_COUNTRY == 158

drop Y2014 - gdpg21 
drop  B_COUNTRY_ALPHA A_YEAR
sort B_COUNTRY
drop if B_COUNTRY == 862 | B_COUNTRY == 909


save "WVS_W7_data\country\country index.dta"

***************************************************
***pweight
import excel "D:\Dropbox\qbiexyz\學習\碩士\WVS_W7\WVS_W7_output\pweight.xlsx", sheet("工作表1") firstrow clear
sort countrycode

save"WVS_W7_data\country\pweight.dta"

***************************************************
***弄各國指標

use "WVS_W7_data\WVSW7_clean_230117.dta",clear

duplicates drop countrycode,force

keep B_COUNTRY B_COUNTRY_ALPHA countrycode A_YEAR  hdi gdpg v2xeg_eqdr

export excel B_COUNTRY B_COUNTRY_ALPHA countrycode A_YEAR hdi gdpg v2xeg_eqdr using "D:\Dropbox\qbiexyz\學習\碩士\WVS_W7\WVS_W7_output\country56.xlsx", firstrow(variables)

***************************************************
***弄各國依變項 平均數標準差

use "WVS_W7_data\WVSW7_clean_230117.dta",clear

collapse  (mean) inc_eq workhard compare_live sacsecval resemaval ///
                 dem_import dem_country trust male age married children ///
				 ,by(countrycode)
export excel countrycode inc_eq workhard compare_live sacsecval resemaval ///
                 dem_import dem_country trust male age married children ///
				 using "D:\Dropbox\qbiexyz\學習\碩士\WVS_W7\WVS_W7_output\countrymean.xlsx", firstrow(variables)
				 
use "WVS_W7_data\WVSW7_clean_230102.dta",clear

collapse  (sd) inc_eq workhard  sacsecval resemaval ///
                 dem_import dem_country age ///
				 ,by(countrycode)
export excel countrycode inc_eq workhard  sacsecval resemaval ///
                 dem_import dem_country age ///
				 using "D:\Dropbox\qbiexyz\學習\碩士\WVS_W7\WVS_W7_output\countrysd.xlsx", firstrow(variables)				 
			
		 
***************************************************
***弄各國分類
use "WVS_W7_data\WVSW7_clean_230117.dta",clear


tab nohope,gen(nohope)
recode nohope1 nohope2 nohope3 nohope4 (0 = .)

keep countrycode nohope1 - nohope4

collapse  (sum) nohope1 - nohope4 ,by(countrycode)

export excel countrycode  nohope1 - nohope4   using "D:\Dropbox\qbiexyz\學習\碩士\WVS_W7\WVS_W7_output\country==.xlsx", firstrow(variables)

tab cha_soc,gen(cha_soc)
recode cha_soc1 cha_soc2 cha_soc3(0 = .)
