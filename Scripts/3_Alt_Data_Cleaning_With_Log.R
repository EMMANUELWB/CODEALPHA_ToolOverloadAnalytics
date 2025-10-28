
# PURPOSE: Clean and document Alternative Fuel Stations dataset

# Loading Libraries
library(readr)
library(dplyr)
library(stringr)
library(lubridate)

cat("Starting Alternative Fuel Stations Data Cleaning + Documentation...\n")

# Load dataset ----
alt <- read_csv("Data/Alternative_Fuel_Stations.csv", show_col_types = FALSE)
cat("Dataset loaded successfully! Rows:", nrow(alt), " | Columns:", ncol(alt), "\n")

#  Cleaning Log
clean_log <- data.frame(
  Column = character(),
  Issue = character(),
  Action = character(),
  DataQuality_Dimension = character(),
  Validation = character(),
  Final_DataType = character(),
  stringsAsFactors = FALSE
)

log_entry <- function(column, issue, action, dimension, validation, type) {
  clean_log[nrow(clean_log) + 1, ] <<- list(column, issue, action, dimension, validation, type)
}

# Convert to correct data types
cat("\n Converting data types...\n")

alt <- alt %>%
  mutate(
    across(c(Fuel_Type_Code, Station_Name, Street_Address, Intersection_Directions,
             City, State, Status_Code, Groups_With_Access_Code, Access_Days_Time,
             Cards_Accepted, EV_Network, EV_Network_Web, Owner_Type_Code,
             Federal_Agency_Name, Country, Facility_Type, Funding_Sources),
           as.character),
    ZIP = as.character(ZIP),
    across(c(EV_Level1_EVSE_Num, EV_Level2_EVSE_Num, EV_DC_Fast_Count,
             Latitude, Longitude), suppressWarnings(as.numeric)),
    # Convert date and datetime columns
    Date_Last_Confirmed = suppressWarnings(parse_date_time(Date_Last_Confirmed, orders = "ymd")),
    Updated_At = suppressWarnings(parse_date_time(str_remove(Updated_At, " UTC"), orders = "ymd HMS")),
    Open_Date = suppressWarnings(parse_date_time(Open_Date, orders = "ymd"))
  )

log_entry("All Columns", "Inconsistent data types", "Standardized numeric, text, and datetime types",
          "Consistency, Validity", "Verified with str()", "Mixed (see column summary)")

# Handle Missing & Invalid Values
cat("\n Handling missing and invalid values...\n")

alt <- alt %>%
  mutate(
    Access_Days_Time = ifelse(is.na(Access_Days_Time) | Access_Days_Time == "", "Unknown", Access_Days_Time),
    EV_Level1_EVSE_Num = ifelse(Fuel_Type_Code == "ELEC" & is.na(EV_Level1_EVSE_Num), 0, EV_Level1_EVSE_Num),
    EV_Level2_EVSE_Num = ifelse(Fuel_Type_Code == "ELEC" & is.na(EV_Level2_EVSE_Num), 0, EV_Level2_EVSE_Num),
    EV_DC_Fast_Count   = ifelse(Fuel_Type_Code == "ELEC" & is.na(EV_DC_Fast_Count), 0, EV_DC_Fast_Count),
    Owner_Type_Code = case_when(
      Owner_Type_Code == "FG" ~ "Federal Government",
      Owner_Type_Code == "LG" ~ "Local Government",
      Owner_Type_Code == "SG" ~ "State Government",
      Owner_Type_Code == "P"  ~ "Private",
      Owner_Type_Code == "T"  ~ "Tribal",
      TRUE ~ "Unknown"
    ),
    Latitude = round(Latitude, 6),
    Longitude = round(Longitude, 6)
  )

log_entry("Access_Days_Time", "252 blanks", "Replaced blanks with 'Unknown'",
          "Completeness", "Checked NA count", "VARCHAR(255)")

log_entry("EV_Level1_EVSE_Num / EV_Level2_EVSE_Num / EV_DC_Fast_Count",
          "Missing values for electric stations", "Replaced NA with 0 if Fuel_Type_Code = 'ELEC'",
          "Completeness", "Value count verified", "INT")

