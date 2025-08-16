* Last Updated: 2023. 02. 24
* File name: [Youth Mental Health AI]model
* Data: Youth Mental Health AI
* Subject: try model
/*****************************
*                  *
*****************************/

cd "D:\Dropbox\工作\杏容老師_work\Youth Mental Health AI"

*******************************************************************************
do "model\0 clean_230303.do"

est clear
program drop _all


/*******************************************************************************
                              try model(anova)
*******************************************************************************/

log using "output\anova_永健_230224.txt" , text replace

/*
有顯著:
就業壓力
情感性支持(得到)
實質性支持(得到)
資訊性支持 (得到)
線上遊戲_追求成就
線上遊戲_社交
*/

foreach x in $DV $IV $MV{
	oneway $`x' depname3 , tab bonferroni scheffe
} 

log close

/*******************************************************************************
                             program define
*******************************************************************************/

program define Q3_1

	quietly reg `1' male b2.hinc3 `2'  if `3' == 1
	est store M00`4'`5'`6'

end

program define Q3_2

	quietly reg `1' male b2.hinc3 `2'  if `3' == 1
	est store I0`4'`5'`6'
	
end

program define Q3_3

	quietly reg `1' male b2.hinc3 `2' `3' c.`2'#c.`3' if `4' == 1
	est store m`5'`6'`7'`8'

end

/*******************************************************************************
                              try model(reg)
*******************************************************************************/

/************************************
            
*************************************/
/* 2*3*3 18*/
foreach x of global DV {
    foreach y of global IV {
	    foreach z of global dep{
		    Q3_1 $`x' $`y' $`z' `x' `y' `z'
		}
	} 
}

esttab  M00D1* using "output\M00_.csv" ///
      , b(3) se(3) r2 obslast nogaps compress ///
	    nonum nobase  mtitles order(_cons) append 

esttab  M00D2* using "output\M00_.csv" ///
      , b(3) se(3) r2 obslast nogaps compress ///
	    nonum nobase  mtitles order(_cons) append 
	  
est drop M00*

/************************************
            
*************************************/
/* 2*11*3 66*/
foreach x of global DV {
    foreach y of global MV {
	    foreach z of global dep{
		    Q3_2 $`x' $`y' $`z' `x' `y' `z'
		}
	} 
}


foreach x in D1 D2 {
	foreach y in M1 M2 M3 M4 {
		esttab  I0`x'`y'* using "output\I0`x'_.csv" ///
			, b(3) se(3) r2 obslast nogaps compress ///
			  nonum nobase  mtitles order(_cons) append
	}
}

est drop I0*

/************************************
            
*************************************/
/* 2*3*11*3 192 */
foreach x of global DV {
    foreach y of global IV {
	    foreach z of global MV{
		    foreach w of global dep{
			    Q3_3 $`x' $`y' $`z' $`w' `x' `y' `z' `w'
			}
		} 
	} 
}

foreach x of global DV{
	foreach y of global IV{
		esttab m`x'`y'M1* using "output\m`y'M1+_.csv" ///
			, b(3) se(3) r2 obslast nogaps compress ///
			nonum nobase  mtitles order(_cons) append 
			
		esttab m`x'`y'M2* using "output\m`y'M2+_.csv" ///
			, b(3) se(3) r2 obslast nogaps compress ///
			nonum nobase  mtitles order(_cons) append 
		esttab m`x'`y'M3* using "output\m`y'M30_.csv" ///
			, b(3) se(3) r2 obslast nogaps compress ///
			nonum nobase  mtitles order(_cons) append 			
		esttab m`x'`y'M4* using "output\m`y'M4+_.csv" ///
			, b(3) se(3) r2 obslast nogaps compress ///
			nonum nobase  mtitles order(_cons) append 			
	}
}	

est drop m*


/*******************************************************************************
                              try model(CFA)
*******************************************************************************/

log using "output\cfa_永健_230224.txt" , text replace

foreach x in Happiness_f5 Depress_f20 Pre_aca_f5 Pre_job_f6 Pre_per_f4 Coping_pro_p_f6 Coping_pro_n_f4 Coping_emo_p_f4 Coping_emo_n_f4 SupGet_emo_f9 SupGet_Tgb_f2 SupGet_info_f4 Mindfulness_f15  GameMoti_ach_f6 GameMoti_sco_f5 {
	sem (`x' -> $`x')
	estat gof, stats(all)
}

/*GameMoti_esc_f2 跑不出來*/

log close

