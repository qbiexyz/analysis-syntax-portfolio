*Last Update : 2022.10.17
*Filename : [rc_modeling][偏鄉]221017 all logit model
*Data:
*Subject:all logit model


cd "C:\Users\qbieqbiexyz\Desktop\rc"
******************************************************************************
sysdir set PLUS "D:\stata_pkgs\plus"
use "rc_data\tscs_lv7\analysis_clear_only_1017.dta",clear

program drop _all
program define f_model
preserve
drop if hs_type1 == `2'

melogit `1'  || sschcd3: ,vce(robust)
est store m1
estat icc

melogit `1'  male lictyp retest chimiss engmiss mathmiss ///
			 grade b1.hscity_n sschpub  ///
			 || sschcd3: grade,vce(robust) asis
est store m2


melogit `1'  male lictyp retest chimiss engmiss mathmiss ///
			 grade b1.hscity_n sschpub hscity_n#c.grade  ///
			 || sschcd3: grade,vce(robust) asis
est store m3


esttab *,b(3) se(3) staraux lab nogap wide compress replace 
restore
est clear
end


program define f1_model
preserve
drop if hs_type1 == `2'

melogit `1'  || sschcd3: ,vce(robust)  
est store m1
estat icc

melogit `1'  male lictyp retest ///
			 b1.hscity_n sschpub ///
			 || sschcd3: ,vce(robust)  
est store m2
estat icc

esttab *,b(3) se(3) staraux lab nogap wide compress replace 
restore
est clear
end

/**************************************************************************************
******************************     選滿考5科      ************************************
**************************************************************************************/

log using "rc_output\偏鄉\out1017_永健\model\行政地區\選滿考5科 國英數平均 行政地區_output1017.txt" ,replace text 

/*
Y:選滿考5科 = 1 沒選滿 = 0
X:行政地區(金門、澎湖、連江合併為離島)
  國英數(平均)
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/


/*
(只看純普高資料)
*/
f1_model ttscore_c2 0 

/*
/*
(all)
*/
f1_model ttscore_c2 . 
/*
(只看非普高資料)
*/
f1_model ttscore_c2 1 
*/

log close 


/**************************************************************************************
******************************     選滿6志願      ************************************
**************************************************************************************/

log using "rc_output\偏鄉\out1017_永健\model\行政地區\選滿6志願 國英數平均 行政地區_output1017.txt" ,replace text 

/*
Y:選滿6志願 = 1 沒選滿 = 0
X:行政地區(金門、澎湖、連江合併為離島)
  國英數(平均)
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/

/*
(只看純普高資料)
*/
f_model fill6 0 

/*
/*
(all)
*/
f_model fill6 . 
/*
(只看非普高資料)
*/
f_model fill6 1 
*/

log close 

/**************************************************************************************
**************************************************************************************
**************************************************************************************/


program define f2_model
preserve
drop if hs_type1 == `2'
keep if choose >= `3'

melogit `1'  || sschcd3: ,vce(robust) 
est store m1
estat icc

melogit `1'  male lictyp retest chimiss engmiss mathmiss ///
			 grade b1.hscity_n sschpub  ///
			 || sschcd3: grade,vce(robust) asis
est store m2


melogit `1'  male lictyp retest chimiss engmiss mathmiss ///
			 grade b1.hscity_n sschpub hscity_n#c.grade  ///
			 || sschcd3: grade,vce(robust) asis
est store m3


melogit `1'  male lictyp retest chimiss engmiss mathmiss ///
             fill6  ///
			 grade b1.hscity_n sschpub  ///
			 || sschcd3: grade,vce(robust) asis			 					 					                      
est store m6


melogit `1'  male lictyp retest chimiss engmiss mathmiss ///
             fill6  ///
			 grade b1.hscity_n sschpub hscity_n#c.grade  ///
			 || sschcd3: grade,vce(robust) asis

est store m7


esttab *,b(3) se(3) staraux lab nogap wide compress replace 
restore
est clear
end

/**************************************************************************************
******************************     全選公立大學      ************************************
**************************************************************************************/

log using "rc_output\偏鄉\out1017_永健\model\行政地區\全選公立大學 國英數平均 行政地區_output1017.txt" ,replace text 

/*
Y:全選公立大學 (1 = 志願全選公立大學 0 = 其他)
X:行政地區(金門、澎湖、連江合併為離島)
  國英數平均
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/

/*
(只看純普高資料)
*/
f2_model allpub 0 0

