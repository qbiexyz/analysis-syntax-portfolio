* Last Updated: 2024. 03. 13
* File name: []
* Data: 學生AB總檔_0131LABEL
* Subject: 


/*****************************
*                            *
*****************************/
/*
cd "C:\Dropbox\工作\杏容老師_work\TIGPS2023"

***************************************************************************
est clear

use "10 data\學生AB總檔_0325LABEL.dta" ,clear
do "20 model\10 clean\學生AB總檔\學生AB總檔_01 霸凌變項_240329.do"
do "20 model\10 clean\學生AB總檔\學生AB總檔_01.2 被誰霸凌_240719.do"
do "20 model\10 clean\學生AB總檔\學生AB總檔_02 其他變項_240329.do"
*/


keep ///
	student_id - seat_n ///
	b_help_a - b_va brv_who_1 - bcv_who_5n bcv_who_num ///
	cesd_a - cohabit
	

order ///
	student_id - seat_n ///
	b_help_a - b_va brv_who_1 - bcv_who_5n bcv_who_num ///
	cesd_a - cohabit