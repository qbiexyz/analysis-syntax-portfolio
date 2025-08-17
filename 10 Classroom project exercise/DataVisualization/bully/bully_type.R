# 載入所需套件
library(readxl)
library(haven)
library(tidyverse)
library(magrittr)
library(ggtext)
library(grid)
library(showtext)
library(shadowtext)
library(hrbrthemes)

# 讀取Excel文件
data <- read_excel("30 practice/bully/bully_draw.xlsx")

# 轉換資料格式
data_long <- data %>%
  pivot_longer(
    cols = starts_with("Non-involved") | starts_with("High/multiple") | starts_with("Traditional") | starts_with("Cyber") | starts_with("Verbal"),
    names_to = "Category",
    values_to = "Prob"
  ) %>%
  transform( 
    Category = factor(Category, 
                      levels = c("Non-involved(73.3%)", "High/multiple(5.7%)",
                                 "Traditional(4.1%)", "Cyber(2.2%)",
                                 "Verbal(14.7%)")),
    name = factor(name, 
                  levels = c("direct_verbal", "direct_defamation", "direct_exclusion", 
                             "direct_mocking1", "direct_mocking2", "direct_sabotage", 
                             "direct_extortion", "direct_physical", "cyber_verbal", 
                             "cyber_defamation", "cyber_exclusion", "cyber_mocking1", 
                             "cyber_mocking2", "cyber_doxing ", "cyber_impersonation"))
  )


# 定義顏色
colors <- c(
  "Non-involved(73.3%)" = "#A9A9A9",
  "High/multiple(5.7%)" = "#FF0000",
  "Traditional(4.1%)" = "#1E90FF",
  "Cyber(2.2%)" = "#FFA500",
  "Verbal(14.7%)" = "#32CD32"
)

GREY <- "grey50"

# 繪製圖表
p <- ggplot(data_long, aes(x = name, y = Prob, color = Category, group = Category)) +
  geom_vline(xintercept = 8.5, size = 1, linetype = "dashed", color = "black") +
  geom_line(size = 1.2) +
  scale_color_manual(values = colors) +
  scale_x_discrete(labels = c("verbal", "defamation", "exclusion", 
                              "mocking1", "mocking2", "sabotage", 
                              "extortion", "physical", "verbal", 
                              "defamation", "exclusion", "mocking1", 
                              "mocking2", "doxing ", "impersonation")) +
  scale_y_continuous(breaks = c(0, 0.5, 1), limits = c(0, 1)) +
  labs(
    title = "LCA analysis (N = 8,651)",
    subtitle = "Item-response probability for 15 bullying victimization variables across the five latent classes.<br><strong>Bully Victimization type :</strong><br>  <span style='color:#A9A9A9;'>Non-involved(73.3%)</span></b>、<span style='color:#FF0000;'>High/multipl(5.7%)</span></b>、<span style='color:#1E90FF;'>Traditional(4.1%)</span></b>、<span style='color:#FFA500;'>Cyber(2.2%)</span></b>、<span style='color:#32CD32;'>Verbal(14.7%)</span></b>",
    x = "<strong>Traditional bullying victimization</strong>   &larr;&rarr;   <strong>Cyber bullying victimization</strong>",
    y = "Prob(Exp|Type)",
    caption = "Data sourse: Taiwan i-Generation Panel Study"
  ) + 
  theme(
    plot.title = element_markdown(face = "bold", size = 20),
    plot.subtitle = element_markdown(size = 12),
    plot.caption = element_markdown(size = 10, color = GREY),
    axis.text.x = element_markdown(size = 10, angle = 90, hjust = 1),
    axis.title.x = element_markdown(size = 12, face = "bold"),
    axis.title.y = element_markdown(size = 12, face = "bold"),
    legend.position = "none",
    panel.background = element_rect(fill = "white", color = NA),  # 設置面板背景為白色
    plot.background = element_rect(fill = "white", color = NA),   # 設置整個圖表背景為白色
    panel.grid.major = element_line(color = "#A9A9A9"),  # 設置主網格線為黑色
    panel.grid.minor = element_blank() 
  )

p

ggsave("30 practice/bully/Bully Victimization class.png", 
       plot = p, width = 8, height = 6, dpi = 300)


