* Last Updated: 2024. 03 . 10
* File name: [tscs0818_modeling]
* Data:tscs08 18  
* Subject: rey des
* qbie


cd "C:\Dropbox\工作\中研院_工作\! done\社會距離\"

/***************************************************
*                     tscs08                       *
***************************************************/

do "tscs0818_modeling\10 clean data 08.do"


tab1 sex educ3 inc_h4 travel meet

desctable i.sex age i.educ3 eng_a i.inc_h4 intuse i.travel i.meet, ///
     filename("des08") stats(mean sd min max )
	 
sum age eng_a intuse

dtable	i.travel i.meet i.f_ethnic i.sex i.educ3 i.inc_h4 i.urbanization ///
		, cont(,stat(mean sd)) nosample fact( ,stat(fvpercent)) ///
		nformat(%9.1f) sformat("%s%%" fvpercent) ///
		export("tscs0818_output\des_08_240311.xlsx", replace) 


misstable sum age sex educ3 inc_h4 urbanization ///
              travel meet eng_a intuse f_ethnic ///
			  social_dis1_* social_dis2_* social_dis3_*
/***************************************************
*                     tscs18                       *
***************************************************/

est clear
do "tscs0818_modeling\10 clean data 18.do"

use tscs0818_data\tscs182\tscs182_clear.dta,clear
desctable i.sex age i.educ3 eng_a i.inc_h4 intuse i.travel i.meet, ///
     filename("des_18") stats(mean sd min max n)
	   
dtable	i.travel i.meet i.f_ethnic i.sex i.educ3 i.inc_h4 i.urbanization ///
		, cont(,stat(mean sd)) nosample fact( ,stat(fvpercent)) ///
		nformat(%9.1f) sformat("%s%%" fvpercent) ///
		export("tscs0818_output\des_18_240311.xlsx", replace) 
	 
	 
misstable sum age sex educ3 inc_h4 urbanization ///
              travel meet eng_a intuse f_ethnic ///
			  social_disa_* social_disb_* social_disc_*