*Last Update : 2022.10.17
*Filename : [rc_modeling][偏鄉]221017 model try grade 偏鄉三類
*Data:
*Subject:model try grade


cd "C:\Users\qbieqbiexyz\Desktop\rc"
******************************************************************************
sysdir set PLUS "D:\stata_pkgs\plus"
use "rc_data\tscs_lv7\analysis_clear_only_1017.dta",clear

program drop _all
program define grade 
preserve
drop if hs_type1 == `2'
quietly mixed `1'  || sschcd3: ,vce(robust) 
estat icc

quietly mixed `1'  male lictyp retest  ///
				   b1.rural_3 b1.hscity4 sschpub  ///
				   || sschcd3: ,vce(robust) 
est store m1
estat icc

esttab *,b(3) se(3) staraux r2 ar2 lab nonum nogap wide compress replace 
restore
est clear
end

program define grade1 
preserve
drop if hs_type1 == `2'
mixed `1'  || sschcd3: ,vce(robust) 

mixed `1'  male lictyp retest  ///
		   b1.rural_3 b1.hscity4 sschpub  ///
		   || sschcd3: ,vce(robust) 
restore
est clear
end

/*
program drop grade
*/
/**************************************************************************************
******************************     各科成績       ************************************
**************************************************************************************/

log using "rc_output\偏鄉\out1017_永健\model\grade\偏鄉三類\國文 偏鄉三類_output1017.txt" ,replace text 
/*
Y = 國文級分
X:偏鄉三類(都會/工商市區為參考組)
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/ 

/*
(只看純普高資料)
*/
grade gsat_chigp_rc2 0 
grade1 gsat_chigp_rc2 0
/*
(all)
*/
grade gsat_chigp_rc2 . 
grade1 gsat_chigp_rc2 .
/*
(只看非普高資料)
*/
grade gsat_chigp_rc2 1 
grade1 gsat_chigp_rc2 1

log close 

log using "rc_output\偏鄉\out1017_永健\model\grade\偏鄉三類\英文 偏鄉三類_output1017.txt" ,replace text 
/*
Y = 英文級分
X:偏鄉三類(都會/工商市區為參考組)
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/ 

/*
(只看純普高資料)
*/
grade eng 0 
grade1 eng 0 
/*
(all)
*/
grade eng . 
grade1 eng .
/*
(只看非普高資料)
*/
grade eng 1 
grade1 eng 1

log close 

log using "rc_output\偏鄉\out1017_永健\model\grade\偏鄉三類\數學 偏鄉三類_output1017.txt" ,replace text 
/*
Y = 數學級分
X:偏鄉三類(都會/工商市區為參考組)
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/ 

/*
(只看純普高資料)
*/
grade gsat_mathgp_rc2 0 
grade1 gsat_mathgp_rc2 0
/*
(all)
*/
grade gsat_mathgp_rc2 . 
grade1 gsat_mathgp_rc2 .
/*
(只看非普高資料)
*/
grade gsat_mathgp_rc2 1 
grade1 gsat_mathgp_rc2 1

log close 

log using "rc_output\偏鄉\out1017_永健\model\grade\偏鄉三類\社會 偏鄉三類_output1017.txt" ,replace text 
/*
Y = 社會級分
X:偏鄉三類(都會/工商市區為參考組)
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/ 

/*
(只看純普高資料)
*/
grade gsat_socgp_rc2 0 
grade1 gsat_socgp_rc2 0
/*
(all)
*/
grade gsat_socgp_rc2 . 
grade1 gsat_socgp_rc2 .
/*
(只看非普高資料)
*/
grade gsat_socgp_rc2 1 
grade1 gsat_socgp_rc2 1

log close 


log using "rc_output\偏鄉\out1017_永健\model\grade\偏鄉三類\自然 偏鄉三類_output1017.txt" ,replace text 
/*
Y = 自然級分
X:偏鄉三類(都會/工商市區為參考組)
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/ 

/*
(只看純普高資料)
*/
grade gsat_scigp_rc2 0 
grade1 gsat_scigp_rc2 0
/*
(all)
*/
grade gsat_scigp_rc2 . 
grade1 gsat_scigp_rc2 .
/*
(只看非普高資料)
*/
grade gsat_scigp_rc2 1 
grade1 gsat_scigp_rc2 1

log close 


log using "rc_output\偏鄉\out1017_永健\model\grade\偏鄉三類\平均級分 偏鄉三類_output1017.txt" ,replace text 
/*
Y = 平均級分(各科級分加總/選考幾科)
X:偏鄉三類(都會/工商市區為參考組)
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/ 

/*
(只看純普高資料)
*/
grade ttscore_m 0 
grade1 ttscore_m 0
/*
(all)
*/
grade ttscore_m . 
grade1 ttscore_m .
/*
(只看非普高資料)
*/
grade ttscore_m 1 
grade1 ttscore_m 1

log close 


log using "rc_output\偏鄉\out1017_永健\model\grade\偏鄉三類\國英數總分 偏鄉三類_output1017.txt" ,replace text 
/*
Y = 國英數總分(國英數級分加總)
X:偏鄉三類(都會/工商市區為參考組)
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/ 

/*
(只看純普高資料)
*/
grade grade3m 0 
grade1 grade3m 0
/*
(all)
*/
grade grade3m . 
grade1 grade3m .
/*
(只看非普高資料)
*/
grade grade3m 1 
grade1 grade3m 1

log close 

log using "rc_output\偏鄉\out1017_永健\model\grade\偏鄉三類\國英數平均 偏鄉三類_output1017.txt" ,replace tex

/*
Y = 國英數平均
X:偏鄉三類(都會/工商市區為參考組)
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/ 

/*
(只看純普高資料)
*/
grade grade 0 
grade1 grade 0 
/*
(all)
*/
grade grade . 
grade1 grade .
/*
(只看非普高資料)
*/
grade grade 1 
grade1 grade 1

log close 