/*
/*
(all)
*/
f2_model allpub . 0
/*
(只看非普高資料)
*/
f2_model allpub 1 0
*/

log close

/**************************************************************************************
******************************     選公立大學佔大多數      ************************************
**************************************************************************************/

log using "rc_output\偏鄉\out1017_永健\model\行政地區\選公立大學佔大多數 國英數平均 行政地區_output1017.txt" ,replace text 

/*
Y:選公立大學佔大多數 (1 = 選公立大學佔大多數 0 = 其他)
X:行政地區(金門、澎湖、連江合併為離島)
  國英數平均
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/

/*
(只看純普高資料)
*/
f2_model pub1 0 0

/*
/*
(all)
*/
f2_model pub1 . 0
/*
(只看非普高資料)
*/
f2_model pub1 1 0
*/

log close

/**************************************************************************************
******************************    志願一階大多數都通過      ************************************
**************************************************************************************/

log using "rc_output\偏鄉\out1017_永健\model\行政地區\志願一階大多數都通過 國英數平均 行政地區_output1017.txt" ,replace text 

/*
Y:志願一階大多數都通過 (1 = 志願一階大多數都通過 0 = 其他)
X:行政地區(金門、澎湖、連江合併為離島)
  國英數平均
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/

/*
(只看純普高資料)
*/
f2_model pass1st_1 0 0

/*
/*
(all)
*/
f2_model pass1st_1 . 0
/*
(只看非普高資料)
*/
f2_model pass1st_1 1 0
*/
log close 

/*
program drop nocancel
*/

/**************************************************************************************
******************************    有被分發且沒有放棄   ************************************
**************************************************************************************/

log using "rc_output\偏鄉\out1017_永健\model\行政地區\有被分發且沒有放棄(all) 國英數平均 行政地區_output1017.txt" ,replace text 

/*
select = all
Y:有被分發且沒有放棄 (1 = 有被分發且沒有放棄 0 = 其他)
X:行政地區(金門、澎湖、連江合併為離島)
  國英數平均
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/

/*
(只看純普高資料)
*/
f2_model nocancel 0 0

/*
/*
(all)
*/
f2_model nocancel . 0
/*
(只看非普高資料)
*/
f2_model nocancel 1 0
*/

log close 


log using "rc_output\偏鄉\out1017_永健\model\行政地區\有被分發且沒有放棄(1階通過) 國英數平均 行政地區_output1017.txt" ,replace text 

/*
select 資料至少1階要通過一個

Y:有被分發且沒有放棄 (1 = 有被分發且沒有放棄 0 = 其他) 
X:行政地區(金門、澎湖、連江合併為離島)
  國英數平均
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/


/*
(只看純普高資料)
*/
f2_model nocancel 0 1

/*
/*
(all)
*/
f2_model nocancel . 1
/*
(只看非普高資料)
*/
f2_model nocancel 1 1
*/

log close 


log using "rc_output\偏鄉\out1017_永健\model\行政地區\有被分發且沒有放棄(二階有正備取，不一定有備上) 國英數平均 行政地區_output1017.txt" ,replace text 

/*
select 資料二階有正備取(不一定有備上)

Y:有被分發且沒有放棄 (1 = 有被分發且沒有放棄 0 = 其他) 
X:行政地區(金門、澎湖、連江合併為離島)
  國英數平均
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/


/*
(只看純普高資料)
*/
f2_model nocancel 0 2

/*
/*
(all)
*/
f2_model nocancel . 2
/*
(只看非普高資料)
*/
f2_model nocancel 1 2
*/

log close 

log using "rc_output\偏鄉\out1017_永健\model\行政地區\有被分發且沒有放棄(二階有被分發＝有正取或備上) 國英數平均 行政地區_output1017.txt" ,replace text 

/*
select 資料二階有被分發＝有正取或備上

Y:有被分發且沒有放棄 (1 = 有被分發且沒有放棄 0 = 其他) 
X:行政地區(金門、澎湖、連江合併為離島)
  國英數平均
z:男性 中低收入戶 高中是否為公立(可看作社經地位) 重考生 高中地區(北部為參考組)
*/


/*
(只看純普高資料 )
*/
f2_model nocancel 0 4

/*
/*
(all)
*/
f2_model nocancel . 4
/*
(只看非普高資料)
*/
f2_model nocancel 1 4
*/

log close 




