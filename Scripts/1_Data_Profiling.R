
# PURPOSE: Automated profiling and quality documentation

install.packages(c("DataExplorer", "skimr", "summarytools"))
library(DataExplorer)
library(skimr)
library(summarytools)


ev_path <- "Data/Electric_Vehicle_Population_Data.csv"


getwd()
setwd("C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics")


# Load datasets
ev <- read.csv(ev_path, stringsAsFactors = FALSE)

#  Profiling overview 
cat("Profiling Electric Vehicle Dataset...\n")
skim(ev)
create_report(ev, output_file = "Reports/EV_Profile.html", output_dir = "Reports")


# 5. Data quality summaries
dir.create("Reports", showWarnings = FALSE)
dfSummary(ev, file = "Reports/EV_Summary.html")


write.csv(ev_quality, "Reports/EV_DataQuality.csv", row.names = FALSE)

cat("✅ Profiling complete. Reports saved in /Reports folder.\n")
