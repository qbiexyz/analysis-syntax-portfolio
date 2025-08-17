* Last Updated: 2024. 09. 01
* File name: []
* Data: tigps_w2
* Subject: 


/*****************************
*                            *
*****************************/

cd "C:\Dropbox\工作\杏容老師_work\TIGPS_w2"

**************************************************************************
est clear

use "10 data\tigps_w2.dta", clear

do "20 model\10 clean\20 國八期中報告分析計畫\01 霸凌變項_240830.do"
do "20 model\10 clean\20 國八期中報告分析計畫\02 其他變項_240830.do"
do "20 model\10 clean\20 國八期中報告分析計畫\03 保留變項_240830.do"



tab1 br_v br_a bc_v bc_a

tab1 br_4 bc_4


tab br_4 female, chi col nof
tab bc_4 female, chi col nof

tab br_4 pmarital, chi col nof
tab bc_4 pmarital, chi col nof

		  
***Anova
oneway WHO5 br_4, tab bonferroni scheffe
oneway WHO5 bc_4, tab bonferroni scheffe


oneway CESDR10 br_4, tab bonferroni scheffe
oneway CESDR10 bc_4, tab bonferroni scheffe

asdoc pwcorr ///
		  CESDR9 CESDR10 EVENT HARDINESS DCOP CR ES ///
		  FAMSUPPORT TEASUPPORT CLASUPPORT PSFRIEND ///
		  , star(all) ///
		  save(30 output\cor1)


asdoc pwcorr ///
		  CESDR9 CESDR10 BR_FV BC_FV IA SCHDELIN DCOP CR ES ///
		  FAMSUPPORT TEASUPPORT CLASUPPORT PSFRIEND ///
		  , star(all) ///
		  save(30 output\cor1)

asdoc pwcorr ///
		  CESDR9 CESDR10 BR_FA BC_FA ///
		  , star(all) ///
		  save(30 output\cor1)

asdoc pwcorr ///
		  CESDR9 CESDR10 ls ACCESS2 MEDIALIT ///
		  , star(all) ///
		  save(30 output\cor1)

asdoc pwcorr ///
		  CESDR10 BR_FV BR_FA BC_FV BC_FA  ///
		  IA SCHDELIN DCOP CR ES ///
		  FAMSUPPORT TEASUPPORT CLASUPPORT PSFRIEND ///
		  , star(all) ///
		  save(30 output\cor1)

		  
pwcorr ///
		   CESDR10 EVENT HARDINESS DCOP CR ES ///
		  FAMSUPPORT TEASUPPORT CLASUPPORT PSFRIEND ///
		  , sig


desctable ///
	i.event_1 i.event_2 i.event_3 i.event_4 i.event_5 i.event_6 i.event_7 ///
	i.event_8 i.event_9 i.event_10 i.event_11 i.event_12 i.event_13 EVENT ///
	cr_1 cr_2 cr_3 es_4 es_5 es_6 CR ES ///
	,filename("30 output\des") ///
	stats(n mean sd min max )

t2docx BR_FV BR_FA BC_FV BC_FA EVENT CR ES CRESA PROSOCIAL ///
        using "30 output\ttest.docx" ///
		, replace by(female) 










replace br_4 = . if br_4 == 4
replace bc_4 = .  if bc_4 == 4

tab br_4 female, chi col 
tab bc_4 female, chi col 

tab br_4 pmarital, chi col 
tab bc_4 pmarital, chi col 

oneway WHO5 br_4, tab bonferroni scheffe
oneway WHO5 bc_4, tab bonferroni scheffe

oneway CESDR10 br_4, tab bonferroni scheffe
oneway CESDR10 bc_4, tab bonferroni scheffe

