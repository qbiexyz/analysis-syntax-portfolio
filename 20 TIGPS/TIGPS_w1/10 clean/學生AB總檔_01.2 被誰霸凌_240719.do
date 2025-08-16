* Last Updated: 2024. 03. 29
* File name: []
* Data: 學生AB總檔_0131LABEL
* Subject: 


/*****************************
*                            *
*****************************/
/*
cd "C:\Dropbox\工作\杏容老師_work\TIGPS2023"

**************************************************************************
est clear

use "10 data\學生AB總檔_0325LABEL.dta" ,clear
do "20 model\10 clean\學生AB總檔\學生AB總檔_01 霸凌變項_240329.do"
*/

/*****************************
*   霸凌相關題目(按順序)     *
*****************************/

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
	replace brv_who_`x' = 0 if brv_who_`x' == . & br_v == 1
}

*整理開放題 aks51b5
replace brv_who_1 = 1 if aks51b5 == "1號"
replace brv_who_3 = 1 if aks51b5 == "不同校同學"
replace brv_who_1 = 1 if aks51b5 == "以前同學"
replace brv_who_1 = 1 if aks51b5 == "以前國中的同學"
replace brv_who_1 = 1 if aks51b5 == "以前學校的同班同學"
replace brv_who_1 = 1 if aks51b5 == "以前班上的同學"
replace brv_who_3 = 1 if aks51b5 == "以前補習班同學"
replace brv_who_1 = 1 if aks51b5 == "同學"
replace brv_who_2 = 1 if aks51b5 == "國小"
replace brv_who_2 = 1 if aks51b5 == "國小不同班"
replace brv_who_1 = 1 if aks51b5 == "國小同學"
replace brv_who_2 = 1 if aks51b5 == "學姊"
replace brv_who_2 = 1 if aks51b5 == "學長"
replace brv_who_3 = 1 if aks51b5 == "安親班同學"
replace brv_who_3 = 1 if aks51b5 == "室友"
replace brv_who_1 = 1 if aks51b5 == "小學同班同學"
replace brv_who_1 = 1 if aks51b5 == "曾經是同班同學"
replace brv_who_3 = 1 if aks51b5 == "曾經的朋友"
replace brv_who_3 = 1 if aks51b5 == "朋友"
replace brv_who_3 = 1 if aks51b5 == "校外朋友"
replace brv_who_2 = 1 if aks51b5 == "校隊"
replace brv_who_2 = 1 if aks51b5 == "社會人國3生"
replace brv_who_3 = 1 if aks51b5 == "補習班同學"
replace brv_who_1 = 1 if aks51b5 == "轉學前的同班同學"

replace brv_who_5 = 0 if ///
	aks51b5 == "1號" | aks51b5 == "不同校同學" | aks51b5 == "以前同學" ///
  | aks51b5 == "以前國中的同學" | aks51b5 == "以前學校的同班同學" ///
  | aks51b5 == "以前班上的同學" | aks51b5 == "以前補習班同學" ///
  | aks51b5 == "同學" | aks51b5 == "國小" | aks51b5 == "國小不同班" ///
  | aks51b5 == "國小同學" | aks51b5 == "學姊" | aks51b5 == "學長" ///
  | aks51b5 == "安親班同學" | aks51b5 == "室友" ///
  | aks51b5 == "小學同班同學" | aks51b5 == "曾經是同班同學" /// 
  | aks51b5 == "曾經的朋友" | aks51b5 == "朋友" | aks51b5 == "校外朋友" /// 
  | aks51b5 == "校隊" | aks51b5 == "社會人國3生" ///
  | aks51b5 == "補習班同學" | aks51b5 == "轉學前的同班同學" 

gen brv_who_5n = brv_who_4 + brv_who_5
replace brv_who_5n = 1 if brv_who_5n == 2
lab var brv_who_5n "現實霸凌受害_對象_鄰居&其他"

egen brv_who_num = rowtotal(brv_who_1 brv_who_2 brv_who_3  brv_who_5n)
lab var brv_who_num "現實霸凌受害_對象_個數"
replace brv_who_num = . if br_v == 0 | br_v == .

/***************************************************************************
（AB卷）
網路被霸凌
問是誰對你這麼做？(可複選) 
□同班同學□同校不同班的同學□不同校的朋友□鄰居□其他(請說明)____
***************************************************************************/
foreach x of num 1/5{
	clonevar bcv_who_`x' = as53b`x'
	mvdecode bcv_who_`x', mv(-999 -9 -8 -6)
	replace bcv_who_`x' = 0 if bcv_who_`x' == . & bc_v == 1
}

* 整理開放題 aks53b5

replace bcv_who_3 = 1 if aks53b5 == "不同校的人"
replace bcv_who_1 = 1 if aks53b5 == "不同校的以前同學"
replace bcv_who_1 = 1 if aks53b5 == "以前同學"
replace bcv_who_1 = 1 if aks53b5 == "以前的同班同學"
replace bcv_who_3 = 1 if aks53b5 == "其他學校的，現在不是"
replace bcv_who_2 = 1 if aks53b5 == "其他班的朋友和學長"
replace bcv_who_2 = 1 if aks53b5 == "同校的學姊"
replace bcv_who_1 = 1 if aks53b5 == "國小同學"
replace bcv_who_2 = 1 if aks53b5 == "國小學妹"
replace bcv_who_2 = 1 if aks53b5 == "學姊"
replace bcv_who_1 = 1 if aks53b5 == "已轉學"
replace bcv_who_3 = 1 if aks53b5 == "朋友"

replace bcv_who_5 = 0 if ///
	aks53b5 == "不同校的人" | aks53b5 == "不同校的以前同學" ///
  | aks53b5 == "以前同學" | aks53b5 == "以前的同班同學" ///
  | aks53b5 == "其他學校的，現在不是" | aks53b5 == "其他班的朋友和學長" ///
  | aks53b5 == "同校的學姊" | aks53b5 == "國小同學" ///
  | aks53b5 == "國小學妹" | aks53b5 == "學姊" | aks53b5 == "已轉學" ///
  | aks53b5 == "朋友"
  
gen bcv_who_5n = bcv_who_4 + bcv_who_5
replace bcv_who_5n = 1 if bcv_who_5n == 2
lab var bcv_who_5n "網路霸凌受害_對象_鄰居&其他"

egen bcv_who_num = rowtotal(bcv_who_1 bcv_who_2 bcv_who_3  bcv_who_5n)
lab var bcv_who_num "網路霸凌受害_對象_個數"

replace bcv_who_num = . if bc_v == 0 | bc_v == .