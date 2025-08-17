* Last Updated: 2024. 08. 30
* File name: []
* Data: tigps_w2
* Subject: 


/*****************************
*                            *
*****************************/
/*
cd "C:\Dropbox\工作\杏容老師_work\TIGPS_w2"

**************************************************************************
est clear

use "10 data\tigps_w2.dta", clear

do "20 model\10 clean\20 國八期中報告分析計畫\01 霸凌變項_240830.do"
do "20 model\10 clean\20 國八期中報告分析計畫\02 其他變項_240830.do"

*/


keep ///
	student_oid - class ///
	br_v - b_va ///
	hardiness_1 - fclass
	

order ///
	student_oid - class ///
	br_v - b_va ///
	hardiness_1 - fclass
	
compress