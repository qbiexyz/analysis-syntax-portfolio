* Last Updated: 2023. 07. 20
* File name: []
* Data: 
* Subject: Decomposition

/*****************************
*                            *
*****************************/

log using "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\30 output\try_gender_230720", replace

cd "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\"

******************************************************************************
est clear

use "10 data\y110_230711.dta" ,clear

* 保留89年後(才有社會支出占比)
*保留老年樣本
keep if year >= 89
keep if age >= 60


/*
yoy 
lgni_cpi male
lgdpnt_cpi male
gdp_totalsocexp_ male
gdp_totalsocexpnoadmin_  male
gdp_elder_ male
*/

* 中心化 後面加c
foreach x of var yoy lgni_cpi lgdpnt_cpi gdp_totalsocexp_  gdp_elder_ elder_socexp_ {
	sum `x' ,meanonly
	gen `x'c = `x' - r(mean)
}


* 男女分別單獨放各個單一指標
foreach x of var yoy lgni_cpi lgdpnt_cpi gdp_totalsocexp_  gdp_elder_ elder_socexp_ {
	bysort female: ///
	melogit poor1 ///
        `x' ///
	    b1.headmarried  headage b1.headeduc b0.headrelation ///
        highedunum employment old_60_num childnum ///
	    b0.hire5 ///
	    || year: 
}

* 單獨放各個單一指標+interaction

foreach x of var yoyc lgni_cpic lgdpnt_cpic gdp_totalsocexp_c gdp_elder_c elder_socexp_c {
	melogit poor1 ///
        `x' ///
	    b1.headmarried  headage b1.headeduc b0.headrelation ///
        highedunum employment old_60_num childnum ///
	    b0.hire5 i.female ///
		female#c.`x' ///
	    || year: 
	est store `x'_2
}

log close



est restore lgni_cpic_2
quietly margins , at(lgni_cpic =(-0.3(0.1)0.3) female = (0, 1)) nose  
marginsplot,   noci			

est restore gdp_totalsocexp_c_2
quietly margins , at(gdp_totalsocexp_c =(0.08(0.01)0.12) female = (0, 1)) nose  
marginsplot,   noci			



est restore gdp_elder_c_2
quietly margins , at(gdp_elder_c =(-0.01(0.001)0.01) female = (0, 1)) nose  
marginsplot,   noci			












