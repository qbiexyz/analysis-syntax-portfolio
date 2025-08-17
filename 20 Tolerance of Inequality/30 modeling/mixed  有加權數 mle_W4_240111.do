* Last Updated: 2023. 07. 10
* File name: [ABSW5]
* Data: 亞洲民主動態調查
* Subject: 

/*****************************
*                  *
*****************************/
*設定工作路徑
cd "C:\Dropbox\工作\中研院_工作\Tolerance of Inequality_ABS4_5"

*******************************************************************************
est clear
do "20 model\10 clean\W4_d_240111.do"


***表1: 感知代間向上流動的多層次分析

***沒有國家層次
mixed improve b4.inequality_all   ///
	  male age edu sclass b1.fincq ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog
est store m11	


mixed improve gdpgc gini lgni i.country_Socialist b4.inequality_all   ///
	  male age edu sclass b1.fincq ///
	  inequality_all#c.gdpgc ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog
est store m1		
	
est restore m1
quietly margins inequality_all,at(gdpgc=(-5(2)5))		
marginsplot, scheme(sj) noci ytitle(感知代間向上流動) xtitle(經濟成長率) title("") ///
             ylabel(3.2(0.2)4)
			 
graph export "ABS_W4_output\revise/表一的第2欄_2212011.tif", width(1440) height(900) replace
	 			 
		
mixed improve gdpg gini lgni i.country_Socialist b4.inequality_all   ///
	  male age edu sclass b1.fincq ///
	  i.inequality_all#i.country_Socialist ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog
est store m2		

est restore m2
quietly margins ,at(inequality_all = (1, 2, 3, 4) country_Socialist = (0, 1))
marginsplot, x(country_Socialist) xscale(r(-0.25 1.25)) xtitle("") title("")  ///
             ytitle(感知代間向上流動) ylabel(3.2(0.2)4, angle(0)) ///
              legend(col(2)) scheme(sj) noci
			 
graph export "ABS_W4_output\revise/表一的第3欄_2212011.tif", width(1440) height(900) replace
	 
		
/**********************************************************************
******************** 收入分配很公平 ****************************
*********************************************************************/

mixed inc_tor lgni gdpg gini country_Socialist ///
	  b4.inequality_all improve ///
	  male age edu b1.fincq sclass  ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog
est store m001
estat icc

***GDP互動		
mixed inc_tor lgni gdpgc gini country_Socialist ///
	  b4.inequality_all improve ///
	  male age edu b1.fincq sclass ///
	  inequality_all#c.gdpgc ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog	
		
est store m3
estat icc

***gini互動		
mixed inc_tor lgni gdpg ginic country_Socialist ///
	  b4.inequality_all improve ///
	  male age edu b1.fincq sclass ///
	  inequality_all#c.ginic ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog	
		
est store m4
estat icc


quietly margins inequality_all,at(gdpgc=(-5(2)5))		
marginsplot, scheme(sj) noci ytitle(收入分配很公平)  xtitle(經濟成長率) title("") ///
             ylabel(2(0.2)3)
graph export "ABS_W4_output\revise/表二的第1欄_2212011.tif", width(1440) height(900) replace	


/**********************************************************************
******************** 政府不必去減少貧富差距 ****************************
*********************************************************************/

mixed noinc_greduce lgni gdpg gini country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog
est store m002
estat icc

***GDP互動 		
mixed noinc_greduce lgni gdpgc gini country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
	  inequality_all#c.gdpgc ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog
est store m5		
estat icc

est restore m4		
quietly margins inequality_all,at(gdpgc=(-5(2)5))		
marginsplot, scheme(sj) noci ytitle(政府不必去減少貧富差距) xtitle(經濟成長率) title("") ///
             ylabel(1.7(0.1)2.1)		
graph export "ABS_W4_output\revise/表二的第2欄_2212011.tif", width(1440) height(900) replace				

***社會主義互動
mixed noinc_greduce lgni gdpg gini country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
	  inequality_all#c.country_Socialist ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog
est store m6	
estat icc


est restore m5
margins ,at(inequality_all = (1, 2, 3, 4) country_Socialist = (0, 1))
marginsplot, x(country_Socialist) xscale(r(-0.25 1.25)) xtitle("") title("")  ///
             ytitle(政府不必去減少貧富差距) ylabel(1.7(0.1)2.1, angle(0)) ///
              legend(col(2)) scheme(sj) noci
			 
graph export "ABS_W4_output\revise/表二的第3欄_2212011.tif", width(1440) height(900) replace
		 


esttab * using "30 output\model\model4_00.csv", ///
	b(3) se(3) nogaps nol nonum  nobase replace ///
	transform(ln*: exp(2*@) exp(2*@) ) ///
	eqlabels("" "var(tenure)" "var(_cons)" "var(Residual)", none) ///
	varlabels(,elist(weight:_cons "{break}{hline @width}")) varwidth(10)




/**********************************************************************
***************************** ICC    ****************************
*********************************************************************/

est restore m1
estat icc
est restore m2
estat icc
est restore m3
estat icc
est restore m4
estat icc
est restore m5
estat icc
est restore m6
estat icc


quietly mixed inc_tor || country: , mle cov(unstr) pweight(wei_a)
estat icc
quietly mixed noinc_greduce || country: , mle cov(unstr) pweight(wei_a)
estat icc

