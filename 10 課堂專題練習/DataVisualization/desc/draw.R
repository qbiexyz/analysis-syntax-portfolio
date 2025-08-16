library(readxl)
library(tidyverse)
library(magrittr)
library(ggtext)
library(grid)
library(showtext)
library(shadowtext)
library(ggnewscale)

# 讀資料 ----
## 先預處理
fig1 <- read_excel("30 practice/desc/圖1.xlsx", 
                    sheet = "圖1") %>% 
  transform( 
    var = factor(var,levels = c("睡眠問題", "正面情緒", "負面情緒"))
  )

# 風格參考 https://r-graph-gallery.com/web-lineplots-and-area-chart-the-economist.html

# First, define colors. ----
BLUE <- "#076FA1"
GREY <- "#C7C9CB"
GREY_DARKER <- "#5C5B5D"
RED <- "#E3120B"
YELLOW <- "#FFB800"

line_labels<- data.frame(
  labels = c("睡眠問題", "正面情緒", "負面情緒"),
  x = c(15, 15, 15),
  y = c(1.3, 2.75, 1.9),
  color = c(RED, YELLOW, BLUE)
)

# Basic line chart ----
plt1 <- ggplot(fig1, aes(year, mean)) +
  geom_line(aes(color = var), size = 2.4) +
  geom_point(
    aes(fill = var), 
    size = 5, 
    pch = 21, 
    color = "white", 
    stroke = 1 
  ) +
  # Set values for the color and the fill
  scale_color_manual(values = c(RED, YELLOW, BLUE)) +
  scale_fill_manual(values = c(RED, YELLOW, BLUE)) + 
  # Do not include any legend
  theme(legend.position = "none")

plt1

# Customize layout----
plt1 <- plt1 + 
  scale_x_continuous(
    limits = c(12.5, 31),
    expand = c(0, 0), # The horizontal axis does not extend to either side
    breaks = c(13, 14, 15, 18, 22, 24, 27, 30),  # Set custom break locations
    labels = c("13歲", "14歲", "15歲", "18歲", "22歲", "24歲", "27歲", "30歲")
  ) +
  scale_y_continuous(
    limits = c(1, 3.1),
    breaks = seq(1, 3, by = 0.5), 
    expand = c(0, 0)
  ) + 
  theme(
    # Set background color to white
    panel.background = element_rect(fill = "white"),
    # Remove all grid lines
    panel.grid = element_blank(),
    # But add grid lines for the vertical axis, customizing color and size 
    panel.grid.major.y = element_line(color = "#A8BAC4", size = 0.3),
    # Remove tick marks on the vertical axis by setting their length to 0
    axis.ticks.length.y = unit(0, "mm"), 
    # But keep tick marks on horizontal axis
    axis.ticks.length.x = unit(2, "mm"),
    # Remove the title for both axes
    axis.title = element_blank(),
    # Only the bottom line of the vertical axis is painted in black
    axis.line.x.bottom = element_line(color = "black"),
    # Remove labels from the vertical axis
    axis.text.y = element_blank(),
    # But customize labels for the horizontal axis
    axis.text.x = element_markdown(size = 18, face = "bold")
  )   

plt1

# Add annotations and title----

# Add labels for the lines
plt1 <- plt1 + 
  new_scale_color() + 
  geom_shadowtext(
    aes(x, y, label = labels, color = color),
    data = line_labels,
    hjust = 0, # Align to the left
    bg.colour = "white", # Shadow color (or background color)
    bg.r = 0.4, # Radius of the background. The higher the value the bigger the shadow.
    size = 6,
    face = "bold"
  ) + 
  scale_color_identity() # Use the colors in the 'color' variable as they are.

# Add labels for the horizontal lines
plt1 <- plt1 + 
  geom_text(
    data = data.frame(x = 31, y = seq(1, 3, by = 0.5)),
    aes(x, y, label = y),
    hjust = 1, # Align to the right
    vjust = 0, # Align to the bottom
    nudge_y = 3 * 0.01, # The pad is equal to 1% of the vertical range (32 - 0)
    size = 6
  )

# Add title
plt1 <- plt1 +
  labs(
    title = "**睡眠問題和情緒的平均分數變化趨勢**, 分數",
    caption = "資料來源:臺灣青少年成長歷程研究，國一樣本追蹤資料"
  ) + 
  theme(
    # theme_markdown() is provided by ggtext and means the title contains 
    # Markdown that should be parsed as such (the '**' symbols)
    plot.title = element_markdown(size = 18),
    plot.caption = element_markdown( size = 12, color = "grey50")
  )

ggsave("30 practice/desc/fig1.png", 
       plot = plt1, width = 10, height = 6, dpi = 300)