* Last Updated: 2023. 03. 15
* File name: [Youth Mental Health AI]model
* Data: Youth Mental Health AI
* Subject: try model 2E
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

program define Q3E_1new
	quietly reg `1' male b2.hinc3 ///
	            coping_pro_p coping_pro_n coping_emo_p coping_emo_n ///
				SupGet_emo SupGet_Tgb SupGet_info ///
				mindfulness ///
				GameMoti_esc GameMoti_ach GameMoti_sco ///
				if `4' == 1
	est store I0Ma3`5'`8'
	
	quietly reg `1' male b2.hinc3 ///
	            coping_pro_p coping_pro_n coping_emo_p coping_emo_n ///
				SupGet_emo SupGet_Tgb SupGet_info ///
				mindfulness ///
				GameMoti_esc GameMoti_ach GameMoti_sco ///
				`2' ///
				if `4' == 1
	est store Ma3`5'`6'`8'				
				
	quietly reg `1' male b2.hinc3 ///
	            coping_pro_p coping_pro_n coping_emo_p coping_emo_n ///
				SupGet_emo SupGet_Tgb SupGet_info ///
				mindfulness ///
				GameMoti_esc GameMoti_ach GameMoti_sco ///
				`2' c.`2'#c.`3' ///
				if `4' == 1			
	est store i3`7'`5'`6'`8'					

end

/*******************************************************************************
                              try model2(reg)
*******************************************************************************/

/************************************
            
*************************************/

foreach x of global DV {
    foreach y of global IV {
	    foreach z of global MV {
			foreach w of global dep3{
				Q3E_1new $`x' $`y' $`z' $`w' `x' `y' `z' `w'
			}
		}
	} 
}

foreach x in D1 D2 {
	esttab I0Ma3`x'* using "output\try model 2E\I0Ma3.csv" ///
		, b(3) se(3) r2 obslast nogaps compress ///
		nonum nobase  mtitles order(_cons) append
			  
	esttab Ma3`x'* using "output\try model 2E\Ma3.csv" ///
		, b(3) se(3) r2 obslast nogaps compress ///
		nonum nobase  mtitles order(_cons) append	    
}


foreach x of global MV {
	foreach y of global DV {
		esttab i3`x'`y'* using "output\try model 2E\i3`x'_.csv" ///
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

*i3M11D1I2d3
est restore i3M11D1I2d3
quietly margins, at(pre_job =(1(1)5) coping_pro_p = (1, 2, 3, 4)) 
marginsplot, scheme(sj) noci ytitle(D1) xtitle(I2) ///
	         title("i3M11D1I2d3") ylabel(1(1)6)
graph export "output\try model 2E\i3M11D1I2d3.tif" ///
             , width(1440) height(900) replace
			 
*i3M11D1I3d1
est restore i3M11D1I3d1
quietly margins, at(pre_per =(1(1)5) coping_pro_p = (1, 2, 3, 4)) 
marginsplot, scheme(sj) noci ytitle(D1) xtitle(I3) ///
	         title("i3M11D1I3d1") ylabel(1(1)6)
graph export "output\try model 2E\i3M11D1I3d1.tif" ///
             , width(1440) height(900) replace
			 
*i3M11D2I1d3 i3M11D2I2d3 i3M11D2I3d3
foreach x in I1 I2 I3 {
	est restore i3M11D2`x'd3
	quietly margins, at($`x' =(1(1)5) coping_pro_p = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i3M11D2`x'd3") ylabel(1(1)5)
	graph export "output\try model 2E\i3M11D2`x'd3.tif" ///
	              , width(1440) height(900) replace
}

*i3M12D2I3d1
est restore i3M12D2I3d1
quietly margins, at(pre_per =(1(1)5) coping_pro_n = (1, 2, 3, 4)) 
marginsplot, scheme(sj) noci ytitle(D2) xtitle(I3) ///
	         title("i3M12D2I3d1") ylabel(1(1)5)
graph export "output\try model 2E\i3M12D2I3d1.tif" ///
             , width(1440) height(900) replace

*i3M12D2I2d3  i3M12D2I3d3
foreach x in I2 I3 {
	est restore i3M12D2`x'd3
	quietly margins, at($`x' =(1(1)5) coping_pro_n = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i3M12D2`x'd3") ylabel(1(1)5)
	graph export "output\try model 2E\i3M12D2`x'd3.tif" ///
	              , width(1440) height(900) replace
}

*i3M13D1I1d2 i3M13D1I2d2 
foreach x in I1 I2 {
	est restore i3M13D1`x'd2 
	quietly margins, at($`x' =(1(1)5) coping_emo_p = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D1) xtitle(`x') ///
	             title("i3M13D1`x'd2") ylabel(1(1)6)
	graph export "output\try model 2E\i3M13D1`x'd2.tif" ///
	              , width(1440) height(900) replace
}

*i3M13D1I2d3 i3M13D1I3d3
foreach x in I2 I3 {
	est restore i3M13D1`x'd3 
	quietly margins, at($`x' =(1(1)5) coping_emo_p = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D1) xtitle(`x') ///
	             title("i3M13D1`x'd3") ylabel(1(1)6)
	graph export "output\try model 2E\i3M13D1`x'd3.tif" ///
	              , width(1440) height(900) replace
}

*i3M13D2I1d3 i3M13D2I2d3 i3M13D2I3d3
foreach x in I1 I2 I3 {
	est restore i3M13D2`x'd3 
	quietly margins, at($`x' =(1(1)5) coping_emo_p = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i3M13D2`x'd3") ylabel(1(1)5)
	graph export "output\try model 2E\i3M13D2`x'd3.tif" ///
	              , width(1440) height(900) replace
}

