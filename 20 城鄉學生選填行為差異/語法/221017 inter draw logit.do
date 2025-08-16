*Last Update : 2022.10.17
*Filename : [rc_modeling][偏鄉]221017 inter draw logit
*Data:
*Subject:inter draw logit


cd "C:\Users\qbieqbiexyz\Desktop\rc"
******************************************************************************
sysdir set PLUS "D:\stata_pkgs\plus"
use "rc_data\tscs_lv7\analysis_clear_only_1017.dta",clear


/**************************************************************************************
******************************      國英數連續圖     ************************************
**************************************************************************************/

program drop _all 
program define draw1
preserve
drop if hs_type1 == `2'
melogit `1'  male lictyp retest chimiss engmiss mathmiss ///
					 grade b1.rural_3 b1.hscity4 sschpub rural_3#c.grade  ///
					 || sschcd3: grade,vce(robust)  
					 
margins rural_3,at(grade=(0(1)15))
marginsplot ,scheme(sj) noci ytitle(`3', margin(small)) xtitle(國英數平均) ///
             title(`3' 國英數平均x偏鄉3類 `4' ,margin(medsmall)) ///
             ylabel(`5'(`6')`7') legend(cols(3)) ///
			 recast(line)  ///
			 plot1opts(lcolor(navy) lpattern("_-"))  plot2opts(lcolor(midgreen) lpattern(dash))  ///
			 plot3opts(lcolor(maroon))  
graph export "C:\Users\qbieqbiexyz\Desktop\rc\rc_output\偏鄉\out1017_永健\draw\ draw `3' 國英數平均x偏鄉3類 `4'_output1017.tif"

restore
est clear
end

/*
program drop draw_gradec 
ylabel(`5'(`6')`7') 
*/
*顯著
draw1 fill6 0 "填滿6志願" "純普高" 0 0.2 1
draw1 pass1st_1 0 "志願一階大多數都通過" "純普高" 0 0.2 1

*沒顯著
draw1 allpub 0 "全選公立大學" "純普高" 0 0.2 1
draw1 pub1 0 "選公立大學佔大多數 " "純普高" 0 0.2 1
draw1 nocancel 0 "有被分發且沒放棄" "純普高" 0 0.2 1


/*
draw1 fill6 . "填滿6志願" "高中類型全" 0 0.2 1
draw1 fill6 1 "填滿6志願" "非普高" 0 0.2 1

draw1 allpub . "全選公立大學" "高中類型全" 0 0.2 1
draw1 allpub 1 "全選公立大學" "非普高" 0 0.2 1

draw1 nocancel . "有被分發且沒放棄1" "高中類型全" 0 0.2 1
draw1 nocancel 1 "有被分發且沒放棄1" "非普高" 0 0.2 1
*/

program drop _all 
program define draw3
preserve
drop if hs_type1 == `2'
melogit `1'  male lictyp retest chimiss engmiss mathmiss fill6 ///
					 grade b1.rural_3 b1.hscity4 sschpub rural_3#c.grade  ///
					 || sschcd3: grade,vce(robust)  
					 
margins rural_3,at(grade=(0(1)15))
marginsplot ,scheme(sj) noci ytitle(`3', margin(small)) xtitle(國英數平均) ///
             title(`3' 國英數平均x偏鄉3類 `4' ,margin(medsmall)) ///
             ylabel(`5'(`6')`7') legend(cols(3)) ///
			 recast(line)  ///
			 plot1opts(lcolor(navy) lpattern("_-"))  plot2opts(lcolor(midgreen) lpattern(dash))  ///
			 plot3opts(lcolor(maroon))  
graph export "C:\Users\qbieqbiexyz\Desktop\rc\rc_output\偏鄉\out1017_永健\draw\ draw `3' 國英數平均x偏鄉3類 `4'_output1017.tif"
restore
est clear
end

*顯著
draw3 pub1 0 "選公立大學佔大多數 (fill6)" "純普高" 0 0.2 1
draw3 pass1st_1 0 "志願一階大多數都通過(fill6)" "純普高" 0 0.2 1

*沒顯著
draw3 allpub 0 "全選公立大學(fill6)" "純普高" 0 0.2 1
draw3 nocancel 0 "有被分發且沒放棄(fill6)" "純普高" 0 0.2 1


