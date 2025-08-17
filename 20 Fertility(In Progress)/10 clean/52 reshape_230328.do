* Last Updated: 2024. 03. 28
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/
/*
set maxvar 10000
do "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD\20 model\10 clean\10 cd_clean_240307.do"

do "20 model\10 clean\51 keep09t22_230331.do"
*/
/*****************************************
*                             *
******************************************/

/*************************************************************************

*************************************************************************/

reshape long ///
mar_status_ mar_change_ ///
child_num_ child_num0_  child_add_  ///
childwill_ childwill0_ childwill_sex_ achieved_ ///
age_  ///
cohabit_num_ Is_pa_or_gr_cohabit_ Is_pa_cohabit_ Is_gr_cohabit_ ///
R_work_status_ R_work_change_ R_work_statusD_ ///
SP_work_status_ SP_work_change_ SP_work_statusD_ ///
R_salarym_ R_salarymg_ SP_salarym_ SP_salarymg_ ///
R_workhour_ SP_workhour_ ///
R_health_ SP_health_ ///
R_on_housework_per_week_ SP_on_housework_per_week_ ///
, i(x01) j(year)

order ///
x01 year ///
mar_status_ mar_change_ ///
child_num_ child_num0_  child_reduce child_add_  ///
childwill_ childwill0_ childwill_sex_ achieved_ ///
R_male age30 age_ R_edu_max SP_edu_max ///
cohabit_num_ Is_pa_or_gr_cohabit_ Is_pa_cohabit_ Is_gr_cohabit_ siblings ///
R_work_status_ R_work_change_ R_work_statusD_ ///
SP_work_status_ SP_work_change_ SP_work_statusD_ ///
R_salarym_ R_salarymg_ SP_salarym_ SP_salarymg_ ///
R_workhour_ SP_workhour_ ///
R_health_ SP_health_ ///
family_value mom_work palive16 f_edu m_edu P_edu gender_prspct ///
R_on_housework_per_week_ SP_on_housework_per_week_


