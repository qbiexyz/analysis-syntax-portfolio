* Last Updated: 2023. 07. 10
* File name: []
* Data: 
* Subject: Decomposition

/*****************************
*                            *
*****************************/
cd "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\"

******************************************************************************
est clear
/*
use "10 data\use data\7779_88110_230627.dta" ,clear
*/
use "10 data\y110_230711.dta" ,clear


/*****************************************************************************
                      查看各年度老年貧窮率
					  
*****************************************************************************/
preserve

keep if year == 79 | year == 89 | year == 99 | year == 109
tabstat poor1 poor2 poor3 poor4 poor5 ,by(year)

tabstat poor1 poor2 poor3 poor4 poor5 if age >= 65,by(year)
tabstat poor1 poor2 poor3 poor4 poor5 if age >= 60,by(year)

restore

/**********************************
## 
**********************************/

gen q1 = poor2 - poor3
gen q2 = poor3 - poor4
gen q3 = poor4 - poor5

preserve

keep if year == 89 | year == 109
keep if age >= 60

foreach x of var poor1 poor2 poor3 poor4 poor5{
	oaxaca `x'   ///
	     , by(year) weight(0) detail logit 
}  
restore

/**********************************
## 
/*

headfemale headeduc headage headmarried 
employment highedunum childnum 
old_60_num female educ headrelation hire year
*/
**********************************/
preserve

keep if year >= 89
keep if age >= 60

/*
logit poor1 ///
        yoy lgdpnt_cpi gdp_totalsocexp_  ///
	  b0.headmarried  headage b1.headeduc b0.headrelation ///
      highedunum employment  old_60_num childnum  ///
	  b0.hire5 
*/


bysort female: ///
melogit poor1 ///
        yoy lgni_cpi gdp_totalsocexp_ gdp_elder_ ///
	    b1.headmarried  headage b1.headeduc b0.headrelation ///
        highedunum employment old_60_num childnum ///
	    b0.hire5 ///
	    || year: 
		
restore


foreach x of var yoy lgni_cpi lgdpnt_cpi gdp_totalsocexp_ gdp_totalsocexpnoadmin_ gdp_elder_ {
	bysort female: ///
	melogit poor1 ///
        `x' ///
	    b1.headmarried  headage b1.headeduc b0.headrelation ///
        highedunum employment old_60_num childnum ///
	    b0.hire5 ///
	    || year: 
}

bysort female: ///
melogit poor1 ///
        gdp_elder_ ///
	    b1.headmarried  headage b1.headeduc b0.headrelation ///
        highedunum employment old_60_num childnum ///
	    b0.hire5 ///
	    || year: 


/*
yoy 
lgni_cpi male
lgdpnt_cpi male
gdp_totalsocexp_ male
gdp_totalsocexpnoadmin_  male
gdp_elder_ male
*/
