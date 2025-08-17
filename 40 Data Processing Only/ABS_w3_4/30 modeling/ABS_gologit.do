* Last Updated: 2022. 01 . 21
* File Name: ABSW3_4_modeling
* Data: Asian_barometer3
* Subject: gologit2

****************************


*****gologit2 - append data
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\ABSW3_4"
*/
cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"

use ABSW3_4_data/ABS34append.dta,clear

log using "ABSW3_4_output/220118表三gologit2.txt", text replace

sort country 
drop if protectworkern == .

gologit2 protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear  b0.employment_C ///
	   urban globalexposure if country == 4 ,nolog or autofit lrforce gamma 



gologit2 protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear  b0.employment ///
	   urban globalexposure if country==11,nolog or autofit lrforce gamma 



gologit2 protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear  b0.employment ///
	   urban globalexposure if country==12,nolog or autofit lrforce gamma 
	   
	   
gologit2 protectworkern wave4 collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear  b0.employment ///
	   urban globalexposure if country==8,nolog or autofit lrforce gamma 
	   

log close

/*
eststo m1: ///
esttab m1 using "output1.csv", b(3) pr2(3) eform nogap lab replace
*/



log using "ABSW3_4_output/220121wave34 china.txt", text replace

********************wave3********************
tab protectworkern if country ==8 & wave4 ==0
sum protectworkern if country ==8 & wave4 ==0

********************wave4********************
tab protectworkern if country ==8 & wave4 ==1
sum protectworkern if country ==8 & wave4 ==1

log close



*********gologit2 - W3 data
/*
cd "D:\Dropbox\qbiexyz\中研院_工作\ABSW3_4"
*/

cd "C:\Users\user\Desktop\中研院_工作\ABSW3_4"

use ABSW3_4_data/ABS_W3_220114_DependentV2.dta,clear

sort country 
drop if forgood_hurt == .


log using "ABSW3_4_output/220118表二gologit2.txt", text replace

*China

gologit2 forgood_hurt collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear b0.employment_C ///
	   urban globalexposure if country == 4 ,nolog or autofit lrforce gamma 

	

foreach i of numlist 11 12 8{
gologit2 forgood_hurt collectivism trustg truste b0.finc4n ///
	   ecofamily ecocountry male age eduyear b0.employment ///
	   urban globalexposure if country==`i',nolog or autofit lrforce gamma 
}

log close
