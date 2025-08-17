* Last Updated: 2024. 01. 11
* File name: []
* Data:      
* Subject: sum

/***************************************************
*                                                  *
***************************************************/

cd "C:\Dropbox\工作\中研院_工作\Tolerance of Inequality_ABS4_5"

*****************************************************************************
est clear
do "20 model\10 clean\W4_d_240111.do"

tabstat inc_tor noinc_greduce , by(country_gni)

est clear
do "20 model\10 clean\W5_d_240111.do"

tabstat inc_tor noinc_greduce , by(country_gni)


****************************************************************************
est clear
do "20 model\10 clean\W4_d_240111.do"

recode inequality_al (4 = 1 "self-society-")(1 = 2 "self-society+") ///
                     (2 = 3 "self+society-")(3 = 4 "self+society+") ///
					 , gen(inequality_al_e)

dtable i.inequality_al_e ///
        , by(country_gni) nosample fact(, stat(fvpercent)) ///
	      nformat(%9.2f) sformat("%s%%" fvpercent) ///
		  export("30 output\desc\表\IV_draw", as(xlsx) sheet(w4) modify)
		  
est clear
do "20 model\10 clean\W5_d_240111.do"

recode inequality_al (4 = 1 "self-society-")(1 = 2 "self-society+") ///
                     (2 = 3 "self+society-")(3 = 4 "self+society+") ///
					 , gen(inequality_al_e)

dtable i.inequality_al_e ///
        , by(country_gni) nosample fact(, stat(fvpercent)) ///
	      nformat(%9.2f) sformat("%s%%" fvpercent) ///
		  export("30 output\desc\表\IV_draw", as(xlsx) sheet(w5) modify)
		  		  
****************************************************************************
est clear
do "20 model\10 clean\W4_d_240111.do"

dtable male age edu sclass b1.fincq ///
       improve gni gdpg gini ///
       , by(country_gni) nosample ///
	     cont(age edu sclass improve, stat(mean sd)) ///	   
		 cont(male gni gdpg gini, stat(mean)) ///
		 fact(, stat(fvproportion)) ///
	     nformat(%9.2f) ///
		 export("30 output\desc\表\country_des", as(xlsx) sheet(w4) modify)
/*
dtable age edu sclass improve ///
       , by(country_gni) nosample ///
	     cont(, stat(sd)) ///
	     nformat(%9.2f)  sformat("%s") ///
		 export("30 output\desc\表\country_des", as(xlsx) sheet(w42) modify)
*/
est clear
do "20 model\10 clean\W5_d_240111.do"

dtable male age edu sclass b1.fincq ///
       improve gni gdpg gini ///
       , by(country_gni) nosample ///
	     cont(age edu sclass improve, stat(mean sd)) ///	   
		 cont(male gni gdpg gini, stat(mean)) ///
		 fact(, stat(fvproportion)) ///
	     nformat(%9.2f) ///
		 export("30 output\desc\表\country_des", as(xlsx) sheet(w5) modify)
/*
dtable age edu sclass improve ///
       , by(country_gni) nosample ///
	     cont(, stat(sd)) ///
	     nformat(%9.2f) sformat("%s") ///
		 export("30 output\desc\表\country_des", as(xlsx) sheet(w52) modify)
*/		  