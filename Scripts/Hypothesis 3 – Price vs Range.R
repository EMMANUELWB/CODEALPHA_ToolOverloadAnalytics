library(ggplot2)
library(dplyr)

# Set working directory
setwd("C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics/Data")

# Load data
ev_price_range <- read.csv("Price vs range query.csv")

# Linear model
lm_price_range <- lm(Avg_Range ~ Avg_Price, data = ev_price_range)

# Regression equation
intercept <- coef(lm_price_range)[1]
slope <- coef(lm_price_range)[2]
eq_label <- paste0("y = ", round(slope, 4), "x + ", round(intercept, 2))

# Correlation test
cor_test <- cor.test(ev_price_range$Avg_Price, ev_price_range$Avg_Range)
cor_label <- paste0("r = ", round(cor_test$estimate, 2),
                    " (p = ", signif(cor_test$p.value, 3), ")")

# Positions for annotation (on or near the regression line)
x_pos <- min(ev_price_range$Avg_Price) + 0.8 * diff(range(ev_price_range$Avg_Price))
y_pos_eq <- predict(lm_price_range, newdata = data.frame(Avg_Price = x_pos))
y_pos_cor <- y_pos_eq + 5  # slightly above the line

# Plot
p <- ggplot(ev_price_range, aes(x = Avg_Price, y = Avg_Range)) +
  geom_point(color = "dodgerblue3", size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "seagreen3", linewidth = 1.2) +
  annotate("text",
           x = x_pos,
           y = y_pos_cor,
           label = cor_label,
           color = "firebrick",
           size = 5,
           fontface = "bold") +
  annotate("text",
           x = x_pos,
           y = y_pos_eq,
           label = eq_label,
           color = "darkgreen",
           size = 4.5,
           fontface = "italic") +
  labs(
    title = "EV Average Price vs. Electric Range with Regression Line",
    x = "Average Price ($)",
    y = "Average Electric Range (miles)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", color = "navy"),
    axis.title = element_text(face = "bold")
  )

# Save plot (make sure Reports folder exists)
setwd("C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics/Reports")
ggsave("EV_Price_vs_Range_with_Regression.png", plot = p,
       width = 8, height = 5, dpi = 300)
