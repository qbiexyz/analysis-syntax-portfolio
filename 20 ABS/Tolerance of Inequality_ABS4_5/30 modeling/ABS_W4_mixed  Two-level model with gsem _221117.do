	* Last Updated: 2022. 11 . 17
* File name: [ABS_W4_modeling]
* Data:ABS_W4_inter    
* Subject: Two-level model with gsem

/***************************************************
*                ABS_W4_分類                 *
***************************************************/

cd "D:\Dropbox\qbiexyz\中研院_工作\Asian Barometer Survey W4-東南亞收入不平等"

use ABS_W4_data/ABS_W4_inter_221117,clear


log using "ABS_W4_output/revise/221117 Two-level gsem.txt" , text replace 			


*****inc_fair
gsem (inc_fair <- improve inequality1 inequality2 inequality3 M1[country]) ///
     (improve <- inequality1 inequality2 inequality3 M2[country]), ///
	 cov(M1[country]*M2[country]@0)
*the indirect effect
nlcom _b[inc_fair:improve]*_b[improve:inequality1]
nlcom _b[inc_fair:improve]*_b[improve:inequality2]
nlcom _b[inc_fair:improve]*_b[improve:inequality3]

*****noinc_greduce
gsem (noinc_greduce <- improve inequality1 inequality2 inequality3 M1[country]) ///
     (improve <- inequality1 inequality2 inequality3 M2[country]), ///
	 cov(M1[country]*M2[country]@0) 
*the indirect effect
nlcom _b[noinc_greduce:improve]*_b[improve:inequality1]
nlcom _b[noinc_greduce:improve]*_b[improve:inequality2]
nlcom _b[noinc_greduce:improve]*_b[improve:inequality3]

*****norei
gsem (norei <- improve inequality1 inequality2 inequality3 M1[country]) ///
     (improve <- inequality1 inequality2 inequality3 M2[country]), ///
	 cov(M1[country]*M2[country]@0) 
*the indirect effect
nlcom _b[norei:improve]*_b[improve:inequality1]
nlcom _b[norei:improve]*_b[improve:inequality2]
nlcom _b[norei:improve]*_b[improve:inequality3]


log close		
