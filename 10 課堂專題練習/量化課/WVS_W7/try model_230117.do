* Last Updated: 2023. 01 .17
* File name: WVS_W7_modeling
* Data:  
* Subject: model try 

/***************************************************
                  model try 
***************************************************/
*設定工作路徑
cd "D:\Dropbox\學習\碩士\WVS_W7"

***************************************************
use "WVS_W7_data\WVSW7_clean_230117.dta",clear

/*

 社會-個人- 
 社會-個人+ 
 社會+個人- 
 社會+個人+ 

*/

gsem (i.nohope <- ///
      hdi gdpg v2xeg_eqdr ///    
	  b1.ageg3 b1.sclass ///
      male married children b1.edug3 b1.employment  ///
	  M1[B_COUNTRY]@1), mlogit latent(M1) nolog 
est store m1	  

program define value

mixed `1' ///
      hdi gdpg v2xeg_eqdr b1.nohope ///
	  b1.ageg3 b1.sclass ///
      male married children b1.edug3 b1.employment  ///
	  || B_COUNTRY: , mle nolog	  
est store m`2'

end  
	  
program define action

gsem (`1' <- ///
      hdi gdpg v2xeg_eqdr b1.nohope ///    
	  b1.ageg3 b1.sclass ///
      male married children b1.edug3 b1.employment  ///
	  M1[B_COUNTRY]@1), mlogit latent(M1) nolog 
est store m`2'

end  

value dem_import 2
value dem_country 3	  
value political_sta 4  

action Q209 5
action Q210 6
action Q211 7
action Q212 8
action cha_soc 9

***************************************************	  


esttab m2 m3 m4 using "WVS_W7_output/m234.csv" ///
       , b(3) se(3) nogaps nol nonum  nobase replace  ///
       transform(ln*: exp(2*@) exp(2*@) ) ///
       eqlabels("" "var(tenure)" "var(_cons)" "var(Residual)", none) ///
       varlabels(,elist(weight:_cons "{break}{hline @width}")) ///
       varwidth(10)	


program define mlogit_t
esttab m`1' using "WVS_W7_output/m`1'.csv" ///
       , b(3) se(3) nogaps nol nonum  nobase replace unstack  ///
       transform(ln*: exp(2*@) exp(2*@) ) ///
       eqlabels("" "var(tenure)" "var(_cons)" "var(Residual)", none) ///
       varlabels(,elist(weight:_cons "{break}{hline @width}")) ///
       varwidth(10)				  
end	

mlogit_t 1
mlogit_t 5
mlogit_t 6
mlogit_t 7
mlogit_t 8	
mlogit_t 9
   
***************************************************






