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
des
**********************************/
gen touse = !missing(CESD_9, female, feco, SESTEEM, FS, CLASS, SCH) 
keep if touse 

/*
foreach x in "1" "2" "3" "5n" {
	replace brv_who_`x' = . if BR_FV == . & brv_who_`x' != .
	replace bcv_who_`x' = . if BC_FV == . & bcv_who_`x' != .
}

desctable ///
    female feco SESTEEM FS CLASS SCH ///
	BR_FV brv_who_1 brv_who_2 brv_who_3 brv_who_5n ///
	BC_FV bcv_who_1 bcv_who_2 bcv_who_3 bcv_who_5n ///
	CESD_9 ///
	,filename("30 output\青少年霸凌保護力\青少年霸凌保護力_des") ///
	stats(n mean sd min max skew kur)
*/
	
desctable ///
	CESD_9 ///
	BR_FV BC_FV ///
    SESTEEM FS CLASS SCH ///
	female feco ///
	,filename("30 output\青少年霸凌保護力\青少年霸凌保護力_des") ///
	stats(n mean sd min max )

/**********************************
相關係數表
**********************************/
pwcorr CESD_9 BR_FV1  BC_FV1 feco SESTEEM FS CLASS SCH , star(0.5) 

/*
asdoc pwcorr ///
		  CESD_9 BR_FV1 BC_FV1 feco SESTEEM FS CLASS SCH ///
		  brv_who_1 brv_who_2 brv_who_3 brv_who_5n ///
		   bcv_who_1 bcv_who_2 bcv_who_3 bcv_who_5n ///
		  , star(all) ///
		  save(30 output\青少年霸凌保護力\青少年霸凌保護力_cor1)
*/
asdoc pwcorr ///
	CESD_9 ///
	BR_FV BC_FV ///
    SESTEEM FS CLASS SCH ///
	 feco ///
		  , star(all) ///
		  save(30 output\青少年霸凌保護力\青少年霸凌保護力_cor1)
pwcorr ///
	CESD_9 ///
	BR_FV BC_FV ///
    SESTEEM FS CLASS SCH ///
	 feco ,sig	 
