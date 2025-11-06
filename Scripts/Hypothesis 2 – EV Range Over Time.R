setwd("C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics/Data")

ev_range <- read.csv("Average_Range_By_Year.csv")  # or the correct filename
head(ev_range)
str(ev_range)

cor_test <- cor.test(ev_range$Model_Year, ev_range$Avg_Electric_Range, method = "pearson")
cor_test


lm_range <- lm(Avg_Electric_Range ~ Model_Year, data = ev_range)
summary(lm_range)

library(ggplot2)
library(dplyr)



# Fit linear model
lm_range <- lm(Avg_Electric_Range ~ Model_Year, data = ev_range)

# Regression equation
intercept <- coef(lm_range)[1]
slope <- coef(lm_range)[2]
eq_label <- paste0("y = ", round(intercept, 2), " + ", round(slope, 4), "x")

# Correlation label
cor_test <- cor.test(ev_range$Model_Year, ev_range$Avg_Electric_Range)
cor_label <- paste0("r = ", round(cor_test$estimate, 2), ", p = ", signif(cor_test$p.value, 2))

# Pick x-position for annotation (near middle of range)
x_annot <- median(ev_range$Model_Year)
# Compute y-values **on the regression line**
y_eq <- intercept + slope * x_annot
y_cor <- y_eq + max(ev_range$Avg_Electric_Range)*0.05  # slightly above regression line

# Plot
p <- ggplot(ev_range, aes(x = Model_Year, y = Avg_Electric_Range)) +
  geom_point(color = "dodgerblue3", size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "seagreen3", linewidth = 1.2) +
  annotate("text", x = x_annot, y = y_eq, label = eq_label, color = "darkgreen", size = 4.5, fontface = "italic") +
  annotate("text", x = x_annot, y = y_cor, label = cor_label, color = "firebrick", size = 5, fontface = "bold") +
  labs(
    title = "Average EV Range by Model Year with Regression Line",
    x = "Model Year",
    y = "Average Electric Range (miles)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", color = "navy"),
    axis.title = element_text(face = "bold")
  )

# Display plot
print(p)

# Save the plot
setwd("C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics/Reports")
ggsave("EV_Range_Trend_with_Regression.png", plot = p, width = 8, height = 5, dpi = 300)

  
  