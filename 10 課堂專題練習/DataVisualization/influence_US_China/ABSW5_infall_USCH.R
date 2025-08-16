library(haven)
library(tidyverse)
library(magrittr)
library(ggtext)
library(grid)
library(showtext)
library(shadowtext)

# data ----
ABSW5_infall_USCH <- read_dta("30 practice/influence_US_China/ABSW5_infall_USCH.dta")

c2 <- c("Malaysia", "Singapore", "Hong Kong", "Thailand",
          "Indonesia", "Australia", "Philippines", "Taiwan", "Japan",
          "Korea", "India", "Mongolia", "Myanmar", "Vietnam")

ABSW5_infall_USCH %<>% 
  transform( 
    country2 = factor(country2, labels = c2)
  )
  
# 畫圖參考https://r-graph-gallery.com/web-horizontal-barplot-with-labels-the-economist.html

# The colors ---- 
BLUE <- "#076fa2"
RED <- "#E3120B"
BLACK <- "#202020"
GREY <- "grey50"

plt <- ggplot(ABSW5_infall_USCH) +
  geom_col(aes(infme_USCH, country2), fill = BLUE, width = 0.6) 

plt

# Customize layout  ----
plt <- plt + 
  scale_x_continuous(
    limits = c(-0.6, 2),
    breaks = seq(-0.5, 2, by = 0.5), 
    position = "top"  # Labels are located on the top
  ) +
  # The vertical axis only extends upwards 
  scale_y_discrete(expand = expansion(add = c(0, 0.5))) +
  theme(
    # Set background color to white
    panel.background = element_rect(fill = "white"),
    # Set the color and the width of the grid lines for the horizontal axis
    panel.grid.major.x = element_line(color = "#A8BAC4", size = 0.3),
    # Remove tick marks by setting their length to 0
    axis.ticks.length = unit(0, "mm"),
    # Remove the title for both axes
    axis.title = element_blank(),
    # Remove labels from the vertical axis
    axis.text.y = element_blank(),
    # But customize labels for the horizontal axis
    axis.text.x = element_markdown(size = 16)
  ) + 
  geom_vline(xintercept = 0, linetype = "solid",
             size = 1, color = "black")

plt

# Add labels ----
plt <- plt + 
  geom_shadowtext(
    data = subset(ABSW5_infall_USCH, infme_USCH >= -0.2 & infme_USCH <= 0),
    aes(infme_USCH, y = country2, label = country2),
    hjust = 1, nudge_x = -0.01, colour = BLUE,
    bg.colour = "white", bg.r = 0.2, size = 4
  ) + 
  geom_shadowtext(
    data = subset(ABSW5_infall_USCH, infme_USCH >= 0 & infme_USCH <= 0.2),
    aes(infme_USCH, y = country2, label = country2),
    hjust = 0, nudge_x = 0.01, colour = BLUE,
    bg.colour = "white", bg.r = 0.2, size = 4
  ) +
  geom_text(
    data = subset(ABSW5_infall_USCH, infme_USCH > 0.2),
    aes(0, y = country2, label = country2),
    hjust = 0,  nudge_x = 0.01, colour = "white", size = 4
  ) +
  geom_text(
    data = subset(ABSW5_infall_USCH, infme_USCH < -0.2),
    aes(0, y = country2, label = country2),
    hjust = 1, nudge_x = -0.01, colour = "white", size = 4
  ) 

plt

# Add annotations and final tweaks ----
plt <- plt +
  labs(
    title = "美國與中國對亞洲14國影響",
    subtitle = "該國自評平均影響(美國-中國)程度，大於0表美國影響較大",
    caption = "資料來源: 第五波亞洲民主動態調查（2018～2022）"
  ) + 
  theme(
    plot.title = element_markdown(face = "bold", size = 24),
    plot.subtitle = element_markdown(size = 14),
    plot.caption = element_markdown( size = 12, color = GREY),
    plot.margin = margin(0.01, 0, 0.01, 0, "npc")
  )
plt


ggsave("30 practice/influence_US_China/influence_US_China.png", 
       plot = plt, width = 7, height = 6, dpi = 300)
