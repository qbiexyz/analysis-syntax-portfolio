* Last Updated: 2024. 01. 09
* File name: [ABSW5]
* Data: 亞洲民主動態調查
* Subject: 

/*****************************
*                  *
*****************************/
*設定工作路徑
cd "C:\Dropbox\工作\中研院_工作\Tolerance of Inequality_ABS4_5"

******************************************************************************
est clear
do "20 model\10 clean\W5_d_240111.do"

/*
log using "ABS_W4_output/revise/221205結果 .txt" , text replace 			
*/



/*********************************************************************
******************** 收入分配很公平 ****************************
*********************************************************************/
mixed inc_tor lgni gdpg gini country_Socialist ///
	  b4.inequality_all improve ///
	  male age edu b1.fincq sclass ///
		|| country: , mle cov(unstr) pweight(wei_a2) nolog

est store m1

/*
***gini互動 		
mixed inc_tor lgni gdpg gini country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
	  inequality_all#c.country_Socialist ///
		|| country: , mle cov(unstr) pweight(wei_a2) nolog
*/

/**********************************************************************
******************** 政府不必去減少貧富差距 ****************************
*********************************************************************/
mixed noinc_greduce lgni gdpg gini country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
		|| country: , mle cov(unstr) pweight(wei_a2) nolog		
est store m2

***gini互動 		
mixed noinc_greduce lgni gdpg ginic country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
	  inequality_all#c.ginic ///
		|| country: , mle cov(unstr) pweight(wei_a2) nolog

est store m3		

est restore m2	
quietly margins inequality_all,at(gdpgc=(-5(2)5))
marginsplot, scheme(sj) noci ytitle(政府不必去減少貧富差距) ///
             xtitle(經濟成長率) title("") ylabel(1.7(0.1)2.1)

graph export "ABS_W4_output\revise/表二的第2欄_2212011.tif" ///
              , width(1440) height(900) replace					
		
		
***社會主義國家互動 		
mixed noinc_greduce lgni gdpg gini country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
	  inequality_all#c.country_Socialist ///
		|| country: , mle cov(unstr) pweight(wei_a2) nolog			

est store m4

margins ,at(inequality_all = (1, 2, 3, 4) country_Socialist = (0, 1))
marginsplot, x(country_Socialist) xscale(r(-0.25 1.25)) xtitle("") ///
             title("") ytitle(政府不必去減少貧富差距) ///
			 ylabel(1.7(0.1)2.1, angle(0)) ///
             legend(col(2)) scheme(sj) noci
			 
graph export "ABS_W4_output\revise/表二的第3欄_2212011.tif" ///
              , width(1440) height(900) replace
		 


esttab * using "30 output\model\model5_00.csv", ///
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


quietly mixed inc_tor || country: , mle cov(unstr) pweight(wei_a2)
estat icc
quietly mixed noinc_greduce || country: , mle cov(unstr) pweight(wei_a2)
estat icc

		
/*
drop if country == 15 | country == 18 
*/
mixed inc_tor lgni gdpg gini country_Socialist ///
	  b4.inequality_all improve ///
	  male age edu b1.fincq sclass ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog

est store m222
estat icc
mixed noinc_greduce lgni gdpg gini country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
		|| country: , mle cov(unstr) pweight(wei_a) nolog		
est store m444
estat icc


esttab * using "30 output\model\model5_0002.csv", ///
	b(3) se(3) nogaps nol nonum  nobase replace ///
	transform(ln*: exp(2*@) exp(2*@) ) ///
	eqlabels("" "var(tenure)" "var(_cons)" "var(Residual)", none) ///
	varlabels(,elist(weight:_cons "{break}{hline @width}")) varwidth(10)
