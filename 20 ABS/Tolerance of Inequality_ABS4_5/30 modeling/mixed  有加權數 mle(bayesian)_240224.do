* Last Updated: 2025. 02. 24
* File name: [ABSW5]
* Data: 亞洲民主動態調查
* Subject: 

/*****************************
*                  *
*****************************/
*設定工作路徑
cd "C:\Dropbox\工作\中研院_工作\Tolerance of Inequality_ABS4_5"

****************************************************************************
est clear
do "20 model\10 clean\W4_d_240111.do"


log using "30 output/表2_不平等容忍的多層次分析(Wave 4).txt" , text replace
****************************************************************************
* 收入分配很公平 - 經濟成長率互動
****************************************************************************
bayes, melabel: ///
mixed inc_tor lgni gdpgc gini country_Socialist ///
	  b4.inequality_all improve ///
	  male age edu b1.fincq sclass ///
	  inequality_all#c.gdpgc ///
		|| country: ,  cov(unstr) 

****************************************************************************
* 收入分配很公平 - 基尼指數互動
****************************************************************************
bayes, melabel: ///
mixed inc_tor lgni gdpg ginic country_Socialist ///
	  b4.inequality_all improve ///
	  male age edu b1.fincq sclass ///
	  inequality_all#c.ginic ///
		|| country: , cov(unstr) 

****************************************************************************
*政府不必去減少貧富差距  - 經濟成長率互動
****************************************************************************
bayes, melabel: ///
mixed noinc_greduce lgni gdpgc gini country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
	  inequality_all#c.gdpgc ///
		|| country: , cov(unstr)

****************************************************************************
*政府不必去減少貧富差距  - 社會主義國家互動
****************************************************************************
bayes, melabel: ///
mixed noinc_greduce lgni gdpg gini country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
	  inequality_all#c.country_Socialist ///
		|| country: , cov(unstr)

log close



****************************************************************************
est clear
clear
do "20 model\10 clean\W5_d_240111.do"

log using "30 output/表2_不平等容忍的多層次分析(Wave 5).txt" , text replace
****************************************************************************
* 收入分配很公平 
****************************************************************************
bayes, melabel: ///
mixed inc_tor lgni gdpg gini country_Socialist ///
	  b4.inequality_all improve ///
	  male age edu b1.fincq sclass ///
		|| country: , cov(unstr)


****************************************************************************
*政府不必去減少貧富差距  - 基尼指數互動
****************************************************************************
bayes, melabel: ///
mixed noinc_greduce lgni gdpg ginic country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
	  inequality_all#c.ginic ///
		|| country: , cov(unstr)

****************************************************************************
*政府不必去減少貧富差距  - 社會主義國家互動
****************************************************************************
bayes, melabel: ///
mixed noinc_greduce lgni gdpg gini country_Socialist ///
      b4.inequality_all improve ///
	  male age edu sclass b1.fincq ///
	  inequality_all#c.country_Socialist ///
		|| country: , cov(unstr)

log close