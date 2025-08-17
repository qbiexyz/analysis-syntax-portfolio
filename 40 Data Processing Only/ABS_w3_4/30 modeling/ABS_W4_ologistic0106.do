* Last Updated: 2022 . 01 06
* File name: [ABSW3_4_modeling]
* Data: ABS_W4_220106
* Subject: Ologistic

/***************************************************
*                ABS_W4_220106                   *
***************************************************/


cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\"
*/
use ABSW3_4_data/ABS_W4_220106.dta,clear





recode  protectworker (1=4)(2=3)(3=2)(4=1),gen(protectworkern)


/***************************************************
*                Ologistic                   *
***************************************************/


log using "ABSW3_4_output/220106ologistic_1 .txt" , text replace 


*******China**********
ologit protectworkern collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu employed ///
	   urban globalexposure if country == 4 ,nolog or 

*******Vietnam**********	   
ologit protectworkern collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment ///
	   urban globalexposure if country == 11 ,nolog or 

	   
*******Cambodia**********	   
ologit protectworkern collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment ///
	   urban globalexposure if country == 12 ,nolog or 

	   
*******Thailand**********	   
ologit protectworkern collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment ///
	   urban globalexposure if country == 8 ,nolog or 
log close	   