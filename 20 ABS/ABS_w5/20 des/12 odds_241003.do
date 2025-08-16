* Last Updated: 2024. 10 .01
* File name: []
* Data:ABSW5  
* Subject: data clean

/***************************************************
*                      ABSW5                      *
***************************************************/

cd "C:\Dropbox\工作\中研院_工作\! done\ABSW5 Attitudes toward China\"

use "10 data/Attitudes_toward_China.dta", clear


tab q174 ,nol

recode q174(1 = 0 "中")(4 = 1 "美")(* = .), gen(q174_2)


tab q174_2 if country_nm == "Taiwan"


foreach x in ///
"Australia" "China" "Hong_Kong" "India" "Indonesia" "Japan" ///
"Korea" "Malaysia" "Mongolia" "Myanmar" "Philippines" "Singapore" ///
"Taiwan" "Thailand" "Vietnam" {
	logistic q174_2 if country_nm == "`x'"
	est store m_`x'
}

esttab  m_* using "30 output\q174.csv" ///
			, b(3) se(3) obslast nogaps compress eform  ///
			nonum nobase mtitles order(_cons) append noparentheses 
			
logistic q174_2 if country_nm == "Australia"

esttab  m_Australia ///
			, b(3) se(3) obslast nogaps compress eform  ///
			nonum nobase mtitles order(_cons) append noparentheses 
			
			
			

tab q180 ,nol

recode q180(2 = 0 "中")(1 = 1 "美")(* = .), gen(q180_2)

recode q180(2 = 0 "中")(1 = 1 "美")(90/99 = .)(* = 3), gen(q180_3)

dtable i.q180_3 ///
     , by(country_nm, nototal) nosample fact(, stat(fvperc)) ///
	 nformat(%9.2f) sformat("%s%%" fvpercent) ///
	 export("30 output\123.xlsx",replace)
	
tab q180_2 if country_nm == "Taiwan"


/*"Japan"太少*/
foreach x in ///
"Australia" "China" "Hong_Kong" "India" "Indonesia"  ///
"Korea" "Malaysia" "Mongolia" "Myanmar" "Philippines" "Singapore" ///
"Taiwan" "Thailand" "Vietnam" {
	logistic q180_2 if country_nm == "`x'"
	est store m_`x'
}

esttab  m_* using "30 output\q180.csv" ///
			, b(3) se(3) obslast nogaps compress eform  ///
			nonum nobase mtitles order(_cons) append noparentheses 
			
logistic q174_2 if country_nm == "Australia"

esttab  m_Australia ///
			, b(3) se(3) obslast nogaps compress eform  ///
			nonum nobase mtitles order(_cons) append noparentheses 