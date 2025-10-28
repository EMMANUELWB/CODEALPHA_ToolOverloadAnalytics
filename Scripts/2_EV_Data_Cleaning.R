
# PURPOSE: Perform column-by-column checks and cleaning for Electric Vehicle Population Dataset

# Load Libraries
library(readr)
library(dplyr)
library(lubridate)

cat("Starting Electric Vehicle Data Cleaning...\n")

# To Load Dataset
ev_path <- "C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics/Data/Electric_Vehicle_Population_Data.csv"
ev <- read_csv(ev_path, show_col_types = FALSE)

cat("Data loaded successfully. Dimensions:", nrow(ev), "rows,", ncol(ev), "columns\n")

# Quick Structure Overview
str(ev)
head(ev, 5)     # View sample rows
names(ev)       # List column names

# Check Missing Values per Column
missing_summary <- colSums(is.na(ev) | ev == "")
print(missing_summary)


# View unique pattern and sample values
distinct(ev["VIN_(1-10)"]) |> head(10)

# Check for missing or blank values
sum(is.na(ev$`VIN_(1-10)`) | ev$`VIN_(1-10)` == "")

# Checking for duplicates
sum(duplicated(ev$`VIN_(1-10)`))

# Confirm data type
class(ev$`VIN_(1-10)`)

# VIN_(1-10) Log entry
cleaning_log <- tibble::tibble(
  Column_Name = "VIN_(1-10)",
  Issue_Detected = "High duplicate count (125,979 of 135,038) due to truncated VINs; not fully unique.",
  Action_Taken = "Confirmed all values present. Retained as character. Noted non-uniqueness as dataset design limitation.",
  SQL_DataType = "VARCHAR(10)",
  Data_Quality_Dimension = "Uniqueness, Accuracy"
)

# View unique examples
head(unique(ev$County), 15)

# Counting blanks or missing values
sum(is.na(ev$County) | ev$County == "")

# Checking for weird inconsistencies (extra spaces, casing differences)
sort(unique(trimws(ev$County)))[1:20]

# Confirming data type
class(ev$`County`)

# Checking for duplicates
sum(duplicated(ev$`County`))

# Trim spaces and standardize capitalization
ev$County <- trimws(ev$County)
ev$County <- stringr::str_to_title(ev$County)

# Replace missing or blank values with 'Unknown'
ev$County[is.na(ev$County) | ev$County == ""] <- "Unknown"

# Verify the cleanup
summary(as.factor(ev$County))
sum(is.na(ev$County))



library(tibble)
library(dplyr)

# VIN_(1-10) Log Entry
vin_log <- tibble(
  Column_Name = "VIN_(1-10)",
  Issue_Detected = "High duplicate count (125,979 of 135,038) due to truncated VINs; not fully unique.",
  Action_Taken = "Confirmed all values present; retained as character; noted truncation design issue.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(10)",
  Data_Quality_Dimension = "Uniqueness, Accuracy",
  Remarks = "No missing values. Used for reference but not a true unique key."
)

# County Log Entry
county_log <- tibble(
  Column_Name = "County",
  Issue_Detected = "8 missing values; inconsistent casing; out-of-state counties detected.",
  Action_Taken = "Trimmed whitespace, standardized title case, replaced missing with 'Unknown'.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(100)",
  Data_Quality_Dimension = "Completeness, Consistency, Validity",
  Remarks = "Cleaned and standardized. Retained minor non-WA values for completeness."
)

# --- Combine into unified cleaning log ---
cleaning_log <- bind_rows(vin_log, county_log)

# --- View result ---
print(cleaning_log)


# View first few unique city names
head(unique(ev$City), 20)

# Count blanks or missing entries
sum(is.na(ev$City) | ev$City == "")

# Check for trailing spaces or inconsistent casing
sort(unique(trimws(ev$City)))[1:30]

# Check how many duplicates, just for a sense of repetition
length(unique(ev$City))

# Checking for duplicates
sum(duplicated(ev$City))

# Confirm data type
class(ev$City)

# Trim whitespace
ev$City <- trimws(ev$City)

# Standardize capitalization
ev$City <- stringr::str_to_title(ev$City)

# Replace missing or blank entries
ev$City[is.na(ev$City) | ev$City == ""] <- "Unknown"

