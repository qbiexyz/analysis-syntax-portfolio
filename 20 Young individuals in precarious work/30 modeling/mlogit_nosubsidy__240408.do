* Last Updated: 2024. 03. 21
* File name: merge1417
* Data: TYP
* Subject: mlogit

/*****************************
*          TYP 2014 2017      *
*****************************/

cd "C:\Dropbox\工作\中研院_工作\! done\TYP_work\new"

***************************************************************************
***************************************************************************
***************************************************************************

***2014
use data\14\group_14_nosubsidy_230410,clear

/*
merge 1:m id2 using "data\unemperiod.dta"
keep if _merge == 3
*/

/*****************************
*          TYP 2014          *
*****************************/

gen touse2 = !missing(group3_14, gender14, J314, edu6_14, worksector14, ///
                      firmsize14, supervising14, nightshift14, ///
					  holidayshift14, urbanization14, unemploy14)
					  
recode group3_14 (1 = 3)(3 = 1)

* 都市化變成 都市/非都市
recode urbanization14 (1 = 1)(2/4 = 0)

*
recode worksector14 (3 = 1 "私人企業或機構(含人民團體)") ///
                    (1 = 2 "公部門(有政府考試)") ///
					(0 = 3 "公部門(沒政府考試)") ///
					(2 = 4 "非營利組織"), gen(worksectorn14)


mlogit ///
      group3_14 J314 gender14 b1.edu6_14 b1.worksectorn14 b1.firmsize14 ///
	  b1.supervising14 nightshift14 holidayshift14 ///
	  unemploy14 urbanization14 ///
	  if touse2 , b(3) 
est store m1


***2017

cd "C:\Dropbox\工作\中研院_工作\! done\TYP_work\new"
use data\17\group_17_nosubsidy_230410,clear
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
recode group3_17 (1 = 3)(3 = 1)

* 都市化變成 都市/非都市
recode urbanization17 (1 = 1)(2/4 = 0)

recode worksector17 (3 = 1 "私人企業或機構(含人民團體)") ///
                    (1 = 2 "公部門(有政府考試)") ///
					(0 = 3 "公部門(沒政府考試)") ///
					(2 = 4 "非營利組織"), gen(worksectorn17)


mlogit ///
      group3_17 J317 gender17 b1.edu6_17 b1.worksectorn17 b1.firmsize17 ///
	  b1.supervising17 nightshift17 holidayshift17 ///
	  unemploy17 urbanization17 ///
	  if touse2 , b(3)
est store m2

***************************************************************************
***************************************************************************
***************************************************************************

esttab m1 using "output/m1_nosubsidy_240408.csv" ///
       , b(3) se(3) nogaps nol nonum  nobase replace unstack  ///
       transform(ln*: exp(2*@) exp(2*@) ) ///
       eqlabels("" "var(tenure)" "var(_cons)" "var(Residual)", none) ///
       varlabels(,elist(weight:_cons "{break}{hline @width}")) ///
       varwidth(10)		
esttab m2 using "output/m2_nosubsidy_240408.csv" ///
       , b(3) se(3) nogaps nol nonum  nobase replace unstack  ///
       transform(ln*: exp(2*@) exp(2*@) ) ///
       eqlabels("" "var(tenure)" "var(_cons)" "var(Residual)", none) ///
       varlabels(,elist(weight:_cons "{break}{hline @width}")) ///
       varwidth(10)			   
	   