log_entry("Owner_Type_Code", "Abbreviations (FG, LG, SG, P, T)", "Mapped to full names",
          "Accuracy, Readability", "Unique value check", "VARCHAR(50)")

log_entry("Latitude / Longitude", "Precision mismatch", "Rounded to 6 decimals",
          "Consistency", "Range check (-90 to 90 / -180 to 180)", "DECIMAL(10,6)")

log_entry("Date_Last_Confirmed / Updated_At / Open_Date",
          "Non-SQL formats or UTC suffix", "Parsed to 'YYYY-MM-DD HH:MM:SS' datetime",
          "Validity", "Format check", "DATETIME")


# Finding which columns cause date parsing errors
sapply(alt, function(x) any(grepl("/", x) | grepl("-", x)))

# Clean and standardize date columns 
# Replacing non-date placeholders or blanks
alt$Date_Last_Confirmed[grepl("0000|N/A|^$", alt$Date_Last_Confirmed)] <- NA
alt$Updated_At[grepl("0000|N/A|^$", alt$Updated_At)] <- NA
alt$Open_Date[grepl("0000|N/A|^$", alt$Open_Date)] <- NA
alt$Expected_Date[grepl("0000|N/A|^$", alt$Expected_Date)] <- NA

# Remove 'UTC' and parse all consistently
alt$Updated_At <- gsub(" UTC", "", alt$Updated_At)

# Parse into proper Date/Datetime formats
alt$Date_Last_Confirmed <- as.Date(alt$Date_Last_Confirmed, format = "%Y-%m-%d")
alt$Open_Date <- as.Date(alt$Open_Date, format = "%Y-%m-%d")
alt$Expected_Date <- as.Date(alt$Expected_Date, format = "%Y-%m-%d")

# Updated_At is a full datetime
alt$Updated_At <- as.POSIXct(alt$Updated_At, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

# 4. Fix data type issues (important before profiling)
# Convert only character-like columns to character safely
alt <- alt %>%
  mutate(across(where(~!is.numeric(.) & !inherits(., "Date") & !inherits(., "POSIXt")), as.character))

# ---- 5. Verify date conversions ----
sapply(alt[, c("Date_Last_Confirmed", "Expected_Date", "Open_Date", "Updated_At")], class)

# ---- 6. Quality Checks ----
cat("\n Performing quality checks...\n")

# Safe missing value summary by type
missing_summary <- sapply(alt, function(x) {
  if (is.character(x)) {
    sum(is.na(x) | x == "")
  } else if (is.numeric(x)) {
    sum(is.na(x))
  } else if (inherits(x, "Date") || inherits(x, "POSIXt")) {
    sum(is.na(x))
  } else {
    sum(is.na(x))
  }
})

# View missing values
head(missing_summary)
cat("\n Missing value summary created successfully!\n")

# Additional Checks
duplicates <- alt %>% filter(duplicated(ID))
invalid_coords <- alt %>% filter(Latitude < -90 | Latitude > 90 | Longitude < -180 | Longitude > 180)

# Logging Issues
log_entry("ID", paste(nrow(duplicates), "duplicates found"),
          "Will review duplicates manually",
          "Uniqueness", "n_distinct(ID)", "VARCHAR(255)")

log_entry("Latitude / Longitude", paste(nrow(invalid_coords), "invalid coordinates found"),
          "Filtered or corrected manually",
          "Accuracy", "Coordinate validation", "DECIMAL(10,6)")

# Export Clean Data and Logs
write_csv(alt, "Data/Alternative_Fuel_Stations_Clean.csv")
write_csv(clean_log, "Data/Alt_Data_Cleaning_Log.csv")

cat("\n Cleaned data saved as 'Alternative_Fuel_Stations_Clean.csv'\n")
cat(" Cleaning log saved as 'Alt_Data_Cleaning_Log.csv'\n")

# Summary
cat("\n Cleaning complete. Ready for SQL import.\n")
cat("Next step: Audit profiling again or load into SQL for EDA.\n")
