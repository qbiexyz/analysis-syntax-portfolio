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

use "10 data\學生AB總檔_0325LABEL.dta", clear

/***************************************************************************
                                
***************************************************************************/

do "20 model\10 clean\學生AB總檔\學生AB總檔_01 霸凌變項_240329.do"
do "20 model\10 clean\學生AB總檔\學生AB總檔_01.2 被誰霸凌_240719.do"
do "20 model\10 clean\學生AB總檔\學生AB總檔_02 其他變項_240329.do"
do "20 model\10 clean\學生AB總檔\學生AB總檔_03 保留變項_240329.do"


/**********************************
霸凌與憂鬱情緒的關聯
**********************************/

gen touse = !missing(CESD_9, female, feco, SESTEEM, FS, CLASS, SCH) 
keep if touse 

tostring school_id, gen(sid)
gen schcla = sid + class

sum BR_FV, meanonly
gen BR_FVr = BR_FV - r(mean)	

sum BC_FV, meanonly
gen BC_FVr = BC_FV - r(mean)

sum SESTEEM, meanonly
gen SESTEEMr = SESTEEM - r(mean)

sum SESTEEM
gen SESTEEMsd = r(sd)

sum FS, meanonly
gen FSr = FS - r(mean)

sum CLASS, meanonly
gen CLASSr = CLASS - r(mean)

sum CLASS
gen CLASSsd = r(sd)

sum SCH, meanonly
gen SCHr = SCH - r(mean)

sum SCH
gen SCHsd = r(sd)


foreach x of var BR_FV  BC_FV  {
	
	* 霸凌(實際、網路) + 控制 -> 憂鬱情緒
	mixed CESD_9 `x' ///
	            female feco ///
		  || school_id: || schcla: , mle cov(un) 
	est store `x'_1
	estat icc
    * 霸凌(實際、網路) + 控制 + 保護因子(個人、家庭、班級與學校) -> 憂鬱情緒
	mixed CESD_9 `x' ///
	            female feco  ///
			    SESTEEM FS CLASS SCH ///
		  || school_id: || schcla: , mle cov(un) 
    est store `x'_2
	estat icc
	mixed CESD_9 `x' ///
            female feco ///
			SESTEEM FS CLASS SCH ///	
	        c.`x'r#c.SESTEEMr c.`x'r#c.FSr ///
			c.`x'r#c.CLASSr c.`x'r#c.SCHr ///
		  || school_id: || schcla: , mle cov(un)  
	est store `x'_3
	estat icc
}	

mixed CESD_9 BR_FV ///
	female feco ///
	SESTEEM FS CLASS SCH ///
	brv_who_1 brv_who_2 brv_who_3  brv_who_5n ///
	|| school_id: || schcla: , mle cov(un)  
est store BR_FV_4
estat icc

mixed CESD_9 BR_FV ///
    female feco ///
	SESTEEM FS CLASS SCH ///
	brv_who_1 brv_who_2 brv_who_3  brv_who_5n ///	
	c.BR_FVr#c.SESTEEMr c.BR_FVr#c.FSr ///
	c.BR_FVr#c.CLASSr c.BR_FVr#c.SCHr ///
	|| school_id: || schcla: , mle cov(un)  
est store BR_FV_5
estat icc

mixed CESD_9 BC_FV ///
	female feco ///
	SESTEEM FS CLASS SCH ///
	bcv_who_1 bcv_who_2 bcv_who_3 bcv_who_5n ///
	|| school_id: || schcla: , mle cov(un)   
est store BC_FV_4
estat icc
	
mixed CESD_9 BC_FV ///
    female feco ///
	SESTEEM FS CLASS SCH ///
	bcv_who_1 bcv_who_2 bcv_who_3 bcv_who_5n ///
	c.BC_FVr#c.SESTEEMr c.BC_FVr#c.FSr ///
	c.BC_FVr#c.CLASSr c.BC_FVr#c.SCHr ///
	|| school_id: || schcla: , mle cov(un)  
est store BC_FV_5
estat icc


* 
foreach x of var BR_FV  BC_FV  {
	esttab  `x'* ///
			, b(3) se(3) obslast nogaps compress wide ///
			nonum nobase  mtitles order(_cons) append noparentheses ///
			 transform(ln*: exp(2*@) exp(2*@) ) ///
eqlabels() ///
varlabels(,elist(weight:_cons "{break}{hline @width}")) ///
varwidth(10)		
		
}


/****************************************************************************
                                
****************************************************************************/
est restore BR_FV_3

predict yhat
lab var yhat "平均分數的預測值"
predict resid, resid
lab var resid "殘差"
twoway (scatter score shour)(connected yhat shour)
twoway (scatter score shour)(lfit score shour)

swilk resid //若p>0.05的話，表示殘差值是符合常態分配的
sfrancia resid

scatter resid yhat, yline(0)
rvfplot, yline(0)


est restore BR_FV_3
estat hettest
estat vif

est restore BC_FV_3
hettest
vif