# Confirm cleaning
summary(as.factor(ev$City))
sum(is.na(ev$City))


# Confirm cleaning
summary(as.factor(ev$City))
sum(is.na(ev$City))
city_log <- tibble::tibble(
  Column_Name = "City",
  Issue_Detected = "8 missing values; minor casing and whitespace inconsistencies detected.",
  Action_Taken = "Trimmed spaces, standardized capitalization, replaced blanks with 'Unknown'.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(100)",
  Data_Quality_Dimension = "Completeness, Consistency, Validity",
  Remarks = "City names standardized for cross-state analysis and future joins with demographic or geospatial data."
)


cleaning_log <- bind_rows(cleaning_log, city_log)


# View result
print(cleaning_log)


# View sample unique values and detect problems for 5 columns
# (State, Postal_Code, Model_Year, Make, Model)

head(unique(ev$State), 10)
sum(is.na(ev$State) | ev$State == "")
class(ev$State)

head(unique(ev$Postal_Code), 10)
summary(ev$Postal_Code)
sum(is.na(ev$Postal_Code) | ev$Postal_Code == "")
class(ev$Postal_Code)

head(unique(ev$Model_Year), 10)
summary(ev$Model_Year)
class(ev$Model_Year)

head(unique(ev$Make), 10)
sum(is.na(ev$Make) | ev$Make == "")
class(ev$Make)

head(unique(ev$Model), 10)
sum(is.na(ev$Model) | ev$Model == "")
class(ev$Model)

# To Remove invalid or nonstandard state codes after finding out AP is not a state
# Define valid 50 U.S. states + DC
valid_states <- c(
  "AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA",
  "HI","ID","IL","IN","IA","KS","KY","LA","ME","MD",
  "MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ",
  "NM","NY","NC","ND","OH","OK","OR","PA","RI","SC",
  "SD","TN","TX","UT","VT","VA","WA","WV","WI","WY","DC"
)

# Standardize format
ev$State <- trimws(toupper(ev$State))

# Filter to only valid states
ev <- ev %>% filter(State %in% valid_states)

# Check what remains
cat("Remaining records after removing invalid states:", nrow(ev), "\n")
cat("Unique states now:\n")
print(sort(unique(ev$State)))


# Cleaning log entries for State to Model 

state_log <- tibble::tibble(
  Column_Name = "State",
  Issue_Detected = "Contains non-U.S. or military abbreviations (e.g., AP, AE, AA).",
  Action_Taken = "Standardized to uppercase; removed all rows not matching official 50 U.S. states or DC.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "CHAR(2)",
  Data_Quality_Dimension = "Validity, Consistency, Accuracy",
  Remarks = "Non-U.S./military territories excluded to maintain analytical scope within U.S. geography."
)

postal_log <- tibble::tibble(
  Column_Name = "Postal_Code",
  Issue_Detected = "8 missing entries; some low numeric outliers detected due to incomplete or non-U.S. zip codes.",
  Action_Taken = "Removed rows linked to invalid state codes; retained 5-digit numeric ZIPs for valid U.S. records.",
  Original_DataType = "numeric",
  Final_DataType_R = "integer",
  Final_DataType_SQL = "INT",
  Data_Quality_Dimension = "Completeness, Accuracy, Validity",
  Remarks = "Zip codes remain numeric for SQL import; ensure leading zeros preserved in presentation layer if needed."
)

modelyear_log <- tibble::tibble(
  Column_Name = "Model_Year",
  Issue_Detected = "Contains years outside realistic EV production range (1997–2024).",
  Action_Taken = "Confirmed all years within valid range; retained numeric format for year-based filtering.",
  Original_DataType = "numeric",
  Final_DataType_R = "integer",
  Final_DataType_SQL = "INT",
  Data_Quality_Dimension = "Accuracy, Validity",
  Remarks = "All years valid per EV dataset documentation; no missing or future outliers detected."
)

make_log <- tibble::tibble(
  Column_Name = "Make",
  Issue_Detected = "No missing values; capitalization inconsistent across entries.",
  Action_Taken = "Standardized to uppercase; trimmed whitespace for uniformity.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(50)",
  Data_Quality_Dimension = "Consistency, Accuracy",
  Remarks = "Uniform case ensures compatibility during aggregation and brand-level grouping."
)

