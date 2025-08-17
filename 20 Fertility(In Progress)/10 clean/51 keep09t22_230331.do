* Last Updated: 2024. 03. 31
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/


do "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD\20 model\10 clean\10 cd_clean_240307.do"

keep if x01b_2018 == 4

do "20 model\10 clean\11 mar_status_240307.do"
do "20 model\10 clean\12 child_num_240210.do"
do "20 model\10 clean\13 child_add_240210.do"
do "20 model\10 clean\14 childwill_240307.do"
do "20 model\10 clean\15 achieved_240412.do"
do "20 model\10 clean\21 gender_240310.do"
do "20 model\10 clean\22 age_240310.do"
do "20 model\10 clean\23 edu_240325.do"
do "20 model\10 clean\24 cohabit_240325.do"
do "20 model\10 clean\31 work_240328.do"
do "20 model\10 clean\32 salary_240318.do"
do "20 model\10 clean\33 dispatch_240328.do"
do "20 model\10 clean\41 health_240318.do"
do "20 model\10 clean\42 fmly_gndr_scales_240318.do"
do "20 model\10 clean\43 housework_240318.do"


/*****************************************
*                             *
******************************************/

/*************************************************************************

*************************************************************************/
drop *_n2016
drop *_2024

keep ///
x01 ///
mar_status_* mar_change_* ///
child_num_* child_num0_* child_reduce child_add_* ///
childwill_* childwill0_* childwill_sex_* achieved_* ///
R_male age30 age_* R_edu_max SP_edu_max ///
cohabit_num_* Is_pa_or_gr_cohabit_* Is_pa_cohabit_* Is_gr_cohabit_* siblings ///
R_work_status_* R_work_change_* R_work_statusD_* ///
SP_work_status_* SP_work_change_* SP_work_statusD_* ///
R_salarym_* R_salarymg_* SP_salarym_* SP_salarymg_* ///
R_workhour_* SP_workhour_* ///
R_health_* SP_health_* ///
family_value mom_work palive16 f_edu m_edu P_edu gender_prspct ///
R_on_housework_per_week_* SP_on_housework_per_week_*

order ///
x01 ///
mar_status_* mar_change_* ///
child_num_* child_num0_* child_reduce child_add_*  ///
childwill_* childwill0_* childwill_sex_* achieved_* ///
R_male age30 age_* R_edu_max SP_edu_max ///
cohabit_num_* Is_pa_or_gr_cohabit_* Is_pa_cohabit_* Is_gr_cohabit_* siblings ///
R_work_status_* R_work_change_* R_work_statusD_* ///
SP_work_status_* SP_work_change_* SP_work_statusD_* ///
R_salarym_* R_salarymg_* SP_salarym_* SP_salarymg_* ///
R_workhour_* SP_workhour_* ///
R_health_* SP_health_* ///
family_value mom_work palive16 f_edu m_edu P_edu gender_prspct ///
R_on_housework_per_week_* SP_on_housework_per_week_*

compress
save "10 data\PSDF_09t22_wide.dta" , replace

