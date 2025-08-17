* Last Updated: 2022. 01 . 18
* File Name: ABSW3_4_modeling
* Data: Asian_barometer3
* Subject: Multiple Imputation

****************************

cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\ABSW3_4"
*/
use ABSW3_4_data/ABS_W3_220114_DependentV2.dta,clear


sort country 
drop if forgood_hurt == .


bys country:mvpatterns ///
    forgood_hurt collectivism trustg loyal ecofamily ecocountry   ///
	male edu urban globalexposure
drop if male == . | eduyear == .| ecofamily == . | ecocountry == .  ///
        | urban == . | globalexposure == .



misstable sum, gen(miss_)

mi set wide

log using "ABSW3_4_output/220116表二 .txt", text replace


*China
preserve
keep if country == 4
mi register regular ///
   forgood_hurt finc4n ecofamily ecocountry male age eduyear ///
   employment_C urban globalexposure
mi register imputed collectivism trustg truste

mi impute chained (regress) collectivism trustg truste == ///
   forgood_hurt finc4n ecofamily ecocountry male age eduyear  ///
   employment_C urban globalexposure, ///
    add(10) rseed(27898124) replace
eststo m4: ///
mi estimate,or: ologit forgood_hurt collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear b0.employment_C ///
	   urban globalexposure ,nolog 
	   
esttab * using "220121表二 impute.csv",  eform nogap nobase longtable  lab replace
restore


foreach i of numlist 11 12 8{
preserve
keep if country==`i'
mi register regular ///
   forgood_hurt finc4n ecofamily ecocountry male age eduyear employment ///
   urban globalexposure
mi register imputed collectivism trustg truste

mi impute chained (regress) collectivism trustg truste == ///
   forgood_hurt finc4n ecofamily ecocountry male age eduyear employment ///
   urban globalexposure, ///
    add(10) rseed(27898124) replace

mi estimate,or: ologit forgood_hurt collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear b0.employment ///
	   urban globalexposure ,nolog 
restore
}
log close



log close



*********no impute

cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\ABSW3_4"
*/
use ABSW3_4_data/ABS_W3_220114_DependentV2.dta,clear

sort country 
drop if forgood_hurt == .


log using "ABSW3_4_output/220118表二 no impute.txt", text replace

*China
eststo m4: ///
ologit forgood_hurt collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear b0.employment_C ///
	   urban globalexposure if country == 4 ,nolog or

	
foreach i of numlist 11 12 8{
eststo m`i': //
ologit forgood_hurt collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear b0.employment ///
	   urban globalexposure if country==`i',nolog or
}

esttab * using "220121表二no impute.csv", b(3) pr2(3) eform nogap nobase lab replace


log close

