library(ggplot2)
library(dplyr)


getwd()
setwd("C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics/Data")

# Load data
ev_year <- read.csv("EV_Adoption_By_Year.csv")
glimpse(ev_year)
head(ev_year)

# Fit linear model
lm_model <- lm(Total_EV ~ Model_Year, data = ev_year)

# Regression equation
intercept <- coef(lm_model)[1]
slope <- coef(lm_model)[2]
eq_label <- paste0("y = ", round(intercept, 2), " + ", round(slope, 2), "x")

# Correlation test
cor_test <- cor.test(ev_year$Model_Year, ev_year$Total_EV)
cor_label <- paste0("r = ", round(cor_test$estimate, 2), ", p < 0.001")

# Set annotation positions on the regression line
x_annot <- median(ev_year$Model_Year)
y_eq <- intercept + slope * x_annot
y_cor <- y_eq + max(ev_year$Total_EV) * 0.05  # slightly above the line

# Plot with regression, correlation, and equation
p <- ggplot(ev_year, aes(x = Model_Year, y = Total_EV)) +
  geom_point(color = "dodgerblue3", size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "seagreen3", linewidth = 1.2) +
  annotate("text", x = x_annot, y = y_eq, label = eq_label, color = "darkgreen", size = 4.5, fontface = "italic") +
  annotate("text", x = x_annot, y = y_cor, label = cor_label, color = "firebrick", size = 5, fontface = "bold") +
  labs(
    title = "EV Adoption Trend by Model Year with Regression Line",
    x = "Model Year",
    y = "Total Electric Vehicles"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", color = "navy"),
    axis.title = element_text(face = "bold")
  )

# Display the plot
print(p)


# Set working directory to Reports
setwd("C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics/Reports")

# Save the plot directly in the current directory
ggsave("EV_Adoption_Trend_with_Regression.png",
       plot = p,
       width = 8, height = 5, dpi = 300)
