* Last Updated: 2023. 12. 27
* File name: [ABSW5]
* Data: 亞洲民主動態調查
* Subject: 

/*****************************
*                  *
*****************************/
*設定工作路徑

******************************************************************************
do "C:\Dropbox\工作\中研院_工作\Tolerance of Inequality_ABS4_5\20 model\10 clean\W4_d_231227.do"

do "C:\Dropbox\工作\中研院_工作\Tolerance of Inequality_ABS4_5\20 model\10 clean\W5_d_231227.do"

******************************************************************************
cd "C:\Dropbox\工作\中研院_工作\Tolerance of Inequality_ABS4_5"


est clear
use "10 data\ABSW4_inq_231227.dta",clear

/***************************************************
*                      ABSW5                      *
***************************************************/

append using "10 data\ABSW5_inq_231227.dta"


drop if country == 15 | country == 18 | country == 12


save "10 data\ABSW45_inq_231227", replace
