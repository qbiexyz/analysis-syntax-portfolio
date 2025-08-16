#作業一：基本統計複習與熟悉R

# 重製
# 高碩亨、張明麗、胡家珮，2019，〈學前與中小學教師工作—家庭衝突、工作—家庭互利
# 、工作滿意、家庭生活滿意對身體健康狀況與快樂感之影響〉，《臺北市立大學學報
# •教育類》50，2：33-57。

#設定工作路徑
setwd("D:/Dropbox/學習/碩士/碩一下/量化分析專題/hw/hw1")

#讀入資料
library(haven) ##因為用foreign讀取會有亂碼，且不能讀太舊版本，找了一個其他的
family62 <- read_dta("tscs2011q1.dta") 
names(family62) 

######分析開始

###選取需要的變項
working <- c("a1","year_m", "a2y", "a2m", "a6", "k12", "k8a", "k8b", "k8c", 
           "k8d", "k8e", "k8f", "k7","k6", "g4", "a5", "g6", "k5b4", 
           "k5b5", "k5b5r")
r_family62 <- family62[working]
names(r_family62)

###篩選分析樣本
# (扣除調查時未婚、無工作、退
# 休、家庭主婦、學生等無給職工作或非就
# 業者，得到有效樣本數 1,269 位 21 至 84
# 歲已婚在職民眾。)

library(dplyr)

#keep married(已婚有偶、配偶去世)
print_labels(r_family62$a6) #marital status label
r_family62 <- r_family62 %>%
  filter(a6 <= 2) 

#keep have work(有全職工作、有兼職工作、不固定(打零工)、
#               為家庭事業工作,而且有領薪水)
print_labels(r_family62$k6) #work label
r_family62 <- r_family62 %>%
  filter(k6 <= 4)  
table(r_family62$k6)

#keep age 21-84   
r_family62 <- r_family62 %>%
  mutate(age = year_m - a2y)  #gen age

r_family62 <- r_family62 %>%
  filter(age >= 21 & age <= 84) 

#keep 職業別沒有遺漏 
#print_labels(r_family62$k5b5) #work label
r_family62 <- r_family62 %>%
  filter(k5b5 < 9990) 

#篩選完剩742筆樣本

#######建立變項

###變數定義：前置變項
#職業類別
#print_labels(r_family62$k5b5r) #work label
table(r_family62$k5b5r)

r_family62 <- r_family62 %>%
  mutate(work = if_else(k5b5 == 2331 | k5b5 == 2332, 1, #學前與中小學教師為參考
                         if_else(k5b5r <= 2, 2,
                                 if_else(k5b5r >= 90, NA_real_, k5b5r
                                         )))) #gen work
r_family62 <- transform(r_family62, work
                        = factor(work, levels=c(1,2,3,4,5,6,7,8,9)))
                         
###變數定義：控制變項
#性別
print_labels(r_family62$a1) #gender label 
#男性參考 (描述跟模型不一樣 以模型)

r_family62 <- r_family62 %>%
  mutate(male = if_else(a1 == 1, 1,
                          if_else(a1 == 2, 0, NA_real_))) #gen gender 

#家庭收入
print_labels(r_family62$k12) #hincome label

r_family62 <- r_family62 %>%
  mutate(hincome = if_else(k12 == 1, 0,
                           if_else(k12 >= 2 & k12 <= 21, (k12 - 2) + 0.5,
                                   if_else(k12 >= 22 & k12 <= 24, (k12-20)*10+5,
                                           if_else(k12 == 25, 75,
                                                   if_else(k12 == 26, 150,
                                                      NA_real_
                                                      )))))) #gen hincome

###變數定義：中介變項

#若不想跑因素分析可以：
#k8a, k8b-->工作家庭衝突；其他-->工作家庭互利
#k8a - k8f 反向編碼
print_labels(r_family62$k8a) #k8a label

library(foreach)

foreach(x = c("a", "b", "c", "d", "e", "f")) %do% {
  r_family62 <- r_family62 %>% 
    mutate(!!paste0("k8", x, "_n") := 6 - !!sym(paste0("k8", x))) %>% 
    mutate(!!paste0("k8", x, "_n") := if_else(!!sym(paste0("k8", x)) >= 90
                                              , NA_real_
                                              , !!sym(paste0("k8", x, "_n"))))
}

