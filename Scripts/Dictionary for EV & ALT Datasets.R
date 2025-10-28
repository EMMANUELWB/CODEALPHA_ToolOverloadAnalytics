# ===============================================================
# 📘 Data Dictionary for EV & ALT Datasets
# Author: Emmanuel Agbo
# Purpose: Define meaning, type, and expectations for each column
# ===============================================================

# ---- Electric Vehicle (EV) Population Dictionary ----
ev_dictionary <- data.frame(
  Column_Name = c(
    "VIN_(1-10)", "County", "City", "State", "Postal_Code", "Model_Year", 
    "Make", "Model", "Electric_Vehicle_Type", "Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility",
    "Electric_Range", "Base_MSRP", "Legislative_District", "DOL_Vehicle_ID",
    "Vehicle_Location", "Electric_Utility", "2020_Census_Tract"
  ),
  Description = c(
    "First 10 chars of vehicle VIN", "County of registration", "City of registration",
    "Two-letter USPS state code", "5-digit ZIP code", "Vehicle model year",
    "Manufacturer", "Vehicle model name", "EV drivetrain type (BEV or PHEV)",
    "CAFV program eligibility", "Electric range (miles)", "Base MSRP (USD)",
    "WA Legislative District ID", "Unique vehicle ID (DOL record)",
    "Point geometry (longitude/latitude)", "Utility company", "Census tract code (2020)"
  ),
  Expected_DataType_R = c(
    rep("character", 4), "character", "numeric", "character", "character",
    "character", "character", "numeric", "numeric", "numeric", "numeric",
    "character", "character", "numeric"
  ),
  Expected_DataType_SQL = c(
    "VARCHAR(10)", "VARCHAR(100)", "VARCHAR(100)", "CHAR(2)", "VARCHAR(10)", 
    "INT", "VARCHAR(50)", "VARCHAR(50)", "VARCHAR(60)", "VARCHAR(80)", 
    "INT", "DECIMAL(10,2)", "INT", "BIGINT", "VARCHAR(100)", "VARCHAR(100)", "BIGINT"
  ),
  Key_Notes = c(
    "Duplicates expected (truncated VINs)", 
    "Trim whitespace; title case", 
    "Trim and title case", 
    "Limit to 50 U.S. states + DC; flag AP/AE/AA", 
    "Keep as text; retain leading zeros", 
    "Should be ≤ current year + 1", 
    "Uppercase standardization", 
    "Title case; fill blanks with 'Unknown'", 
    "Values: BEV / PHEV only", 
    "Simplify to Eligible / Not Eligible / Unknown", 
    "Numeric only; replace NAs with median if needed", 
    "0 means missing; ensure proper numeric", 
    "Some blanks expected", 
    "Unique ID; verify integrity", 
    "Parse lon/lat if needed", 
    "Split if multiple utilities separated by '|'", 
    "Geospatial reference"
  )
)

# ---- Alternative Fuel (ALT) Station Dictionary ----
alt_dictionary <- data.frame(
  Column_Name = c(
    "Fuel_Type_Code", "Station_Name", "Street_Address", "Intersection_Directions",
    "City", "State", "ZIP", "Plus4", "Station_Phone", "Status_Code", "Expected_Date",
    "Access_Days_Time", "Cards_Accepted", "EV_Level1_EVSE_Num", "EV_Level2_EVSE_Num",
    "EV_DC_Fast_Count", "EV_Network", "EV_Network_Web", "Latitude", "Longitude",
    "Open_Date", "Updated_At", "Owner_Type_Code", "Federal_Agency_ID", "Federal_Agency_Name",
    "Access_Code"
  ),
  Description = c(
    "Fuel/energy type (ELEC, CNG, LPG)", "Station name", "Street address",
    "Nearest intersection", "Station city", "State abbreviation", "ZIP code",
    "ZIP+4 extension", "Station phone number", "Operational status (E/P)",
    "Expected open date (planned sites)", "Access days and hours", "Accepted payment options",
    "Number of Level 1 chargers", "Number of Level 2 chargers", "Number of DC Fast chargers",
    "Charging network name", "Charging network website", "Latitude coordinate",
    "Longitude coordinate", "Open date", "Last updated timestamp", "Ownership code",
    "Federal agency ID", "Federal agency name", "Access code"
  ),
  Expected_DataType_R = c(
    "character", "character", "character", "character", "character", "character",
    "character", "character", "character", "character", "Date", "character",
    "character", "integer", "integer", "integer", "character", "character",
    "numeric", "numeric", "Date", "POSIXct", "character", "integer", "character", "character"
  ),
  Expected_DataType_SQL = c(
    "VARCHAR(10)", "VARCHAR(255)", "VARCHAR(255)", "VARCHAR(255)", "VARCHAR(100)", "CHAR(2)",
    "VARCHAR(15)", "VARCHAR(10)", "VARCHAR(50)", "CHAR(1)", "DATE", "VARCHAR(255)", "VARCHAR(255)",
    "INT", "INT", "INT", "VARCHAR(100)", "VARCHAR(255)", "DECIMAL(10,6)", "DECIMAL(10,6)",
    "DATE", "DATETIME", "VARCHAR(50)", "INT", "VARCHAR(150)", "VARCHAR(50)"
  ),
  Key_Notes = c(
    "Keep only ELEC for EVs", "Always present", "Minor formatting issues", "Often blank",
    "Trim and title case", "Limit to U.S. states only", "Keep as text (ZIP+letters)", 
    "Mostly blank", "Standardize format (e.g., (206)-555-1234)", 
    "Codes: E=Existing, P=Planned", "Mostly blank for existing stations",
    "Replace blanks with 'Unknown'", "Use simplified categories (Cash, Card, Proprietor)", 
    "Replace blanks with 0", "Replace blanks with 0", "Replace blanks with 0", 
    "Replace blanks with 'Non-Networked'", "Replace blanks with 'Unknown'", 
    "Valid between -90 and 90", "Valid between -180 and 180", 
    "YYYY-MM-DD format", "Datetime, remove UTC", 
    "FG, LG, SG, P, T → mapped to full names", "Numeric IDs, mostly blank", 
    "Mostly blank; optional", "Public/Private/Fleet"
  )
)

# ---- Export dictionaries ----
write.csv(ev_dictionary, "EV_Data_Dictionary.csv", row.names = FALSE)
write.csv(alt_dictionary, "ALT_Data_Dictionary.csv", row.names = FALSE)

cat("📘 Data dictionaries created successfully:\n - EV_Data_Dictionary.csv\n - ALT_Data_Dictionary.csv\n")
