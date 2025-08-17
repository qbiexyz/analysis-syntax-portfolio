* Last Updated: 2023. 09. 21
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/

/*****************************************************************************
* 一次建立多個資料夾                      
*****************************************************************************/
/*
foreach x of num 70/110 {
	efolder `x', cd("D:\Dropbox\工作\翠莪老師_work\Old age poverty\10 data\use data")
}
*/
est clear

//原始資料位置
global original_filedir "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\10 data\家庭收支調查\"

//處理後資料位置
global output_filedir "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\10 data\use data\"

//處理使用的語法位置
global do_filedir "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\20 model\10 clean\10 new"

******************************************************************************

/*****************************************************************************
                      
*****************************************************************************/
foreach x of numlist 107/110 {

clear
use "${original_filedir}\`x'\inc`x'.dta",clear
cd "${output_filedir}\`x'"

set more off

do "${do_filedir}\dofor107-110_230904.do" 
compress
save "`x'_230921.dta",replace

}

foreach x of numlist 90/106 {

clear
use "${original_filedir}\`x'\inc`x'.dta",clear
cd "${output_filedir}\`x'"

set more off

do "${do_filedir}\dofor90-106_230904.do" 
compress
save "`x'_230921.dta",replace

}

foreach x of numlist 88/89 {

clear
use "${original_filedir}\`x'\inc`x'.dta",clear
cd "${output_filedir}\`x'"

set more off

do "${do_filedir}\dofor88-89_230904.do" 
compress
save "`x'_230921.dta",replace

}

foreach x of numlist 85/87 {

clear
use "${original_filedir}\`x'\inc`x'.dta",clear
cd "${output_filedir}\`x'"

set more off

do "${do_filedir}\dofor85-87_230904.do" 
compress
save "`x'_230921.dta",replace

}

foreach x of numlist 70 80 83 84{

clear
use "${original_filedir}\`x'\inc`x'.dta",clear
cd "${output_filedir}\`x'"

set more off

do "${do_filedir}\dofor`x'_230904.do" 
compress
save "`x'_230921.dta",replace

}

foreach x of numlist 81/82 {

clear
use "${original_filedir}\`x'\inc`x'.dta",clear
cd "${output_filedir}\`x'"

set more off

do "${do_filedir}\dofor81-82_230904.do" 
compress
save "`x'_230921.dta",replace

}

foreach x of numlist 77/79 {

clear
use "${original_filedir}\`x'\inc`x'.dta",clear
cd "${output_filedir}\`x'"

set more off

do "${do_filedir}\dofor77-79_230904.do" 
compress
save "`x'_230921.dta",replace

}

foreach x of numlist 71/76 {

clear
use "${original_filedir}\`x'\inc`x'.dta",clear
cd "${output_filedir}\`x'"

set more off

do "${do_filedir}\dofor71-76_230904.do" 
compress
save "`x'_230921.dta",replace

}


///合併
*整合路徑設定

clear
cd "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\10 data\use data"

use 110\110_230710.dta

foreach x of numlist 107/109 70/106 {
append using "`x'/`x'_230921.dta"
}
save "y70110_230921.dta" ,replace


/*****************************************************************************
                      合併國家指標
*****************************************************************************/
clear
cd "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\10 data"

import delimited "macro_index\macro_index_230711.csv", clear

sort year

gen gni_cpi = (gni/cpi)*100
gen lgni_cpi = log(gni_cpi)
lab var lgni_cpi "GNI(通膨調整、log)"

gen gdpnt_cpi = (gdpnt/cpi)*100
gen lgdpnt_cpi = log(gdpnt_cpi)
lab var lgdpnt_cpi "GDP(通膨調整、log)"

gen elder_socexp_ = gdp_elder/gdp_total_socexp
gen elder_socexpnoadmin_ = gdp_elder/gdp_totalsocexpnoadmin

keep year2 year year2 cpi yoy gni gni_cpi lgni_cpi gdpnt gdpnt_cpi lgdpnt_cpi gdp_totalsocexp_ gdp_totalsocexpnoadmin_ gdp_elder_ elder_socexp_ elder_socexpnoadmin_

order year2 year year2 cpi yoy gni gni_cpi lgni_cpi gdpnt gdpnt_cpi lgdpnt_cpi gdp_totalsocexp_ gdp_totalsocexpnoadmin_ gdp_elder_ elder_socexp_ elder_socexpnoadmin_
save "macro_index\macro_index_230711.dta", replace


use "use data\y70110_230921.dta", clear

sort year

merge m:1 year using "macro_index\macro_index_230711.dta"

drop _merge

order newid - year year2 HH ///
      cpi - elder_socexpnoadmin_ ///
	  salary - income missing1 
	  
* 改標籤

lab drop headrelation
lab def headrelation 0 "本人/配偶" 1 "子女" 2 "父母輩" 3 "其他"
lab val headrelation headrelation

drop missing1

save "y70110_230921.dta", replace


foreach x of num 70/110{
	use "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\10 data\use data\\`x'\\`x'_230921",clear
	tab year
	numlabel headrelation,add
	tab headrelation
}