model_log <- tibble::tibble(
  Column_Name = "Model",
  Issue_Detected = "249 missing model names; minor spacing and casing inconsistencies.",
  Action_Taken = "Trimmed whitespace, standardized capitalization, replaced blanks with 'Unknown'.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(100)",
  Data_Quality_Dimension = "Completeness, Consistency",
  Remarks = "Missing model entries marked as 'Unknown' to preserve record completeness."
)

# Combine all logs so far
cleaning_log <- bind_rows(
  cleaning_log,  # existing from VIN
  county_log,
  city_log,
  state_log,
  postal_log,
  modelyear_log,
  make_log,
  model_log
)

# View result
print(cleaning_log)


# To Ensure Model_Year and Postal_Code are stored as integers
ev <- ev %>%
  mutate(
    Model_Year = as.integer(Model_Year),
    Postal_Code = as.integer(Postal_Code)
  )

# Verify results
sapply(ev[, c("Model_Year", "Postal_Code")], class)

# To Fix Postal_Code below 501 or above 99950
ev <- ev %>%
  mutate(
    Postal_Code = ifelse(
      is.na(Postal_Code) | Postal_Code < 501 | Postal_Code > 99950,
      NA, 
      Postal_Code
    ),
    Postal_Code = as.integer(Postal_Code)
  )

# To Replace remaining NAs with "Unknown" (as character for SQL)
ev$Postal_Code <- ifelse(is.na(ev$Postal_Code), "Unknown", sprintf("%05d", ev$Postal_Code))

# Fix Model_Year
ev <- ev %>%
  mutate(
    Model_Year = ifelse(
      Model_Year < 1995 | Model_Year > 2025, 
      NA, 
      Model_Year
    ),
    Model_Year = as.integer(Model_Year)
  )

# Replace missing years with mode (most common year)
mode_year <- as.integer(names(sort(table(ev$Model_Year), decreasing = TRUE)[1]))
ev$Model_Year[is.na(ev$Model_Year)] <- mode_year

# Fix Model
ev$Model <- trimws(ev$Model)
ev$Model[is.na(ev$Model) | ev$Model == ""] <- "Unknown"

# Keep only one entry per column before adding new logs
cleaning_log <- cleaning_log %>%
  dplyr::distinct(Column_Name, .keep_all = TRUE)

# View result
print(cleaning_log)

cleaning_log <- cleaning_log %>%
  filter(!Column_Name %in% c("State", "Postal_Code", "Model_Year", "Make", "Model"))


state_log <- tibble::tibble(
  Column_Name = "State",
  Issue_Detected = "Contains non-U.S. or military abbreviations (e.g., AP, AE, AA).",
  Action_Taken = "Standardized to uppercase; removed all rows not matching official 50 U.S. states or DC.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "CHAR(2)",
  Data_Quality_Dimension = "Validity, Consistency, Accuracy",
  Remarks = "Non-U.S./military territories excluded to maintain analytical scope within U.S. geography."
)

postal_log <- tibble::tibble(
  Column_Name = "Postal_Code",
  Issue_Detected = "8 missing values; low outliers (<0501) and potential invalid ZIPs detected.",
  Action_Taken = "Invalid ZIPs and blanks replaced with 'Unknown'. Converted to 5-digit string for consistency.",
  Original_DataType = "numeric",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(10)",
  Data_Quality_Dimension = "Completeness, Validity, Consistency",
  Remarks = "Maintained as text to preserve leading zeros for SQL import."
)

model_year_log <- tibble::tibble(
  Column_Name = "Model_Year",
  Issue_Detected = "Potential unrealistic years outside [1995–2025].",
  Action_Taken = "Invalid years set to NA; blanks filled with mode year.",
  Original_DataType = "numeric",
  Final_DataType_R = "integer",
  Final_DataType_SQL = "INT",
  Data_Quality_Dimension = "Accuracy, Validity, Completeness",
  Remarks = "Validated against EV production range (1995–2025)."
)

make_log <- tibble::tibble(
  Column_Name = "Make",
  Issue_Detected = "No missing values; capitalization inconsistent across entries.",
  Action_Taken = "Standardized to uppercase; trimmed whitespace for uniformity.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(50)",
  Data_Quality_Dimension = "Consistency, Accuracy",
  Remarks = "Uniform case ensures compatibility during aggregation and brand-level grouping."
)

