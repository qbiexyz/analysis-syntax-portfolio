
# 套件 ----
library(tidyverse)
library(waffle)   
library(ggtext)
library(showtext)
library(rnaturalearth)
library(sf)   
library(readr)

# 數據讀取、整理----
transcript <- read_csv('30 practice/transcript/transcript.csv')

glimpse(transcript)

transcript_c <- transcript |>
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

write.csv(transcript_c, file = "30 practice/transcript/transcript2.csv"
          , row.names = F, fileEncoding = "Big5")

 
# 文字相關整理 ----

title<-"大學修課紀錄"
sub<-"每個方格代表一個科目<br><b>科目類別:<span style='color:#FFD06F;'>社會學或其他專業</span></b>、<br><b><b><b><b><b><b><span style='color:#376795;'>資料科學專業</span></b>、<span style='color:#72BCD5;'>資料程式設計專業</span></b>、<span style='color:#84A8CA;'>調查方法專業</span></b><br><b>方格邊框顏色:<span style='color:#9A3A3A;'>成績在A以上</span></b><br><b>"

pal_fill <- c(
  "社會學或其他專業" = "#FFD06F", " 資料科學專業" = "#376795",
  "資料程式設計專業" = "#72BCD5", "調查方法專業" = "#84A8CA",
  # Set alpha to 0 to hide 'z'
  'z'=alpha('white',0)
)

pal_color <- c(
  "社會學或其他專業" = "white", " 資料科學專業" = "white",
  "資料程式設計專業" = "white", "調查方法專業" = "white",
  # Set alpha to 0 to hide 'z'
  'z'=alpha('white',0)
)




# 畫圖 ----
p1 <- ggplot(
  transcript_c, 
  aes(values = n, fill = suject_type)
)+
  waffle::geom_waffle(
    n_rows = 2,        # Number of squares in each row
    flip = TRUE, na.rm = TRUE
  )+
  facet_wrap(
    ~semester, 
    nrow = 1, 
    strip.position = "bottom") +
  scale_x_discrete()+
  scale_fill_manual(values = pal_fill) +
  scale_color_manual(values = pal_color) +
  coord_equal()
p1
p2 <- p1 +
  # Hide legend
  guides(fill='none',color='none')+
  # Add title and subtitle
  labs(title=title,subtitle=sub)+
  theme(
    # Enable markdown for title and subtitle
    plot.title=element_markdown(),
    plot.subtitle=element_markdown(),
    # "Clean" facets 
    panel.background=element_rect(fill="white"),
    axis.title.y = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    strip.background.x = element_rect(fill="white"),
    strip.background.y = element_rect(fill="white"),
    strip.text.y = element_text(color="white")
  )
p2



