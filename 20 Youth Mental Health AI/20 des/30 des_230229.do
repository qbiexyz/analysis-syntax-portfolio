* Last Updated: 2023. 02. 29
* File name: [Youth Mental Health AI]model
* Data: Youth Mental Health AI
* Subject: des
/*****************************
*                  *
*****************************/

cd "D:\Dropbox\工作\杏容老師_work\Youth Mental Health AI"

*******************************************************************************
do "model\0. clean_230229.do"

est clear
program drop _all


/*******************************************************************************
                              des
*******************************************************************************/

log using "output\背景變項、社團參與初步描述統計_永健_230229.txt" , text replace


tab1 depname3 male hinc3,m

tab1 p12q8c1 - p12s2t1,m


log close

