* Last Updated: 2023. 07. 14
* File name: [Youth Mental Health AI]model
* Data: Youth Mental Health AI
* Subject: try model 2D
/*****************************
*                  *
*****************************/

cd "D:\Dropbox\工作\杏容老師_work\Youth Mental Health AI"

*******************************************************************************
do "model\10 clean_230303.do"

recode depname3 (1 = 0 "文哲史")(3 = 1 "理工")(2 = .), gen(depname2)

est clear
program drop _all

/*****************************************************************************
                             program define
*****************************************************************************/

program define qq123
	 reg depress male b2.hinc3 ///
	            coping_pro_p coping_pro_n coping_emo_p coping_emo_n ///
				SupGet_emo SupGet_Tgb SupGet_info ///
				mindfulness depname2 /// 
				`1' , vce(robust)

	est store  	Ma2D2`2'
	
end

program define inter_3way_1
					
	 reg depress male b2.hinc3 ///
	            coping_pro_p coping_pro_n coping_emo_p coping_emo_n ///
				SupGet_emo SupGet_Tgb SupGet_info ///
				mindfulness ibn.depname2 ///
				ibn.depname2#(c.`1' c.`2' c.`1'#c.`2') ///
				, vce(robust) noconstant noci
	*est store 	inter3`4'D2`3'd1 
	
	*contrast b1.depname3#c.`1'#c.`2', nowald pveffects  

end

program define inter_3way_2
					
	 reg depress male b2.hinc3  ///
	        coping_pro_p coping_pro_n coping_emo_p coping_emo_n ///
		    SupGet_emo SupGet_Tgb SupGet_info ///
			mindfulness ///
			ibn.depname2##c.`1'##c.`2', vce(robust)

end

/*******************************************************************************
                              try model2(inter_3way)
*******************************************************************************/


global MV_inter3 "M13 M14 M30"

reg depress male b2.hinc3  /// 
	            coping_pro_p coping_pro_n coping_emo_p coping_emo_n ///
				SupGet_emo SupGet_Tgb SupGet_info ///
				mindfulness b3.depname3 , vce(robust) /*理工為參考*/ 

est store I0Ma2D2

foreach x of global IV {
	qq123 $`x' `x'
}

foreach x of global MV_inter3 {
    foreach y of global IV {
		inter_3way_1 $`y' $`x' `y' `x'		
	} 
}


foreach x of global MV_1_2_3 {
    foreach y of global IV {
		inter_3way_2 $`y' $`x'		
	} 
}



/************************************
理工科系與文史哲科系的
問題取向積極因應調節課業壓力對於憂鬱情緒的效果有何不同          
*************************************/

*沒平減
reg depress male b2.hinc3  ///
	 coping_pro_n coping_emo_p coping_emo_n ///
	SupGet_emo SupGet_Tgb SupGet_info ///
	mindfulness ///
	ibn.depname2##c.pre_aca##c.coping_pro_p, vce(robust)
	
quietly margins depname2, at(pre_aca =(1(1)5) coping_pro_p = (1(1)4))
marginsplot, bydimension(depname2) plotdimension(coping_pro_p, allsimple) ///
             byopts(title("兩個科系*課業壓力*問題取向積極因應->憂鬱情緒")) ///
			 ytitle("Y軸:憂鬱情緒") xtitle("X軸:課業壓力") ///
             legend(subtitle("問題取向積極因應") col(4)) noci
/*
*平減
sum pre_aca
gen c_pre_aca = pre_aca - r(mean)	
	
sum coping_pro_p
gen c_coping_pro_p = coping_pro_p - r(mean)		
	
reg depress male b2.hinc3  ///
	coping_pro_n coping_emo_p coping_emo_n ///
	SupGet_emo SupGet_Tgb SupGet_info ///
	mindfulness ///
	ibn.depname2##c.c_pre_aca##c.c_coping_pro_p, vce(robust)
*/

/************************************
理工科系與文史哲科系的
問題取向積極因應調節人際壓力對於憂鬱情緒的效果有何不同
*************************************/

*沒平減
reg depress male b2.hinc3  ///
	 coping_pro_n coping_emo_p coping_emo_n ///
	SupGet_emo SupGet_Tgb SupGet_info ///
	mindfulness ///
	ibn.depname2##c.pre_per##c.coping_pro_p, vce(robust)

quietly margins depname2, at(pre_per =(1(1)5) coping_pro_p = (1(1)4))
marginsplot, bydimension(depname2) plotdimension(coping_pro_p, allsimple) ///
             byopts(title("兩個科系*人際壓力*問題取向積極因應->憂鬱情緒")) ///
			 ytitle("Y軸:憂鬱情緒") xtitle("X軸:人際壓力") ///
             legend(subtitle("問題取向積極因應") col(4)) noci
			 

/*
*平減
sum pre_aca
gen c_pre_aca = pre_aca - r(mean)	
	
sum coping_pro_p
gen c_coping_pro_p = coping_pro_p - r(mean)		
	
reg depress male b2.hinc3  ///
	coping_pro_n coping_emo_p coping_emo_n ///
	SupGet_emo SupGet_Tgb SupGet_info ///
	mindfulness ///
	ibn.depname2##c.c_pre_aca##c.c_coping_pro_p, vce(robust)
*/
			 		 
/************************************
理工科系與文史哲科系的
情緒取向積極因應調節課業壓力對於憂鬱情緒的效果有何不同
*************************************/			
		 
reg depress male b2.hinc3  ///
	coping_pro_p coping_pro_n  coping_emo_n ///
	SupGet_emo SupGet_Tgb SupGet_info ///
	mindfulness ///
	ibn.depname2##c.pre_aca##c.coping_emo_p, vce(robust)

quietly margins depname2, at(pre_aca =(1(1)5) coping_emo_p = (1(1)4))
marginsplot, bydimension(depname2) plotdimension(coping_emo_p, allsimple) ///
             byopts(title("兩個科系*課業壓力*情緒取向積極因應->憂鬱情緒")) ///
			 ytitle("Y軸:憂鬱情緒") xtitle("X軸:課業壓力") ///
             legend(subtitle("情緒取向積極因應") col(4)) noci

/*
sum pre_aca
gen c_pre_aca = pre_aca - r(mean)	
	
sum coping_emo_p
gen c_coping_emo_pp = coping_emo_p - r(mean)			


reg depress male b2.hinc3  ///
	coping_pro_p coping_pro_n  coping_emo_n ///
	SupGet_emo SupGet_Tgb SupGet_info ///
	mindfulness ///
	b1.depname3##c.c_pre_aca##c.c_coping_emo_pp, vce(robust)
*/
			 
/************************************
理工科系與文史哲科系的
情緒取向積極因應調節人際壓力對於憂鬱情緒的效果有何不同
*************************************/	
				 
reg depress male b2.hinc3  ///
	coping_pro_p coping_pro_n  coping_emo_n ///
	SupGet_emo SupGet_Tgb SupGet_info ///
	mindfulness ///
	ibn.depname2##c.pre_per##c.coping_emo_p, vce(robust)

quietly margins depname2, at(pre_per =(1(1)5) coping_emo_p = (1(1)4))
marginsplot, bydimension(depname2) plotdimension(coping_emo_p, allsimple) ///
             byopts(title("兩個科系*人際壓力*情緒取向積極因應->憂鬱情緒")) ///
			 ytitle("Y軸:憂鬱情緒") xtitle("X軸:人際壓力") ///
             legend(subtitle("情緒取向積極因應") col(4)) noci