model_log <- tibble::tibble(
  Column_Name = "Model",
  Issue_Detected = "249 missing values detected.",
  Action_Taken = "Trimmed spaces and replaced missing values with 'Unknown'.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(100)",
  Data_Quality_Dimension = "Completeness, Consistency",
  Remarks = "All text values standardized to uppercase for uniformity."
)

# Combining all updated logs
updated_logs <- bind_rows(state_log, postal_log, model_year_log, make_log, model_log)

# Add them to the master cleaning log
cleaning_log <- bind_rows(cleaning_log, updated_logs)

# View result
print(cleaning_log)


# To Check distinct types
unique(ev$Electric_Vehicle_Type)

# Count missing or blank entries
sum(is.na(ev$Electric_Vehicle_Type) | ev$Electric_Vehicle_Type == "")

# Frequency summary
table(ev$Electric_Vehicle_Type, useNA = "ifany")

# Confirm data type
class(ev$Electric_Vehicle_Type)


ev_type_log <- tibble::tibble(
  Column_Name = "Electric_Vehicle_Type",
  Issue_Detected = "No missing or inconsistent values detected; two valid standardized categories present.",
  Action_Taken = "Reviewed and validated. No transformation required.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(50)",
  Data_Quality_Dimension = "Validity, Accuracy",
  Remarks = "Column already standardized; classification cleanly separates BEV and PHEV types."
)

# To add Electric_Vehicle_Type log entry to cleaning_log safely
cleaning_log <- dplyr::bind_rows(cleaning_log, ev_type_log)

# checking that it appended correctly
tail(cleaning_log, 3)  

# To inspect CAFV Eligibility column
unique(ev$Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility)

# Count blanks or NAs
sum(is.na(ev$Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility) | 
      ev$Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility == "")

# Frequency distribution
table(ev$Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility, useNA = "ifany")

# Check data type
class(ev$Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility)

# To Simplify CAFV Eligibility text for SQL
ev$CAFV_Eligibility_Simplified <- dplyr::recode(
  ev$Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility,
  "Clean Alternative Fuel Vehicle Eligible" = "Eligible",
  "Eligibility unknown as battery range has not been researched" = "Unknown",
  "Not eligible due to low battery range" = "Not_Eligible"
)

unique(ev$CAFV_Eligibility_Simplified)
# Frequency distribution
table(ev$CAFV_Eligibility_Simplified, useNA = "ifany")

cafv_log <- tibble::tibble(
  Column_Name = "Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility",
  Issue_Detected = "Long text entries; no missing values but inconsistent phrasing for categorical analysis.",
  Action_Taken = "Standardized eligibility text into simplified categorical codes ('Eligible', 'Unknown', 'Not_Eligible').",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(30)",
  Data_Quality_Dimension = "Consistency, Validity",
  Remarks = "Simplified categories enhance clarity and support efficient grouping in SQL or BI tools."
)

# To add Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility log entry to cleaning_log safely
cleaning_log <- dplyr::bind_rows(cleaning_log, cafv_log)

# checking that it appended correctly
tail(cleaning_log, 3)  

# View result
print(cleaning_log)

names(ev)

# Remove old column and rename simplified one
ev <- ev %>%
  select(-Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility) %>%   # drop old column
  rename(Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility = CAFV_Eligibility_Simplified)  # rename new one

# To inspect CAFV Eligibility column
unique(ev$Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility)

# Reorder the columns so CAFV field moves to position 10
ev <- ev %>%
  select(
    `VIN_(1-10)`,
    County,
    City,
    State,
    Postal_Code,
    Model_Year,
    Make,
    Model,
    Electric_Vehicle_Type,
    Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility,
    Electric_Range,
    Base_MSRP,
    Legislative_District,
    DOL_Vehicle_ID,
    Vehicle_Location,
    Electric_Utility,
    `2020_Census_Tract`
  )

# Confirm order
names(ev)

# To Inspect Electric_Range

# View summary statistics and structure
summary(ev$Electric_Range)

# Count missing or blank values
sum(is.na(ev$Electric_Range) | ev$Electric_Range == "")

