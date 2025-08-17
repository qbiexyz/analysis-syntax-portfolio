* Last Updated: 2022 . 01 06
* File name: [ABSW3_4_modeling]
* Data: ABS_W4_220106
* Subject: tab & sum

/***************************************************
*                ABS_W4_220106                   *
***************************************************/

cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\"
*/
use ABSW3_4_data/ABS_W4_220106.dta,clear


log using "ABSW3_4_output/220106output .txt" , text replace 

by country :tab1 protectworker finc4n male employed employment urban,m
by country :sum age edu globalexposure ecocountry ecofamily  ///
				collectivismq56 collectivismq57 trustg truste

log close



log using "ABSW3_4_output/220106missing .txt" , text replace 
by country :tab1 protectworker collectivism trustg truste finc4n ///
				 ecofamily ecocountry ,m
				 
log close