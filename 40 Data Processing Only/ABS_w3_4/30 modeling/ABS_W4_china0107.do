* Last Updated: 2022 . 01 07
* File name: [ABSW3_4_modeling]
* Data: ABS_W4_220106
* Subject: O&mlogistic

/***************************************************
*                ABS_W4_220106                   *
***************************************************/


cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\"
*/
use ABSW3_4_data/ABS_W4_220106.dta,clear


recode  protectworkern(.=2.5),gen(protectworkern1)
lab var protectworkern1 "Protecting Farmers and Workers(missing=2.5)"

recode protectworkern(1/2=1 "da")(3/4=2 "a")(.=3 "miss"),gen(protectworkern2)
lab var protectworkern2 "Protecting Farmers and Workers(3)"


/***************************************************
*                Ologistic                   *
***************************************************/


log using "ABSW3_4_output/220107china .txt" , text replace 


*******China**********
ologit protectworkern1 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu employed ///
	   urban globalexposure if country == 4 ,nolog or 

mlogit protectworkern2 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu employed ///
	   urban globalexposure if country == 4 ,b(1) nolog rrr

log close	   