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

foreach x in "1" "2" "3" "5n" {
	replace brv_who_`x' = . if BR_FV == . & brv_who_`x' != .
	replace bcv_who_`x' = . if BC_FV == . & bcv_who_`x' != .
}


sum BR_FV1, meanonly
gen BR_FV1r = BR_FV1 - r(mean)	

sum BC_FV1, meanonly
gen BC_FV1r = BC_FV1 - r(mean)

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



reg CESD_9 BR_FV1 ///
	brv_who_1 brv_who_2 brv_who_3  brv_who_5n ///
	SESTEEM FS CLASS SCH ///
	female feco 
est store BR_FV1_4
	
reg CESD_9 BR_FV1 ///
	brv_who_1 brv_who_2 brv_who_3  brv_who_5n ///
	SESTEEM FS CLASS SCH ///
	female feco ///
	c.BR_FV1r#c.SESTEEMr c.BR_FV1r#c.FSr ///
	c.BR_FV1r#c.CLASSr c.BR_FV1r#c.SCHr
est store BR_FV1_5

reg CESD_9 BC_FV1 ///
	bcv_who_1 bcv_who_2 bcv_who_3 bcv_who_5n  ///
	SESTEEM FS CLASS SCH ///
	female feco
est store BC_FV1_4
	
reg CESD_9 BC_FV1 ///
	bcv_who_1 bcv_who_2 bcv_who_3 bcv_who_5n  ///
	SESTEEM FS CLASS SCH ///
	female feco ///
	c.BC_FV1r#c.SESTEEMr c.BC_FV1r#c.FSr ///
	c.BC_FV1r#c.CLASSr c.BC_FV1r#c.SCHr
est store BC_FV1_5

* 
foreach x of var BR_FV1  BC_FV1  {
	esttab  `x'* ///
			, b(3) se(3) r2 ar2 obslast nogaps compress wide ///
			nonum nobase  mtitles order(_cons) append noparentheses 	
}


/****************************************************************************
                                
****************************************************************************/
est restore BR_FV1_5
					   
quietly margins , at(BR_FV1r =(-7(1)18) CLASSr = (-.5940785, 0, .5940785))
marginsplot, noci ytitle("憂鬱傾向") xtitle("被實體霸凌頻率(mean-centered)") ///
	             title("") ylabel(6(1)9) xlabel(-7(2)19)  ///
				 legend(order(1 "班級支持平均減一個標準差" 2 "班級支持平均" ///
			                  3 "班級支持平均加一個標準差" ) ///
					    col(3) position(6)) ///
			 recast(line)  ///
			 plot1opts(lwidth(thick))  ///
			 plot2opts(lwidth(thick))  ///
			 plot3opts(lwidth(thick))
			 
est restore BR_FV1_5
margins, dydx(BR_FV1r) at(CLASSr=(-.5940785, 0, .5940785)) ///
         pwcompare(effects groups)		 

est restore BC_FV1_5
					
quietly margins , at(BC_FV1r =(-6(1)16) SCHr = (-.6499732, 0, .6499732))
marginsplot, noci ytitle("憂鬱傾向") xtitle("被網路霸凌頻率(mean-centered)") ///
	             title("") ylabel(5(2)11) xlabel(-6(2)16) ///
				 legend(order(1 "學校歸屬平均減一個標準差" 2 "學校歸屬平均" ///
			                  3 "學校歸屬平均加一個標準差" ) ///
					    col(3) position(6)) ///
			 recast(line)  ///
			 plot1opts(lwidth(thick))  ///
			 plot2opts(lwidth(thick))  ///
			 plot3opts(lwidth(thick))

est restore BC_FV1_5
margins, dydx(BC_FV1r) at(SCHr =(-.6499732, 0, .6499732)) ///
         pwcompare(effects groups)  		 
/*
graph export "output\try model 2\i1M11D1`x'd3.tif", width(1440) height(900) replace	
*/		

/****************************************************************************
                                
****************************************************************************/

est restore BR_FV_3
estat hettest
estat vif

est restore BC_FV_3
hettest
vif

