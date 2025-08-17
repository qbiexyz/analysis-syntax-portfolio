* Last Updated: 2024. 03. 29
* File name: []
* Data: 學生AB總檔_0131LABEL
* Subject: 


/*****************************
*                            *
*****************************/
cd "C:\Dropbox\工作\杏容老師_work\TIGPS_w1"

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



reg CESD_9 female feco  ///
	b1.b_rc3 ///
	SESTEEM FS CLASS SCH ///
	b_rc3#c.SESTEEMr b_rc3#c.FSr ///
	b_rc3#c.CLASSr b_rc3#c.SCHr


* 
esttab  BR_FV  BC_FV ///
		, b(3) se(3) r2 ar2 obslast nogaps compress wide ///
		nonum nobase  mtitles order(_cons) append noparentheses 


/****************************************************************************
                                
****************************************************************************/
est restore BR_FV
					   
quietly margins , at(SESTEEMr = (-2.5(0.5)0.9) b_rc3 =(1, 2, 3))
marginsplot, noci ytitle("憂鬱情緒") xtitle("自尊") ///
	             title("") ylabel(0(5)40) xlabel(-2.5(0.5)0.9)  ///
				 legend(order(1 "只被實體霸凌" ///
			                  2 "只有被網路霸凌" ///
							  3 "只有被網路與實體霸凌") ///
					    col(3) position(6)) ///
			 recast(line)  ///
			 plot1opts(lwidth(thick))  ///
			 plot2opts(lwidth(thick)) ///
			 plot3opts(lwidth(thick)) 

**** 
		 
est restore BC_FV
					
quietly margins , at(BC_FVr =(-7(1)15) SCHr = (-.6499732, .6499732))
marginsplot, noci ytitle("憂鬱情緒") xtitle("被網路霸凌頻率") ///
	             title("") ylabel(6(1)11) xlabel(-7(2)15) ///
				 legend(order(1 "低學校歸屬" ///
			                  2 "高學校歸屬" ) ///
					    col(2) position(6)) ///
			 recast(line)  ///
			 plot1opts(lwidth(thick))  ///
			 plot2opts(lwidth(thick)) 
		  

/****************************************************************************
                                
****************************************************************************/

est restore BR_FV_3
estat hettest
estat vif

est restore BC_FV_3
hettest
vif

