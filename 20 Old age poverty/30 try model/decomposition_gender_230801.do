* Last Updated: 2023. 07. 20
* File name: []
* Data: 
* Subject: Decomposition

/*****************************
*                            *
*****************************/

*log using "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\30 output\try_gender_230720", replace

cd "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\"

******************************************************************************
est clear

use "10 data\y110_230711.dta" ,clear

/*****************************************************************************
                      查看各年度老年貧窮率
					  
*****************************************************************************/

keep if age >= 60

preserve

keep if year == 79 | year == 95 | year == 98 | year == 99 ///
      | year == 101 | year == 109

tabstat poor1 poor2 poor3 poor4 poor5 if age >= 60, by(year)

tabstat poor1 poor2 poor3 poor4 poor5 if age >= 60 & female == 1, by(year)

tabstat poor1 poor2 poor3 poor4 poor5 if age >= 60 & female == 0, by(year)

restore

/**********************************
1990 2006 2009 2010 2012 2020
**********************************/
foreach x of num 79 95 98 99 101{
	gen y109_`x' = .
	replace y109_`x' = 0 if year == 109
	replace y109_`x' = 1 if year == `x'
}

gen y109 = 1 if year == 109
	

/**********************************

**********************************/

foreach x of var y109_79 y109_95 y109_98 y109_99 y109_101{
	foreach y of var poor1 poor2 poor3 poor4 poor5{
		oaxaca `y'  ///
		      , by(`x') weight(0) detail logit
			  
		oaxaca `y' if female == 1  ///
		      , by(`x') weight(0) detail logit 
			 
		oaxaca `y' if female == 0  ///
		      , by(`x') weight(0) detail logit 
	}
}


foreach x of var y109_79 y109_95 y109_98 y109_99 y109_101 y109{
	foreach y of var poor1 poor2 poor3 poor4 poor5{
		oaxaca `y' if `x' == 1  ///
		      , by(female) weight(0) detail logit 
	}
}