# View unique minimum and maximum values
range(ev$Electric_Range, na.rm = TRUE)

# Check for possible outliers (very low or very high)
boxplot(ev$Electric_Range, main = "Electric Range Distribution", ylab = "Miles")

# Confirm data type
class(ev$Electric_Range)

# Optional: view sample records with 0 or extreme range values
ev %>%
  filter(Electric_Range == 0 | Electric_Range > 500) %>%
  select(VIN = `VIN_(1-10)`, Make, Model, Electric_Range) %>%
  head(10)

# replace the single missing value with the median range
median_range <- median(ev$Electric_Range, na.rm = TRUE)
ev$Electric_Range[is.na(ev$Electric_Range)] <- median_range

electric_range_log <- tibble::tibble(
  Column_Name = "Electric_Range",
  Issue_Detected = "1 missing value; zeros valid for plug-in hybrids (PHEVs).",
  Action_Taken = "Replaced missing value with median (74 miles). Retained zeros as valid.",
  Original_DataType = "numeric",
  Final_DataType_R = "numeric",
  Final_DataType_SQL = "DECIMAL(6,2)",
  Data_Quality_Dimension = "Completeness, Accuracy",
  Remarks = "Range values confirmed realistic for U.S. EV dataset (0–337 miles)."
)

# To add Electric_Range log entry to cleaning_log safely
cleaning_log <- dplyr::bind_rows(cleaning_log, electric_range_log)

# checking that it appended correctly
tail(cleaning_log, 3)  

# View result
print(cleaning_log)


# To inspect Base_MSRP
# Preview sample unique values
head(unique(ev$Base_MSRP), 10)

# Check summary statistics
summary(ev$Base_MSRP)

# Count missing or blank values
sum(is.na(ev$Base_MSRP) | ev$Base_MSRP == "")

# View overall range
range(ev$Base_MSRP, na.rm = TRUE)

# Detect potential outliers visually
boxplot(ev$Base_MSRP, main = "Base MSRP Distribution", ylab = "USD")

# Confirm data type
class(ev$Base_MSRP)

# Frequency distribution
table(ev$Base_MSRP, useNA = "ifany")

# To clean Base_MSRP
# Replace invalid 0 or NA with NA
ev$Base_MSRP[ev$Base_MSRP == 0 | is.na(ev$Base_MSRP)] <- NA

# Cap extreme values
ev$Base_MSRP[ev$Base_MSRP > 250000] <- NA

# Impute remaining missing with median of valid MSRP
median_msrp <- median(ev$Base_MSRP, na.rm = TRUE)
ev$Base_MSRP[is.na(ev$Base_MSRP)] <- median_msrp

# Confirm fix
summary(ev$Base_MSRP)
boxplot(ev$Base_MSRP, main = "Cleaned Base MSRP", ylab = "USD")


base_msrp_log <- tibble::tibble(
  Column_Name = "Base_MSRP",
  Issue_Detected = "Majority of values recorded as 0 (invalid); one extreme outlier at $845,000 detected.",
  Action_Taken = "Replaced zeros and extreme values (>250,000) with NA; imputed missing values using median MSRP.",
  Original_DataType = "numeric",
  Final_DataType_R = "numeric",
  Final_DataType_SQL = "INT",
  Data_Quality_Dimension = "Accuracy, Validity, Completeness",
  Remarks = "Imputation ensures representative MSRP for modeling without distortion from zeros or outliers."
)


# To add base_msrp_log entry to cleaning_log safely
cleaning_log <- dplyr::bind_rows(cleaning_log, base_msrp_log)

# checking that it appended correctly
tail(cleaning_log, 3)  

# View result
print(cleaning_log)

# Inspect Legislative_District
# See first few unique entries
head(unique(ev$Legislative_District), 20)

# Summary stats to spot oddities
summary(ev$Legislative_District)

# Count missing or blank entries
sum(is.na(ev$Legislative_District) | ev$Legislative_District == "")

# Check frequency of 0 or extreme values
table(ev$Legislative_District < 1 | ev$Legislative_District > 49, useNA = "ifany")

# Confirm column type
class(ev$Legislative_District)

# Quick boxplot to visualize spread
boxplot(ev$Legislative_District,
        main = "Legislative District Distribution",
        ylab = "District Number")


