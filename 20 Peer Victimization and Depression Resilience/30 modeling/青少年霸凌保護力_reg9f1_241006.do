* Last Updated: 2024. 10. 06
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

foreach x in "1" "2" "3" "5n" {
	replace brv_who_`x' = . if BR_FV == . & brv_who_`x' != .
	replace bcv_who_`x' = . if BC_FV == . & bcv_who_`x' != .
}

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

	reg CESD_9 female feco  ///
	        `x' 
	est store `x'_1

	reg CESD_9 female feco  ///
	        `x' ///
			SESTEEM FS CLASS SCH
	est store `x'_2

	
	reg CESD_9 female feco  ///
	        `x' ///
			SESTEEM FS CLASS SCH ///
	        c.`x'r#c.SESTEEMr c.`x'r#c.FSr ///
			c.`x'r#c.CLASSr c.`x'r#c.SCHr
	est store `x'
	
}	


*
esttab  BR_FV_1 BR_FV_2 BR_FV BC_FV_1 BC_FV_2 BC_FV ///
		, b(3) se(3) r2 ar2 obslast nogaps compress  ///
		nonum nobase  mtitles order(_cons) append  

 
esttab  BR_FV  BC_FV ///
		, b(3) beta(3) se(3) r2 ar2 obslast nogaps compress wide ///
		nonum nobase  mtitles order(_cons) append  


/****************************************************************************
draw inter                           
****************************************************************************/
est restore BR_FV
					   
quietly margins , at(BR_FVr =(-7(1)17) CLASSr = (-2.970393, 2.970393))
marginsplot, noci ytitle("憂鬱情緒") xtitle("實體同儕受害頻率") ///
	             title("") ylabel(6(1)9) ///
				 xlabel(-7 "0" -5 "2" -3 "4" -1 "6" 1 "8" 3 "10" 5 "12" ///
				        7 "14" 9 "16" 11 "18" 13 "20" 15 "22" 17 "24")  ///
				 legend(order(1 "低班級支持" ///
			                  2 "高班級支持" ) ///
					    col(2) position(6)) ///
			 recast(line)  ///
			 plot1opts(lwidth(thick))  ///
			 plot2opts(lwidth(thick)) 

**** 
		 
est restore BC_FV
					
quietly margins , at(BC_FVr =(-6(1)15) SCHr = (-1.949919, 1.949919))
marginsplot, noci ytitle("憂鬱情緒") xtitle("網路同儕受害頻率") ///
	             title("") ylabel(6(1)11) ///
				 xlabel(-6 "0" -4 "2" -2 "4" 0 "6" 2 "8" 4 "10" 6 "12" ///
				        8 "14" 10 "16" 12 "18" 14 "20" 15 "21")  ///
				 legend(order(1 "低學校歸屬" ///
			                  2 "高學校歸屬" ) ///
					    col(2) position(6)) ///
			 recast(line)  ///
			 plot1opts(lwidth(thick))  ///
			 plot2opts(lwidth(thick)) 
		  

/****************************************************************************
test vif                                  
****************************************************************************/
est restore BR_FV_3
estat hettest
estat vif

est restore BC_FV_3
hettest
vif

/****************************************************************************
test icc                             
****************************************************************************/

quietly mixed  CESD_9 female feco  ///
	        BR_FV ///
			SESTEEM FS CLASS SCH ///
	        c.BR_FVr#c.SESTEEMr c.BR_FVr#c.FSr ///
			c.BR_FVr#c.CLASSr c.BR_FVr#c.SCHr ///
	|| school_id: || class: , mle cov(un)  
estat icc


quietly mixed  CESD_9 female feco  ///
	        BC_FV ///
			SESTEEM FS CLASS SCH ///
	        c.BC_FVr#c.SESTEEMr c.BC_FVr#c.FSr ///
			c.BC_FVr#c.CLASSr c.BC_FVr#c.SCHr ///
	|| school_id: || class: , mle cov(un)  
estat icc