*i3M14D2I1d1 i3M14D2I3d1
foreach x in I1 I3 {
	est restore i3M14D2`x'd1 
	quietly margins, at($`x' =(1(1)5) coping_emo_n = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i3M14D2`x'd1") ylabel(1(1)5)
	graph export "output\try model 2E\i3M14D2`x'd1.tif" ///
	              , width(1440) height(900) replace
}

*i3M14D2I1d3 i3M14D2I3d3
foreach x in I1 I3 {
	est restore i3M14D2`x'd3 
	quietly margins, at($`x' =(1(1)5) coping_emo_n = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i3M14D2`x'd3") ylabel(1(1)5)
	graph export "output\try model 2E\i3M14D2`x'd3.tif" ///
	              , width(1440) height(900) replace
}

*i3M21D2I1d3 i3M21D2I2d3
foreach x in I1 I2 {
	est restore i3M21D2`x'd3 
	quietly margins, at($`x' =(1(1)5) SupGet_emo = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i3M21D2`x'd3") ylabel(1(1)5)
	graph export "output\try model 2E\i3M21D2`x'd3.tif" ///
	              , width(1440) height(900) replace
}

*i3M23D2I1d3 i3M23D2I2d3
foreach x in I1 I2 {
	est restore i3M23D2`x'd3 
	quietly margins, at($`x' =(1(1)5) SupGet_info = (1, 2, 3, 4)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i3M23D2`x'd3") ylabel(1(1)5)
	graph export "output\try model 2E\i3M23D2`x'd3.tif" ///
	              , width(1440) height(900) replace
}

*i3M30D1I1d2
est restore i3M30D1I1d2
quietly margins, at(pre_aca =(1(1)5) mindfulness = (1, 2, 3, 4, 5, 6)) 
marginsplot, scheme(sj) noci ytitle(D1) xtitle(I1) ///
	         title("i3M30D1I1d2") ylabel(1(1)6)
graph export "output\try model 2E\i3M30D1I1d2.tif" ///
             , width(1440) height(900) replace
			 
*i3M30D2I1d1 i3M30D2I2d1 i3M30D2I3d1
foreach x in I1 I2 I3{
	est restore i3M30D2`x'd1 
	quietly margins, at($`x' =(1(1)5) mindfulness = (1, 2, 3, 4, 5, 6)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i3M30D2`x'd1") ylabel(1(1)5)
	graph export "output\try model 2E\i3M30D2`x'd1.tif" ///
	              , width(1440) height(900) replace
}

*i3M30D2I1d3 i3M30D2I2d3 i3M30D2I3d3
foreach x in I1 I2 I3{
	est restore i3M30D2`x'd3 
	quietly margins, at($`x' =(1(1)5) mindfulness = (1, 2, 3, 4, 5, 6)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i3M30D2`x'd3") ylabel(1(1)5)
	graph export "output\try model 2E\i3M30D2`x'd3.tif" ///
	              , width(1440) height(900) replace
}

*i3M41D1I1d2 
est restore i3M41D1I1d2
quietly margins, at(pre_aca =(1(1)5) GameMoti_esc = (1, 2, 3, 4, 5)) 
marginsplot, scheme(sj) noci ytitle(D1) xtitle(I1) ///
	         title("i3M41D1I1d2") ylabel(1(1)6)
graph export "output\try model 2E\i3M41D1I1d2.tif" ///
             , width(1440) height(900) replace
			
*i3M41D2I1d1 i3M41D2I2d1 i3M41D2I3d1
foreach x in I1 I2 I3{
	est restore i3M41D2`x'd1 
	quietly margins, at($`x' =(1(1)5) GameMoti_esc = (1, 2, 3, 4, 5)) 
	marginsplot, scheme(sj) noci ytitle(D2) xtitle(`x') ///
	             title("i3M41D2`x'd1") ylabel(1(1)5)
	graph export "output\try model 2E\i3M41D2`x'd1.tif" ///
	              , width(1440) height(900) replace
}

*i3M41D2I1d3 
est restore i3M41D2I1d3
quietly margins, at(pre_aca =(1(1)5) GameMoti_esc = (1, 2, 3, 4, 5)) 
marginsplot, scheme(sj) noci ytitle(D2) xtitle(I1) ///
	         title("i3M41D2I1d3") ylabel(1(1)5)
graph export "output\try model 2E\i3M41D2I1d3.tif" ///
             , width(1440) height(900) replace

*i3M42D1I1d2 
est restore i3M42D1I1d2
quietly margins, at(pre_aca =(1(1)5) GameMoti_ach = (1, 2, 3, 4, 5)) 
marginsplot, scheme(sj) noci ytitle(D1) xtitle(I1) ///
	         title("i3M42D1I1d2") ylabel(1(1)6)
graph export "output\try model 2E\i3M42D1I1d2.tif" ///
             , width(1440) height(900) replace
			 
*i3M42D1I3d3
est restore i3M42D1I3d3
quietly margins, at(pre_per =(1(1)5) GameMoti_ach = (1, 2, 3, 4, 5)) 
marginsplot, scheme(sj) noci ytitle(D1) xtitle(I3) ///
	         title("i3M42D1I3d3") ylabel(1(1)6)
graph export "output\try model 2E\i3M42D1I3d3.tif" ///
             , width(1440) height(900) replace
			 
*i3M42D2I2d1
est restore i3M42D2I2d1
quietly margins, at(pre_job =(1(1)5) GameMoti_ach = (1, 2, 3, 4, 5)) 
marginsplot, scheme(sj) noci ytitle(D2) xtitle(I2) ///
	         title("i3M42D2I2d1") ylabel(1(1)5)
graph export "output\try model 2E\i3M42D2I2d1.tif" ///
             , width(1440) height(900) replace
