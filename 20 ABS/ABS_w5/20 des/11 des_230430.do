* Last Updated: 2023. 04 .30
* File name: []
* Data:ABSW5  
* Subject: data clean

/***************************************************
*                      ABSW5                      *
***************************************************/

cd "C:\Dropbox\工作\中研院_工作\! done\ABSW5 Attitudes toward China\"

use "10 data/Attitudes_toward_China_230429.dta",clear


recode country (15 = 1 "Australia")(1 = 2 "Japan")(3 = 3 "South Korea") ///
               (7 = 4 "Taiwan")(4 = 5 "China")(2 = 6 "Hong Kong") ///
			   (6 = 7 "Philippines")(13 = 8 "Malaysia")(10 = 9 "Singapore") ///
			   (8 = 10 "Thailand")(11 = 11 "Vietnam")(14 = 12 "Myanmar") ///
			   (9 = 13 "Indonesia")(18 = 14 "India")(5 = 15 "Mongolia") ///
			   ,gen(country_n)



foreach x of var USA_influence china_influence ecoQ1 ///
                 g_effect nationalism authoritarian{
	tab country_n, sum(`x') mean
}
