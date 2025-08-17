* Last Updated: 2022 . 01 14
* File name: [ABSW3_4_modeling]
* Data: ABS34append
* Subject: output

/***************************************************
                    ABS34append               *
***************************************************/

/*
cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"
*/
cd "D:\Dropbox\qbiexyz\中研院_工作\ABSW3_4"

use ABSW3_4_data/ABS34append.dta,clear



sort country


foreach i of numlist 4 11 12 8{
sum2docx age eduyear globalexposure ecofamily ///
	     ecocountry collectivismq1 collectivismq2 trustg truste if country==`i' ///
         using Table1.docx, append ///
         stats( mean(%9.2f) sd(%9.2f) ) 
}

shellout Table1.docx

by country : ///
sum age eduyear globalexposure ecofamily ///
    ecocountry collectivismq1 collectivismq2 trustg truste

sum  age eduyear globalexposure ecofamily ///
    ecocountry collectivismq1 collectivismq2 trustg truste
 

foreach i of numlist 4 11 12 8{
tab1 wave4 male employment_C employment urban finc4n if country==`i'
} 
 
 
 

*******China**********
ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment_C  ///
	   urban globalexposure if country == 4 ,nolog or 

*******Vietnam**********	   
ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age edu b0.employment ///
	   urban globalexposure if country == 11 ,nolog or 

	   

	   
	   
	   