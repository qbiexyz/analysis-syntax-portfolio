* Last Updated: 2024. 03. 28
* File name: []
* Data: 
* Subject: 

/*****************************
*                            *
*****************************/

/*
cd "C:\Dropbox\工作\翠莪老師_work\fertility_PSFD"

use "10 data\PSDF_09t22_analysis.dta", clear
*/

lab def mar_status_ 0 "婚姻狀態者：過去已婚者、新已婚、同居、再婚" ///
                    1 "非婚姻狀態：未婚、離婚、分居、喪偶" ///
					2 "流失樣本：已婚成遺漏" ///
					3 "流失樣本：非婚成遺漏"
lab val mar_status_ mar_status_

lab def mar_change_ 0 "有有" 1 "有無" 2 "無有" 3 "無無"
lab val mar_change_ mar_change_

lab def childwill_ 0 "不想(再)生" 1 "想(再)生" 2 "不確定想不想(再)生"
lab val childwill_ childwill_
lab val childwill0_ childwill_

lab def childwill_sex_ 0 "不想(再)生" 1 "想(再)生男孩" 2 "想(再)生女孩" ///
                       3 "想(再)生都可以" 4 "不確定想不想(再)生"
lab val childwill_sex_ childwill_sex_

lab def R_male 0 "女" 1 "男"
lab val R_male  R_male 

lab def work_status_  0 "無工作" 1 "有工作" 2 "缺失" 3 "跳答" 
lab val R_work_status_  work_status_ 
lab val SP_work_status_  work_status_ 

lab def work_statusD_ 0 "無工作" 1 "典型" 2 "非典型(派遣、<=29 hrs/week)" ///
                      3 "缺失"
lab val R_work_statusD_ work_statusD_
lab val SP_work_statusD_ work_statusD_

lab def work_change_ 0 "有有" 1 "有無" 2 "無有" 3 "無無"  4 "缺失"
lab val R_work_change_  work_change_ 
lab val SP_work_change_  work_change_ 

lab def salarym_ 0 "0" 1 "低" 2 "中" 3 "高" 4 "缺失"
lab val R_salarymg_ salarym_
lab val SP_salarymg_ salarym_



/*
lab def work_status_with_dispatch_ ///
                   0 "典型" 1 "非典型(派遣、<35 hrs/week)" 2 "無工作"
lab val R_work_status_with_dispatch_  work_status_with_dispatch_ 
lab val SP_work_status_w_dispatch_  work_status_with_dispatch_ 
*/
lab def achieved_ 1 "不想(再)生/沒生" 2 "不想(再)生/生了" ///
                  3 "想(再)生/沒生" 4 "想(再)生/生了" ///
				  5 "不確定想不想(再)生/沒生" 6 "不確定想不想(再)生/生了" 
lab val achieved_ achieved_

lab def mom_work 0 "沒有、不知道、缺失" 1 "有"
lab val mom_work  mom_work 




lab var year "年"
lab var mar_status_ "婚姻狀況"
lab var mar_change_ "婚姻改變狀況"
lab var child_num_ "小孩數(差補)"
lab var child_num0_ "小孩數(沒差補)"
lab var child_reduce "小孩數填答有減少狀況"
lab var child_add_ "小孩數增加個數"
lab var childwill_ "打算(再)生小孩(不知道、拒答to缺失)"
lab var childwill0_ "打算(再)生小孩(不知道、拒答to不確定)"
lab var childwill_sex_ "打算(再)生小孩(包括性別)"
lab var R_male "男性"
lab var age_ "年齡"
lab var R_edu_max "受訪者最高教育年數"
lab var SP_edu_max "受訪者最高教育年數"
lab var cohabit_num_ "長輩數"
lab var Is_pa_or_gr_cohabit_ "有無長輩同居"
lab var Is_pa_cohabit_ "有無父母輩同居"
lab var Is_gr_cohabit_ "有無祖父母輩同居"
lab var siblings "手足數"

lab var R_work_status_ "受訪者工作狀態"
lab var R_work_change_ "受訪者工作狀態變化"
lab var R_work_statusD_ "受訪者工作狀態(典型)"

lab var SP_work_status_ "配偶工作狀態"
lab var SP_work_change_ "配偶工作狀態變化"
lab var SP_work_statusD_ "配偶工作狀態(典型)"

lab var R_salarymg_ "受訪者平均月收(分組)"
lab var SP_salarymg_ "配偶平均月收(分組)"
lab var R_salarym_ "受訪者平均月收"
lab var SP_salarym_ "配偶平均月收"

lab var R_workhour_ "受訪者工時"
lab var SP_workhour_ "配偶工時"
/*
lab var R_dispatch_status_ "受訪者兼差狀態"
lab var R_work_status_with_dispatch_ "受訪者工作狀態(是否典型)"
*/

/*
lab var SP_dispatch_status_ "配偶兼差狀態"
lab var SP_work_status_w_dispatch_ "配偶工作狀態(是否典型)"
*/


lab var R_health_ "受訪者自評健康"
lab var SP_health_ "配偶自評健康"
lab var family_value "家庭觀念(2009)"
lab var gender_prspct "性別態度(2010)"
lab var R_on_housework_per_week_ "受訪者家務時數"
lab var SP_on_housework_per_week_ "配偶家務時數"
lab var age30 "09年30歲以上"
lab var palive16 "16歲父母都健在"
lab var f_edu "父教育年數"
lab var m_edu "母教育年數"
lab var P_edu "父母教育年數(取高)"
lab var mom_work "16歲時母親有沒有工作"

lab var achieved_ "達成childwill"



