* Last Updated: 2022 . 01 14
* File name: [ABSW3_4_modeling]
* Data: ABS34append
* Subject: append_ologistic

/***************************************************
                    ABS34append               *
***************************************************/


cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\"
*/
use ABSW3_4_data/ABS34append.dta,clear

 


log using "ABSW3_4_output/220113ologistic_append .txt" , text replace 



*******China**********
ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment_C  ///
	   urban globalexposure if country == 4 ,nolog or 

*******Vietnam**********	   
ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment ///
	   urban globalexposure if country == 11 ,nolog or 

	   
*******Cambodia**********	   
ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment ///
	   urban globalexposure if country == 12 ,nolog or 

	   
*******Thailand**********	   
ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment ///
	   urban globalexposure if country == 8 ,nolog or 
log close	   




*******Vietnam**********	   
ologit protectworkern collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment ///
	   urban globalexposure if country == 11 & wave4 == 0 ,nolog or 

	   
*******Cambodia**********	   
ologit protectworkern collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment ///
	   urban globalexposure if country == 12 & wave4 == 0 ,nolog or 

	   
*******Thailand**********	   
ologit protectworkern collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment ///
	   urban globalexposure if country == 8 & wave4 == 0 ,nolog or 
	   
	   
	   
	   
	   
	   