#工作家庭衝突 k8a_n k8b_n

r_family62 <- r_family62 %>%
  mutate(WF_conflict = (k8a_n + k8b_n)/2) #gen WF_conflict

#工作家庭互利 k8c_n k8d_n k8e_n k8f_n 
#(他的量表示其中一個有NA還會計算) 其中這幾題都是NA
r_family62 <- r_family62 %>% 
  rowwise() %>% 
  mutate(WF_benefit = mean(c(k8c_n, k8d_n, k8e_n, k8f_n), na.rm = TRUE)) #gen WF_benefit

#工作滿意 k7
print_labels(r_family62$k7) #work_sta label
r_family62 <- r_family62 %>%
  mutate(work_sta = if_else(k7 >= 90 , NA_real_, 6 - k7)) #gen work_sta

#家庭生活滿意 g4
print_labels(r_family62$g4) #life_sta label
r_family62 <- r_family62 %>%
  mutate(life_sta = if_else(g4 >= 90 , NA_real_, 6 - g4)) #gen life_sta

###變數定義：結果變項
#身體健康狀況 a5
print_labels(r_family62$a5) #health label
r_family62 <- r_family62 %>%
  mutate(health = if_else(a5 >= 90 , NA_real_, a5)) #gen health

#快樂感 g6
print_labels(r_family62$g6) #happy label
r_family62 <- r_family62 %>%
  mutate(happy = if_else(g6 >= 90 , NA_real_, 5 - g6)) #gen happy


#使用EM法處理缺失值-->改成採用平均數取代的方式來進行插補
analyze_var <- c("hincome","WF_conflict", "WF_benefit", "work_sta"
                 , "life_sta", "health", "happy", "work", "male")

analyze <- r_family62[analyze_var]
names(analyze)

#算出變項沒有缺失值的平均數
mean_1 <- mean(analyze$hincome, na.rm = TRUE)
#將算出的平均數補到原本缺失資料
analyze$hincome <- ifelse(is.na(analyze$hincome), mean_1, analyze$hincome)

mean_2 <- mean(analyze$WF_benefit, na.rm = TRUE)
analyze$WF_benefit <- ifelse(is.na(analyze$WF_benefit), mean_1, analyze$WF_benefit)

mean_3 <- mean(analyze$life_sta, na.rm = TRUE)
analyze$life_sta <- ifelse(is.na(analyze$life_sta), mean_1, analyze$life_sta)

mean_4 <- mean(analyze$happy, na.rm = TRUE)
analyze$happy <- ifelse(is.na(analyze$happy), mean_1, analyze$happy)

#########資料分析

#表1、本研究各數值變項之有效個數、遺漏個數與遺漏比率

describe <- r_family62[c("hincome","WF_conflict", "WF_benefit", "work_sta"
                         , "life_sta", "health", "happy")]
names(describe)

library(psych)
#描述統計整個data的變項
describe_All <- describe(describe)

#創造有效個數和遺漏值個數
describe_All <- describe_All %>% 
  mutate("有效個數" =  n)  %>% 
  mutate("遺漏個數" = 742 - n)
  
#選取只有有效個數和遺漏值個數的資料
describe_N <- describe_All[c("有效個數", "遺漏個數")]

#將將其轉置並形成dataframe
describe_N <- describe_N %>% 
  t() %>% 
  as.data.frame()

#命名欄位
names(describe_N) <- c("家庭收入", "工作—家庭衝突", "工作—家庭互利"
                       , "工作滿意", "家庭生活滿意", "身體健康狀況", "快樂感")
#輸出表1(手動美化)
library(writexl)
write_xlsx(list(表1 = describe_N), "hw1 表1.xlsx")

#表2、工作—家庭衝突、工作—家庭互利、工作滿意、家庭生活滿意、
#身體健康狀況與快樂感之平均數分析

#對分析變項進行anova分析並儲存結果
a1 <- aov(WF_conflict ~ work, data = analyze)
a2 <- aov(WF_benefit ~ work, data = analyze)
a3 <- aov(work_sta ~ work, data = analyze)
a4 <- aov(life_sta ~ work, data = analyze)
a5 <- aov(health ~ work, data = analyze)
a6 <- aov(happy ~ work, data = analyze)

