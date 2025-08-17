* Last Updated: 2023. 05. 10
* File name: [tscs0818_modeling]
* Data:tscs08 18  
* Subject: gen social distance
* qbie


cd "D:\Dropbox\工作\中研院_工作\0 共享\全球跨界與社會距離\社會距離"

/***************************************************
*                    draw                      *
***************************************************/

clear

gen t2008m =.
replace t2008m = dis_mean if  year == 2008

gen t2018m =.
replace t2018m = dis_mean if  year == 2018


lab def country 7 "日本" 6 "韓國" 5 "中國" 4"香港" 3 "東南亞" 2 "北美" 1 "歐洲"
lab val country country

save social_dis_draw.dta

use tscs0818_data\social_dis_draw.dta,clear

#delimit ;
twoway bar t2008m country, horizontal bfc(dis_mean) blc(dis_mean) ||
bar t2018m country, horizontal bfc(dis_mean) blc(dis_mean) ||
scatter country zero, mlabel(country) mlabcolor(black) msymbol(none)
title("台灣人對外國人的社會距離")
xtitle("") ytitle("")
ytitle("") yscale(noline) ylabel(none)
xlabel( -3 "3" -2 "2" -1"1" 0 1(1)3)
legend(order(1 "2008" 2 "2018"));
#delimit cr
/*還有經過調顏色 Navy Maroon */
graph export "tscs0818_output\Occupational Pyramid.tif", width(1440) height(900) replace
