* Last Updated: 2024. 03. 29
* File name: []
* Data: 學生AB總檔_0131LABEL
* Subject: 


/*****************************
*                            *
*****************************/
cd "C:\Dropbox\工作\杏容老師_work\TIGPS2023"

***************************************************************************
est clear

use "10 data\lca5_n_240329.dta", clear

/***************************************************************************
                                
***************************************************************************/

recode group5 (2 = 1 "無霸凌")(5 = 2 "實體與網路都霸凌") ///
              (4 = 3 "實體霸凌")(3 = 4 "網路霸凌")(1 = 5 "言語霸凌") ///
			  , gen(bully_5)


	   
* 五類 <-  + 性別 + 健康 + 經濟狀況 + 家庭結構 + 成績 + 
*          + 保護因子(家庭、班級與學校) 
mlogit ///
       bully_5 ///
	   female hlth feco b1.cohabit b1.rank  ///
	   FS CLASS SCH, b(1) 
est store m1

/**/
keep if e(sample) 

/*
mlogtest, combine 
mlogtest, iia
*/


* 五類 <-  + 性別 + 健康 + 經濟狀況 + 家庭結構 + 成績 
*          + 保護因子(家庭、班級與學校) 
*          + 網路壓力因應1、2
mlogit ///
       bully_5 ///
	   female hlth feco b1.cohabit b1.rank  ///
	   FS CLASS SCH DCOP_f1 DCOP_f2, b(1) 
est store m2


*******************************************************************************
*******************************************************************************
*******************************************************************************

esttab m1 m2 using "30 output\lca\m1_240329.csv" ///
       , b(3) se(3) nogaps nol nonum  nobase replace unstack  ///
       transform(ln*: exp(2*@) exp(2*@) ) ///
       eqlabels("" "var(tenure)" "var(_cons)" "var(Residual)", none) ///
       varlabels(,elist(weight:_cons "{break}{hline @width}")) ///
       varwidth(10)	
	   
	   
desctable female hlth feco i.cohabit i.rank FS CLASS SCH ///  
          br_fv_01b- bc_fv_07b ///
         , filename("30 output\desc\永健_240519") ///
		  stats(mean sd)	   