#算出變項的平均數
a1_Am <- mean(analyze$WF_conflict)
a2_Am <- mean(analyze$WF_benefit)
a3_Am <- mean(analyze$work_sta)
a4_Am <- mean(analyze$life_sta)
a5_Am <- mean(analyze$health)
a6_Am <- mean(analyze$happy)

#算出將work各類別對分析變項平均數列出並儲存
a1_m <- model.tables(a1, "means")
a2_m <- model.tables(a2, "means")
a3_m <- model.tables(a3, "means")
a4_m <- model.tables(a4, "means")
a5_m <- model.tables(a5, "means")
a6_m <- model.tables(a6, "means")

#將上述合併轉成dataframe
output2 <- data.frame(
  WF_conflict_M = c(a1_Am, a1_m$tables$work), WF_conflict_N = c(742, a1_m$n$work)
  , WF_benefit_M = c(a2_Am, a2_m$tables$work), WF_benefit_N = c(742, a2_m$n$work)
  , work_sta_M = c(a3_Am, a3_m$tables$work), work_sta_N = c(742, a3_m$n$work)
  , life_sta_M = c(a4_Am, a4_m$tables$work), life_sta_N = c(742, a4_m$n$work)
  , health_M = c(a5_Am, a5_m$tables$work), health_N = c(742, a5_m$n$work)
  , happy_M = c(a6_Am, a6_m$tables$work), happy_N = c(742, a6_m$n$work)
)

#查看anova結果 F值、顯著度
summary(a1)
summary(a2)
summary(a3)
summary(a4)
summary(a5)
summary(a6)

#Eta值
library(lsr)

etaSquared(a1)
etaSquared(a2)
etaSquared(a3)
etaSquared(a4)
etaSquared(a5)
etaSquared(a6)

#輸出表2(手動美化並加上Eta值、、F值、顯著度)
write_xlsx(list(表2 = output2), "hw1 表2.xlsx")

#表4、工作—家庭衝突、工作—家庭互利對學前與中小學教師快樂感之迴歸分析

#層級回歸分析
m1 <- lm(happy ~ male + hincome + work, data = analyze)
m2 <- lm(happy ~ male + hincome + work + WF_conflict + WF_benefit, data = analyze)
m3 <- lm(happy ~ male + hincome + work + WF_conflict + WF_benefit 
         + work_sta + life_sta, data = analyze)

#輸出表4
library(stargazer)
stargazer(m1, m2, m3, type = "text", ci = FALSE, digits = 2, 
          star.cutoffs = c(.05, .01, .001)
          , title = "表4 工作—家庭衝突、工作—家庭互利對學前與中小學教師快樂感之迴歸分析"
          , covariate.labels = 
            c("男性", "家庭收入", "主管專業", "半專業人員", "事務性人員"
              , "服務性人員", "農林漁牧工作", "技術工", "半技術工", "體力工"
              , "工作—家庭衝突", "工作—家庭互利", "工作滿意", "家庭生活滿意"
              ,"Intercept")
          ,  dep.var.labels = c("快樂感"), align=TRUE, out = "hw1 表4.html")


#表6、前置變項與控制變項對中介變項之迴歸分析

#回歸分析
m4 <- lm(WF_conflict ~ male + hincome + work, data = analyze)
m5 <- lm(WF_benefit ~ male + hincome + work, data = analyze)
m6 <- lm(work_sta ~ male + hincome + work, data = analyze)
m7 <- lm(life_sta ~ male + hincome + work, data = analyze)

#輸出表6
stargazer(m4, m5, m6, m7, type = "text", ci = FALSE, digits = 2, 
          star.cutoffs = c(.05, .01, .001)
          , title = "表6 前置變項與控制變項對中介變項之迴歸分析"
          , covariate.labels = 
            c("男性", "家庭收入", "主管專業", "半專業人員", "事務性人員"
              , "服務性人員", "農林漁牧工作", "技術工", "半技術工", "體力工"
              ,"Intercept")
          ,  dep.var.labels = c("工作—家庭衝突", "工作—家庭互利"
                                , "工作滿意", "家庭生活滿意")
          , align=TRUE, out = "hw1 表6.html")