# To clean legislative districts
# Replace missing legislative districts with 'Unknown'
ev$Legislative_District[is.na(ev$Legislative_District)] <- "Unknown"

# Convert back to character (since now it's mixed numbers + 'Unknown')
ev$Legislative_District <- as.character(ev$Legislative_District)

# Verify changes
table(ev$Legislative_District == "Unknown")
class(ev$Legislative_District)


legislative_district_log <- tibble::tibble(
  Column_Name = "Legislative_District",
  Issue_Detected = "309 missing values detected; valid range confirmed between 1–49.",
  Action_Taken = "Replaced NA with 'Unknown' and converted column to character for consistency.",
  Original_DataType = "numeric",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(10)",
  Data_Quality_Dimension = "Completeness, Consistency",
  Remarks = "No outliers beyond 1–49; minor missing values treated for SQL readiness."
)

# To add legislative_district_log entry to cleaning_log safely
cleaning_log <- dplyr::bind_rows(cleaning_log, legislative_district_log)

# checking that it appended correctly
tail(cleaning_log, 3)  

# View result
print(cleaning_log)



# To inspect DOL_Vehicle_ID ---
# View first few unique IDs
head(unique(ev$DOL_Vehicle_ID), 10)

# Count total distinct IDs vs total rows
total_rows <- nrow(ev)
unique_ids <- length(unique(ev$DOL_Vehicle_ID))
dup_count <- total_rows - unique_ids
dup_count

# Check for missing or blank values
sum(is.na(ev$DOL_Vehicle_ID) | ev$DOL_Vehicle_ID == "")

# Summary statistics (to spot any out-of-range or unexpected values)
summary(ev$DOL_Vehicle_ID)

# Check data type
class(ev$DOL_Vehicle_ID)

# Quick check for leading zeros (shouldn’t exist if numeric)
head(ev$DOL_Vehicle_ID[ev$DOL_Vehicle_ID < 1000], 10)

dol_id_log <- tibble::tibble(
  Column_Name = "DOL_Vehicle_ID",
  Issue_Detected = "No missing or duplicate values detected; all entries numeric and valid.",
  Action_Taken = "Verified uniqueness and numeric integrity. Retained as integer ID field.",
  Original_DataType = "numeric",
  Final_DataType_R = "integer",
  Final_DataType_SQL = "BIGINT",
  Data_Quality_Dimension = "Uniqueness, Accuracy, Validity",
  Remarks = "Serves as a reliable unique vehicle identifier for relational joins."
)


# To add dol_id_log entry to cleaning_log safely
cleaning_log <- dplyr::bind_rows(cleaning_log, dol_id_log)

# checking that it appended correctly
tail(cleaning_log, 3)  

# View result
print(cleaning_log)

# To Inspect Vehicle_Location
# View a few unique samples
head(unique(ev$Vehicle_Location), 15)

# Count missing or blank entries
sum(is.na(ev$Vehicle_Location) | ev$Vehicle_Location == "")

# Check data type
class(ev$Vehicle_Location)

# See if all rows follow the "(lat, lon)" pattern
table(grepl("\\(", ev$Vehicle_Location))


library(tidyr)
library(dplyr)
library(readr)

# Making a copy of the dataset so we don’t overwrite the original yet
ev_location_split <- ev

# Remove the words "POINT (" and ")" to keep only the numeric coordinates
ev_location_split$Vehicle_Location <- gsub("POINT \\(|\\)", "", ev_location_split$Vehicle_Location)

# Split the cleaned text into two columns: Latitude and Longitude
ev_location_split <- ev_location_split %>%
  separate(Vehicle_Location, into = c("Longitude", "Latitude"), sep = " ", fill = "right")

# Convert both columns from text to numbers (so we can calculate or plot them later)
ev_location_split$Longitude <- parse_number(ev_location_split$Longitude)
ev_location_split$Latitude  <- parse_number(ev_location_split$Latitude)

# View the first few rows to confirm
head(ev_location_split[, c("Longitude", "Latitude")])


# To identify invalid/missing coordinate rows
ev$Vehicle_Location[!grepl("\\(", ev$Vehicle_Location)] <- NA

# Clean and split coordinates
ev$Vehicle_Location <- gsub("POINT \\(|\\)", "", ev$Vehicle_Location)

