* Last Updated: 2024. 10 .01
* File name: []
* Data:ABSW5  
* Subject: data clean

/***************************************************
*                      ABSW5                      *
***************************************************/

cd "C:\Dropbox\工作\中研院_工作\! done\ABSW5 Attitudes toward China\"

use "10 data/Attitudes_toward_China.dta", clear

reg USA_influence i.country_n male age edu i.fincq_g4 ecoQ1 g_effect  nationalism

reg china_influence i.country_n male age edu i.fincq_g4 ecoQ1 g_effect  nationalism


reg USA_influence i.country_n male age edu i.fincq_g4 ecoQ1 g_effect  nationalism country_n#c.nationalism

est store m1

reg china_influence i.country_n male age edu i.fincq_g4 ecoQ1 g_effect  nationalism country_n#c.nationalism

est store m2

esttab m1 m2  using "30 output\influence_241027.csv" ///
       , b(3) se(3) nogaps nol nonum  r2 nobase replace ///
       varwidth(10)	 wide      		


/***************************************************
*                                                 *
***************************************************/

global cname "Australia China Hong_Kong India Indonesia Japan Malaysia Mongolia Myanmar Philippines Singapore South_Korea Taiwan Thailand Vietnam"

foreach x of global cname { /* 以每個國家名稱帶入 */

	gen `x' = "0" /* 創一個文字變項 名稱為國家 內容都是文字0 */
	replace `x' = "1" if country_nm == "`x'" /* 將代表該國家數值設為文字1 */
	destring `x', replace force /* 轉成數值變項 變成該國家的dummy */
	
	lab var `x' "`x'" /* 上變項標籤 */
	lab def `x' 1 "`x'" /* 上數值標籤，1 = 該國家名稱 */
	lab val `x' `x'
}


foreach x of global cname { /* 以每個國家名稱帶入 */
    tab country_nm if country_nm == "`x'" 
	reg china_influence `x' ///
	     male age edu i.fincq_g4 ecoQ1 g_effect  nationalism ///
		c.`x'#c.nationalism /*nationlism 與個別國家dummy 的互動項*/	
	est store mchi_`x'
}
	   
foreach x of global cname { /* 以每個國家名稱帶入 */
    tab country_nm if country_nm == "`x'" 
	reg USA_influence `x' ///
	     male age edu i.fincq_g4 ecoQ1 g_effect  nationalism ///
		c.`x'#c.nationalism /*nationlism 與個別國家dummy 的互動項*/	
	est store mUSA_`x'
}

/*
esttab mchi_*  using "30 output\mchi_country_inter.csv" ///
       , b(3) se(3) nogaps nol nonum  r2 nobase replace ///
       varwidth(10)	 wide      		

esttab mUSA_*  using "30 output\mUSA_country_inter.csv" ///
       , b(3) se(3) nogaps nol nonum  r2 nobase replace ///
       varwidth(10)	 wide      		
*/

/***************************************************
*                                                 *
***************************************************/
foreach x of var Australia Hong_Kong Mongolia Myanmar Taiwan Thailand{
	est restore mUSA_`x'
	margins , at(nationalism =(1(1)4) `x' = (1))

	est restore mchi_`x'
	margins , at(nationalism =(1(1)4) `x' = (1))
}



est restore mUSA_Taiwan
quietly margins , at(nationalism =(1(1)4) Taiwan = (0, 1))
marginsplot, noci ytitle("E[USA_influence]") xtitle("Nationalism") ///
	             title("Expected Support for US Influence") ///
				 ylabel(2(0.5)6) ///
				 legend(order(1 "others" ///
			                  2 "Taiwan" ) ///
					    col(2) position(6)) ///
			 recast(line)  ///
			 plot1opts(lwidth(thick))  ///
			 plot2opts(lwidth(thick)) 
			 
/*
marginsplot, noci ytitle("E[china_influence]") xtitle("Nationalism") ///
	             title("Expected Support for Chinese Influence") ///
				 ylabel(2(0.5)6) ///
				 legend(order(1 "others" ///
			                  2 "Taiwan" ) ///
					    col(2) position(6)) ///
			 recast(line)  ///
			 plot1opts(lwidth(thick))  ///
			 plot2opts(lwidth(thick)) 
*/