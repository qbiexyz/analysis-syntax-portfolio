* Last Updated: 2023. 03. 04
* File name: [Youth Mental Health AI]model
* Data: Youth Mental Health AI
* Subject: try model 2C
/*****************************
*                  *
*****************************/

cd "D:\Dropbox\工作\杏容老師_work\Youth Mental Health AI"

*******************************************************************************
do "model\0 clean_230303.do"

est clear
program drop _all

/*******************************************************************************
                             program define
*******************************************************************************/

program define Q3_1new
	quietly reg `1' male b2.hinc3 ///
	            coping_pro_p coping_pro_n coping_emo_p coping_emo_n ///
				SupGet_emo SupGet_Tgb SupGet_info ///
				if `4' == 1
	est store I0Ma1`5'`8'
	
	quietly reg `1' male b2.hinc3 ///
	            coping_pro_p coping_pro_n coping_emo_p coping_emo_n ///
				SupGet_emo SupGet_Tgb SupGet_info ///
				`2' ///
				if `4' == 1
	est store Ma1`5'`6'`8'				
				
	quietly reg `1' male b2.hinc3 ///
	            coping_pro_p coping_pro_n coping_emo_p coping_emo_n ///
				SupGet_emo SupGet_Tgb SupGet_info ///
				`2' c.`2'#c.`3' ///
				if `4' == 1			
	est store i1`7'`5'`6'`8'					

end

/*******************************************************************************
                              try model2(reg)
*******************************************************************************/

/************************************
            
*************************************/

foreach x of global DV {
    foreach y of global IV {
	    foreach z of global MV_1_2 {
			foreach w of global dep3{
				Q3_1new $`x' $`y' $`z' $`w' `x' `y' `z' `w'
			}
		}
	} 
}

foreach x in D1 D2 {
	esttab I0Ma1`x'* using "output\try model 2\I0Ma1.csv" ///
		, b(3) se(3) r2 obslast nogaps compress ///
		nonum nobase  mtitles order(_cons) append
			  
	esttab Ma1`x'* using "output\try model 2\Ma1.csv" ///
		, b(3) se(3) r2 obslast nogaps compress ///
		nonum nobase  mtitles order(_cons) append	    
}


foreach x of global MV_1_2 {
	foreach y of global DV {
		esttab i1`x'`y'* using "output\try model 2\i1`x'_.csv" ///
			  , b(3) se(3) r2 obslast nogaps compress ///
			  nonum nobase  mtitles order(_cons) append	
	}
}


/************************************
            
*************************************/
/*
D1 1-6
D2 1-5
I 1-5
M1 1-4
M2 1-4
M3 1-6
M4 1-5

*/

*i1M11D1I2d3 i1M11D1I3d3
foreach x in I2 I3 {
	est restore i1M11D1`x'd3
	quietly margins, at($`x' =(1(1)5) coping_pro_p = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D1) xtitle(`x') ///
	             title("i1M11D1`x'd3") ylabel(1(1)6)
	graph export "output\try model 2\i1M11D1`x'd3.tif", width(1440) height(900) replace
}

*i1M11D2I1d3 i1M11D2I2d3 i1M11D2I3d3
foreach x in I1 I2 I3 {
	est restore i1M11D2`x'd3
	quietly margins, at($`x' =(1(1)5) coping_pro_p = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i1M11D2`x'd3") ylabel(1(1)5)
	graph export "output\try model 2\i1M11D2`x'd3.tif", width(1440) height(900) replace
}

*i1M12D2I2d1 i1M12D2I3d1
foreach x in I2 I3 {
	est restore i1M12D2`x'd1
	quietly margins, at($`x' =(1(1)5) coping_pro_n = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i1M12D2`x'd1") ylabel(1(1)5)
	graph export "output\try model 2\i1M12D2`x'd1.tif", width(1440) height(900) replace
}

*i1M13D1I2d3 i1M13D1I3d3
foreach x in I2 I3 {
	est restore i1M13D1`x'd3
	quietly margins, at($`x'=(1(1)5) coping_emo_p = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D1) xtitle(`x') ///
	             title("i1M13D1`x'd3") ylabel(1(1)6)
	graph export "output\try model 2\i1M13D1`x'd3.tif", width(1440) height(900) replace
}

*i1M13D2I1d1 
est restore i1M13D2I1d1
quietly margins, at(pre_aca =(1(1)5) coping_emo_p = (1, 2, 3, 4)) 
marginsplot, scheme(sj) noci ytitle(D2) xtitle(I1) ///
	         title("i1M13D2I1d1") ylabel(1(1)5)
graph export "output\try model 2\i1M13D2I1d1.tif", width(1440) height(900) replace

*i1M13D2I3d3
est restore i1M13D2I3d3
quietly margins, at(pre_per =(1(1)5) coping_emo_p = (1, 2, 3, 4)) 
marginsplot, scheme(sj) noci ytitle(D2) xtitle(I3) ///
	         title("i1M13D2I3d3") ylabel(1(1)5)
graph export "output\try model 2\i1M13D2I3d3.tif", width(1440) height(900) replace

*i1M14D2I1d1 i1M14D2I2d1 i1M14D2I3d1 
foreach x in I1 I2 I3 {
	est restore i1M14D2`x'd1
	quietly margins, at($`x' =(1(1)5) coping_emo_n = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i1M14D2`x'd1") ylabel(1(1)5)
	graph export "output\try model 2\i1M14D2`x'd1.tif", width(1440) height(900) replace
}

*i1M14D2I2d2
est restore i1M14D2I2d2
quietly margins, at(pre_job =(1(1)5) coping_emo_n = (1, 2, 3, 4)) 
marginsplot, scheme(sj) noci ytitle(D2) xtitle(I2) ///
	         title("i1M14D2I2d2") ylabel(1(1)5)
graph export "output\try model 2\i1M14D2I2d2.tif", width(1440) height(900) replace

*i1M14D2I1d3 i1M14D2I2d3 i1M14D2I3d3
foreach x in I1 I2 I3 {
	est restore i1M14D2`x'd3
	quietly margins, at($`x' =(1(1)5) coping_emo_n = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i1M14D2`x'd3") ylabel(1(1)5)
	graph export "output\try model 2\i1M14D2`x'd3.tif", width(1440) height(900) replace
}