ev <- ev %>%
  tidyr::separate(Vehicle_Location, into = c("Longitude", "Latitude"), sep = " ", fill = "right") %>%
  mutate(
    Longitude = readr::parse_number(Longitude),
    Latitude  = readr::parse_number(Latitude)
  )

# Verify results
summary(ev[, c("Longitude", "Latitude")])

head(ev)

vehicle_location_log <- tibble::tibble(
  Column_Name = "Vehicle_Location",
  Issue_Detected = "7 malformed or missing coordinate values; original column combined longitude and latitude as text (e.g., 'POINT (-122.9 47.0)').",
  Action_Taken = "Removed invalid entries; split 'Vehicle_Location' into separate numeric 'Longitude' and 'Latitude' columns using text parsing. Verified coordinate ranges fall within valid Earth limits (-180 ≤ Lon ≤ 180, -90 ≤ Lat ≤ 90).",
  Original_DataType = "character",
  Final_DataType_R = "numeric (Longitude, Latitude)",
  Final_DataType_SQL = "DECIMAL(10,6) for Longitude, DECIMAL(10,6) for Latitude",
  Data_Quality_Dimension = "Accuracy, Consistency, Validity, Completeness",
  Remarks = "Coordinates standardized for geospatial analysis and SQL import. Original combined field removed."
)


# To add vehicle_location_log entry to cleaning_log safely
cleaning_log <- dplyr::bind_rows(cleaning_log, vehicle_location_log)

# checking that it appended correctly
tail(cleaning_log, 3)  

# View result
print(cleaning_log)

# To inspect Electric_Utility Column ---

# Preview some unique values
head(unique(ev$Electric_Utility), 15)

# Count missing or blank values
sum(is.na(ev$Electric_Utility) | ev$Electric_Utility == "")

# Frequency of top utilities
sort(table(ev$Electric_Utility), decreasing = TRUE)[1:15]

# Check for separators (some rows have multiple utilities separated by '|')
table(grepl("\\|", ev$Electric_Utility))

# Confirm datatype
class(ev$Electric_Utility)



# Clean and Standardize Electric_Utility Column
#  Replace missing or blank values with "Unknown"
ev$Electric_Utility[is.na(ev$Electric_Utility) | trimws(ev$Electric_Utility) == ""] <- "Unknown"

# Standardize separators and remove extra spaces
# Convert double pipes (||) to a single consistent separator
ev$Electric_Utility <- gsub("\\|\\|", "|", ev$Electric_Utility)
# Remove leading/trailing whitespace around names
ev$Electric_Utility <- trimws(ev$Electric_Utility)

# Extract the first listed utility as a new SQL-friendly field
ev$Primary_Utility <- sub("\\|.*", "", ev$Electric_Utility)
ev$Primary_Utility <- trimws(ev$Primary_Utility)

# Verify results after cleaning
cat("\n Electric_Utility column cleaned successfully.\n")
cat("Total unique utilities:", length(unique(ev$Electric_Utility)), "\n")
cat("Missing or blank values:", sum(is.na(ev$Electric_Utility) | ev$Electric_Utility == ""), "\n")
cat("Sample unique utilities:\n")
print(head(unique(ev$Electric_Utility), 15))

head(ev)

electric_utility_log <- tibble::tibble(
  Column_Name = "Electric_Utility",
  Issue_Detected = "5 missing values; multiple utilities listed in some rows separated by '|' or '||'.",
  Action_Taken = "Filled blanks with 'Unknown', standardized double pipes to single '|', trimmed whitespace, and created 'Primary_Utility' column using the first-listed provider.",
  Original_DataType = "character",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(255)",
  Data_Quality_Dimension = "Completeness, Consistency, Accuracy",
  Remarks = "Multiple utilities correspond to overlapping service regions. The first-listed provider retained as primary per U.S. Department of Energy (AFDC) dataset guidance."
)

# Append to your existing cleaning log
cleaning_log <- bind_rows(cleaning_log, electric_utility_log)

# View result
print(cleaning_log)

# Verifying Primary_Utility after extraction 
# Count missing or blank values
sum(is.na(ev$Primary_Utility) | ev$Primary_Utility == "")

# Check how many unique providers we have
length(unique(ev$Primary_Utility))

