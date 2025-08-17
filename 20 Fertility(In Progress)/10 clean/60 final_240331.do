* Last Updated: 2024. 03. 31
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/

/*************************************************************************

*************************************************************************/
do "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD\20 model\10 clean\51 keep09t22_230331.do"

do "20 model\10 clean\52 reshape_230328.do"
do "20 model\10 clean\53 label_230328.do"

compress
save "10 data\PSDF_09t22_analysis.dta" , replace
