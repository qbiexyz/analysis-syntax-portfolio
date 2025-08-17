* Last Updated: 2022 . 01 14
* File name: [ABSW3_4_modeling]
* Data: ABS3
* Subject: Data append 

/***************************************************
            ABS3220113 +ABS4220113                   *
***************************************************/


cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\"
*/
use ABSW3_4_data/ABS_W3_220114.dta,clear



append using ABSW3_4_data/ABS_W4_220114.dta


save ABSW3_4_data/ABS34append.dta
