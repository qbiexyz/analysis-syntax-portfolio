* Last Updated: 2023. 04. 01
* File name: merge1417
* Data: TYP
* Subject: mlogit

/*****************************
*          TYP 2014 2017      *
*****************************/

cd "D:\Dropbox\工作\中研院_工作\! done\TYP_work\new"

*******************************************************************************
*******************************************************************************
*******************************************************************************

***2014
use data\14\group_14_230401,clear

/*
merge 1:m id2 using "data\unemperiod.dta"
keep if _merge == 3
*/
*log using "output/mlogit 三類_230325.txt", text replace

/*****************************
*          TYP 2014          *
*****************************/

gen touse2 = !missing(group3_14, gender14, J314, edu6_14, worksector14, ///
                      firmsize14, supervising14, nightshift14, ///
					  holidayshift14, urbanization14, unemploy14)

mlogit group3_14 J314 gender14 b1.edu6_14 b3.worksector14 b1.firmsize14 ///
	   b1.supervising14 nightshift14 holidayshift14 b1.urbanization14 unemploy14,b(3)
est store m1
	   
	   
*log close

***2017

cd "D:\Dropbox\工作\中研院_工作\! done\TYP_work\new"
use data\17\group_17_230401,clear
/*
merge 1:m id2 using "data\unemperiod.dta"
keep if _merge == 3
*/
*log using "output/mlogit 三類_230325.txt", text append

/*****************************
*          TYP 2017          *
*****************************/


gen touse2 = !missing(group3_17, gender17, J317, edu6_17, worksector17, ///
                      firmsize17, supervising17, nightshift17, ///
					  holidayshift17, urbanization17, unemploy17)

mlogit group3_17 J317 gender17 b1.edu6_17 b3.worksector17 b1.firmsize17 ///
	   b1.supervising17 nightshift17 holidayshift17 b1.urbanization17 unemploy17,b(3)
est store m2

*log close

*******************************************************************************
*******************************************************************************
*******************************************************************************

esttab m1 using "output/m1_230401.csv" ///
       , b(3) se(3) nogaps nol nonum  nobase replace unstack  ///
       transform(ln*: exp(2*@) exp(2*@) ) ///
       eqlabels("" "var(tenure)" "var(_cons)" "var(Residual)", none) ///
       varlabels(,elist(weight:_cons "{break}{hline @width}")) ///
       varwidth(10)		
esttab m2 using "output/m2_230401.csv" ///
       , b(3) se(3) nogaps nol nonum  nobase replace unstack  ///
       transform(ln*: exp(2*@) exp(2*@) ) ///
       eqlabels("" "var(tenure)" "var(_cons)" "var(Residual)", none) ///
       varlabels(,elist(weight:_cons "{break}{hline @width}")) ///
       varwidth(10)			   
	   