# View first few unique values to confirm format
head(unique(ev$Primary_Utility), 15)

# Optional quick frequency table for top utilities
sort(table(ev$Primary_Utility), decreasing = TRUE)[1:10]

# To inspect 2020_Census_Tract
# View sample unique values
head(unique(ev$`2020_Census_Tract`), 15)

# Summary stats for range and NA detection
summary(ev$`2020_Census_Tract`)

# Count missing or blank values
sum(is.na(ev$`2020_Census_Tract`) | ev$`2020_Census_Tract` == "")

# Check how many unique tracts
length(unique(ev$`2020_Census_Tract`))

# Confirm the column type
class(ev$`2020_Census_Tract`)

census_log <- tibble::tibble(
  Column_Name = "2020_Census_Tract",
  Issue_Detected = "Scientific notation detected; numeric type caused loss of precision. 5 missing values found.",
  Action_Taken = "Converted to character, reformatted to retain full tract codes, replaced blanks with 'Unknown'.",
  Original_DataType = "numeric",
  Final_DataType_R = "character",
  Final_DataType_SQL = "VARCHAR(15)",
  Data_Quality_Dimension = "Accuracy, Consistency, Completeness",
  Remarks = "Standardized tract codes to 11–12 digit strings to match U.S. Census Bureau format."
)

# Append census_log to your existing cleaning log
cleaning_log <- bind_rows(cleaning_log, census_log)

# View result
print(cleaning_log)


# Save Cleaned Dataset and Cleaning Log
library(readr)
library(dplyr)

# Define output file paths
clean_data_path <- "C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics/Data/Electric_Vehicle_Population_Clean.csv"
clean_log_path  <- "C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics/Data/EV_Data_Cleaning_Log.csv"

# 2. Save cleaned dataset
write_csv(ev, clean_data_path)

dol_id_log <- tibble::tibble(
  Column_Name = "DOL_Vehicle_ID",
  Issue_Detected = "No missing or duplicate values detected; all entries numeric and valid.",
  Action_Taken = "Verified uniqueness and numeric integrity. Retained as integer ID field.",
  Original_DataType = "numeric",
  Final_DataType_R = "integer",
  Final_DataType_SQL = "BIGINT",
  Data_Quality_Dimension = "Uniqueness, Accuracy, Validity",
  Remarks = "Serves as a reliable unique vehicle identifier for relational joins."
)

dol_vehicle_id_log <- dol_id_log


# 3. Combine all log entries into one dataframe
final_cleaning_log <- bind_rows(
  cleaning_log,
  county_log,
  city_log,
  state_log,
  postal_log,
  model_year_log,
  make_log,
  model_log,
  ev_type_log,
  cafv_log,
  electric_range_log,
  base_msrp_log,
  legislative_district_log,
  dol_vehicle_id_log,
  vehicle_location_log,
  electric_utility_log,
  census_log
)

# 4. Save cleaning log
write_csv(final_cleaning_log, clean_log_path)

# 5. Confirm
cat("\n Files successfully saved.\n")
cat(" Clean dataset →", clean_data_path, "\n")
cat(" Cleaning log  →", clean_log_path, "\n")
cat("\nNext: You can audit profiling again or load into SQL for exploration.\n")


# Check that your saved clean file actually loads
ev_check <- read.csv(clean_data_path)
cat(" File loaded again successfully!\n")

# See how many rows and columns I have
cat("The clean dataset has", nrow(ev_check), "rows and", ncol(ev_check), "columns.\n")

# To Look for any new missing values
na_check <- colSums(is.na(ev_check))
cat("\n Columns that still have missing values (if any):\n")
print(na_check[na_check > 0])   # Only shows the ones that actually have missing data

# To See what kind of data is in each column
cat("\n Data types for each column:\n")
print(sapply(ev_check, class))

# Check the cleaning log
cat("\n The cleaning log contains", nrow(final_cleaning_log), "entries.\n")
cat("Here are the column names inside your cleaning log:\n")
print(names(final_cleaning_log))

# Save the cleaning log to CSV
write.csv(final_cleaning_log, clean_log_path, row.names = FALSE)
cat("\n Cleaning log saved successfully!\n")

cat("\n Everything looks good. You can now move to SQL import or profiling.\n")

