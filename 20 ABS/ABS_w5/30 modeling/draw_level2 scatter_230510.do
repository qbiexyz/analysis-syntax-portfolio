* Last Updated: 2023. 06 .05
* File name: []
* Data:ABSW5  
* Subject: data clean

/***************************************************
*                      ABSW5                      *
***************************************************/

cd "D:\Dropbox\工作\中研院_工作\ABSW5 Attitudes toward China\"


import excel "10 data\macro\level2 scatter.xlsx", ///
       sheet("工作表1") cellrange(A1:G16) firstrow clear


* HDI			   
aaplot USinfluence HDI, ///
       msize(vsmall) mlabel(country) mlabsize(vsmall) mlabangle(stdarrow) ///
	   ytitle("US influence") lopts(lc(red)) ///
	   ylabel(3(0.5)5) xlabel(0.6(0.1)1) ///
	   aformat(%-12.3f) bformat(%-12.3f) cformat(%-12.3f) ///
	   rsqformat(%-12.3f) rmseformat(%-12.3f)
graph export "30 output/draw_level2/USinfluence_HDI_230605.tif", ///
	         width(1450) height(900) replace
			 
aaplot Chinainfluence HDI, ///
       msize(vsmall) mlabel(country) mlabsize(vsmall)  ///
	   ytitle("China influence") lopts(lc(red)) ///
	   ylabel(2.5(0.5)4.5) xlabel(0.6(0.1)1) ///
	   aformat(%-12.3f) bformat(%-12.3f) cformat(%-12.3f) ///
	   rsqformat(%-12.3f) rmseformat(%-12.3f)
graph export "30 output/draw_level2/Chinainfluence_HDI_230605.tif", ///
	         width(1450) height(900) replace
			 
* globalization
aaplot USinfluence globalization, ///
       msize(vsmall) mlabel(country) mlabsize(vsmall) mlabangle(stdarrow) ///
	   ytitle("US influence") lopts(lc(red)) ///
	   ylabel(3(0.5)5) xlabel(40(10)90) ///
	   aformat(%-12.3f) bformat(%-12.3f) cformat(%-12.3f) ///
	   rsqformat(%-12.3f) rmseformat(%-12.3f)
graph export "30 output/draw_level2/USinfluence_globalization_230605.tif", ///
	         width(1450) height(900) replace
			 
aaplot Chinainfluence globalization, ///
       msize(vsmall) mlabel(country) mlabsize(vsmall)  ///
	   ytitle("China influence") lopts(lc(red)) ///
	   ylabel(2.5(0.5)4.5) xlabel(40(10)90) ///
	   aformat(%-12.3f) bformat(%-12.3f) cformat(%-12.3f) ///
	   rsqformat(%-12.3f) rmseformat(%-12.3f)
graph export "30 output/draw_level2/Chinainfluence_globalization_230605.tif", ///
	         width(1450) height(900) replace
			 		 
* LDI
aaplot USinfluence LDI, ///
       msize(vsmall) mlabel(country) mlabsize(vsmall) mlabangle(stdarrow) ///
	   ytitle("US influence") lopts(lc(red)) ///
	   ylabel(3(0.5)5) xlabel(0.1(0.1)0.9) ///
	   aformat(%-12.3f) bformat(%-12.3f) cformat(%-12.3f) ///
	   rsqformat(%-12.3f) rmseformat(%-12.3f)
graph export "30 output/draw_level2/USinfluence_LDI_230605.tif", ///
	         width(1450) height(900) replace
			 
aaplot Chinainfluence LDI, ///
       msize(vsmall) mlabel(country) mlabsize(vsmall)  ///
	   ytitle("China influence") lopts(lc(red)) ///
	   ylabel(2.5(0.5)4.5) xlabel(0.1(0.1)0.9) ///
	   aformat(%-12.3f) bformat(%-12.3f) cformat(%-12.3f) ///
	   rsqformat(%-12.3f) rmseformat(%-12.3f)
graph export "30 output/draw_level2/Chinainfluence_LDI_230605.tif", ///
	         width(1450) height(900) replace
			 
* economic_freedom
aaplot USinfluence economic_freedom, ///
       msize(vsmall) mlabel(country) mlabsize(vsmall) mlabangle(stdarrow) ///
	   ytitle("US influence") lopts(lc(red)) ///
	   ylabel(3(0.5)5) xlabel(5.5(0.5)9.5) ///
	   aformat(%-12.3f) bformat(%-12.3f) cformat(%-12.3f) ///
	   rsqformat(%-12.3f) rmseformat(%-12.3f)
graph export "30 output/draw_level2/USinfluence_economic_freedom_230605.tif", ///
	         width(1450) height(900) replace
			 
aaplot Chinainfluence economic_freedom, ///
       msize(vsmall) mlabel(country) mlabsize(vsmall)  ///
	   ytitle("China influence") lopts(lc(red)) ///
	   ylabel(2.5(0.5)4.5) xlabel(5.5(0.5)9.5) ///
	   aformat(%-12.3f) bformat(%-12.3f) cformat(%-12.3f) ///
	   rsqformat(%-12.3f) rmseformat(%-12.3f)
graph export "30 output/draw_level2/Chinainfluence_economic_freedom_230605.tif", ///
	         width(1450) height(900) replace