# PURPOSE: Automated profiling and quality documentation

install.packages(c("DataExplorer", "skimr", "summarytools"))
library(DataExplorer)
library(skimr)
library(summarytools)


ev_path <- "Data/Electric_Vehicle_Population_Data.csv"
alt_path <- "Data/Alternative_Fuel_Stations.csv"


getwd()
setwd("C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics")


# Load datasets
ev <- read.csv(ev_path, stringsAsFactors = FALSE)
alt <- read.csv(alt_path, stringsAsFactors = FALSE)

#  Profiling overview 
cat("Profiling Electric Vehicle Dataset...\n")
skim(ev)
create_report(ev, output_file = "Reports/EV_Profile.html", output_dir = "Reports")

cat("Profiling Alternative Fuel Station Dataset...\n")
skim(alt)
create_report(alt, output_file = "Reports/ALT_Profile.html", output_dir = "Reports")

# 5. Data quality summaries
dir.create("Reports", showWarnings = FALSE)
dfSummary(ev, file = "Reports/EV_Summary.html")
dfSummary(alt, file = "Reports/ALT_Summary.html")

# 6. Basic metrics for documentation 
ev_quality <- data.frame(
  Metric = c("Accuracy", "Completeness", "Consistency", "Validity", "Timeliness", "Uniqueness", "Relevance"),
  Description = c(
    "Reflects true vehicle data (VIN, location)",
    "Non-null values across 17 columns",
    "Uniform data formats and casing",
    "Dates and ranges in correct format",
    "Updated recently (check Updated_At)",
    "No duplicate VINs or IDs",
    "Relevant to EV adoption analysis"
  )
)

alt_quality <- data.frame(
  Metric = c("Accuracy", "Completeness", "Consistency", "Validity", "Timeliness", "Uniqueness", "Relevance"),
  Description = c(
    "Accurate station coordinates & names",
    "Missing values handled or imputed",
    "Standardized network and access fields",
    "Valid dates in ISO format",
    "Contains current DOE-confirmed data",
    "No duplicate station IDs",
    "Relevant for EV infrastructure analysis"
  )
)

write.csv(ev_quality, "Reports/EV_DataQuality.csv", row.names = FALSE)
write.csv(alt_quality, "Reports/ALT_DataQuality.csv", row.names = FALSE)

cat("✅ Profiling complete. Reports saved in /Reports folder.\n")
