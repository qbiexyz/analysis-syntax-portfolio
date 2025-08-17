* Last Updated: 2022. 01 . 21 
* File Name: ABSW3_4_modeling
* Data: Asian_barometer3
* Subject: Multiple Imputation

****************************
/*
cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"
*/
cd "D:\Dropbox\qbiexyz\中研院_工作\ABSW3_4"

use ABSW3_4_data/ABS34append.dta,clear


sort country 
drop if protectworkern == .


bys country:mvpatterns ///
    protectworkern collectivism trustg truste ecofamily ecocountry   ///
	male edu urban globalexposure
drop if male == . | eduyear == .| ecofamily == . | ecocountry == .  ///
        | urban == . | globalexposure == .



misstable sum, gen(miss_)

mi set wide

log using "ABSW3_4_output/220116表三3+4 .txt", text replace


*China
preserve
keep if country == 4
mi register regular ///
   protectworkern wave4 finc4n ecofamily ecocountry male age eduyear ///
   employment_C urban globalexposure
mi register imputed collectivism trustg truste

mi impute chained (regress) collectivism trustg truste == ///
   protectworkern wave4 finc4n ecofamily ecocountry male age eduyear   ///
   employment_C urban globalexposure, ///
    add(10) rseed(27898124) replace

mi estimate,or: ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear  b0.employment_C ///
	   urban globalexposure ,nolog 
	   
restore


foreach i of numlist 11 12 8{
preserve
keep if country==`i'
mi register regular ///
   protectworkern wave4 finc4n ecofamily ecocountry male age eduyear  employment ///
   urban globalexposure
mi register imputed collectivism trustg truste

mi impute chained (regress) collectivism trustg truste == ///
   protectworkern wave4 finc4n ecofamily ecocountry male age eduyear  employment ///
   urban globalexposure, ///
    add(10) rseed(27898124) replace

mi estimate,or: ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear  b0.employment ///
	   urban globalexposure ,nolog 
restore
}
log close



*****no impute
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\ABSW3_4"
*/
cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4

use ABSW3_4_data/ABS34append.dta,clear

log using "ABSW3_4_output/220118表三no impute.txt", text replace

sort country 
drop if protectworkern == .

eststo m4: ///
ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear  b0.employment_C ///
	   urban globalexposure if country == 4 ,nolog or 

foreach i of numlist 11 12 8 {
eststo m`i': //
ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear  b0.employment ///
	   urban globalexposure if country==`i',nolog or
}

ologit protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear  b0.employment ///
	   urban globalexposure if country==8,nolog or
	   
esttab * using "220121表三no impute1.csv", b(3) pr2(3) eform nogap nobase lab replace

log close

/*
eststo m1: ///
esttab m1 using "output1.csv", b(3) pr2(3) eform nogap lab replace
*/

