* Last Updated: 2023. 04 .29
* File name: []
* Data:ABSW5  
* Subject: data clean

/***************************************************
*                      ABSW5                      *
***************************************************/

cd "C:\Dropbox\工作\中研院_工作\! done\ABSW5 Attitudes toward China\"


import excel "10 data\macro\指標_230426.xlsx", ///
       sheet("工作表1") cellrange(A1:F16) firstrow clear
	   
merge 1:m country using "10 data\Release_v1_20230417_W5_merge_15.dta"

sort country

drop _merge


merge m:1 IDnumber using "10 data\Australia_Q153.dta"

replace q158 = q158_aus if country == 15
drop _merge q158_aus
