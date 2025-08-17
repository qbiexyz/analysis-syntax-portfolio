* Last Updated: 2023. 06. 01
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/


est clear


foreach x of num 70/105 {
	clear
	* 若是亂碼
	cd "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\10 data\家庭收支調查\\`x'"
	unicode encoding set Big5
	unicode translate "inc`x'.dta" , invalid(ignore) transutf8 nodata
	*刪除資料夾
	! rmdir /s/q "bak.stunicode"
}




foreach x of num 70/110 {
	cd "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\10 data\家庭收支調查\\`x'"
	use "inc`x'.dta", clear
	compress
	save, replace
}

cd "D:\Dropbox\工作\翠莪老師_work\poverty3\Old age poverty\10 data\家庭收支調查\88"
use "inc88.dta", clear