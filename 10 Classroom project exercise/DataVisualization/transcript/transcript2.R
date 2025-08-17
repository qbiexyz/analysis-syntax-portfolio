# Load Libraries ----
library(tidyverse)
library(waffle)
library(showtext)
library(sysfonts)

# Read Data ----
transcript <- read_csv('30 practice/transcript/transcript.csv')

glimpse(transcript)

transcript <- transcript |>
  count(semester, suject_type) |>
  transform(
    semester = factor(
      semester,
      levels = c("大一", "大二", 
                 "大三", "大四")
    ),
    suject_type = factor(
      suject_type,
      levels = c("調查方法專業", "資料程式設計專業",
                 "資料科學專業", "社會學或其他專業")
    )
  )

# Define Colors ----
subject_colors <- c("社會學或其他專業" = "#FFD06F",
                    "資料科學專業" = "#376795",
                    "資料程式設計專業" = "#72BCD5",
                    "調查方法專業" = "#84A8CA")

# Set Font to Microsoft JhengHei ----
font_add("microsoftjhenghei", "30 practice/transcript/microsoftjhenghei.ttf")
showtext_auto()

# Plotting ----
plot <- ggplot(transcript, aes(fill = suject_type, values = n)) +
  geom_waffle(n_rows = 2, flip = TRUE, na.rm = TRUE, color = "white") +
  scale_fill_manual(values = subject_colors) +
  facet_wrap(~semester, nrow = 1, strip.position = "bottom") +
  coord_equal() +
  labs(title = "大學修課紀錄",
       subtitle = "每個方格代表一個科目\n科目類別: 社會學或其他專業、\n                     資料科學專業、資料程式設計專業、調查方法專業\n方格邊框顏色:成績在A以上",
       caption = "資料來源: 大學成績單(排除通識、體育、國英文)") +
  theme_minimal() +
  theme(text = element_text(family = "microsoftjhenghei", face = "bold"),
        plot.title = element_text(color = "black"),
        plot.subtitle = element_text(size = 10),
        plot.caption = element_text(hjust = 1),
        strip.text = element_text(family = "microsoftjhenghei"),
        legend.position = "none",
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) 

# Show the plot
plot
