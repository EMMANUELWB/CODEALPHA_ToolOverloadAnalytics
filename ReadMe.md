# EV Infrastructure vs. Adoption: A Data-Driven Exploration
Exploring how the accessibility of EV charging stations influences the adoption of electric vehicles.  
Data from the **U.S. DOE Alternative Fuels Data Center** and the **Electric Vehicle Population dataset**, analyzed using **Excel, SQL, R, and Tableau**.

---

## Project Overview
This project is part of the **CodeAlpha Data Analytics Internship**.  
It focuses on understanding how the availability of EV (Electric Vehicle) charging stations impacts EV adoption rates across regions.  
The analysis uses a structured, data-driven workflow — covering **data profiling**, **cleaning**, **logging**, and later **exploratory data analysis (EDA)** and **SQL joins**.

---

## Objective
To explore the relationship between EV adoption and the accessibility of charging stations, and to evaluate whether regions with better charging infrastructure have higher EV penetration.

---

## Data Sources
1. **Electric Vehicle Population Data** — from U.S. government open data repositories.  
2. **Alternative Fuel Stations Data** — from the U.S. Department of Energy’s Alternative Fuels Data Center (AFDC).

---

## Folder Structure

| Folder          | Description                                   |
| --------------- | --------------------------------------------- |
| `Scripts/`      | R scripts for cleaning and profiling datasets |
| `Data/`         | Raw, cleaned, and logged data files           |
| `Reports/`      | Profiling summaries in CSV/Excel format       |
| `Dashboard/`    | Tableau visualizations and exported files     |
| `Presentation/` | Final presentation assets and visuals         |


---

## Data Cleaning and Profiling Summary
## Data Quality Dimensions Ensured

Both datasets were assessed and cleaned according to seven key data quality dimensions to ensure analytical reliability and transparency:
| Dimension        | Description                                                                  | Example in This Project                                                      |
| ---------------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| **Accuracy**     | Verified data values against official sources and corrected inconsistencies. | Checked vehicle manufacturers and model names for valid categories.          |
| **Completeness** | Addressed missing fields and ensured key identifiers existed.                | Filled or flagged null entries for `City`, `State`, and `FuelTypeCode`.      |
| **Consistency**  | Standardized naming conventions and data formats.                            | Used consistent `State` abbreviations and unified units for `ElectricRange`. |
| **Timeliness**   | Used the most recent and relevant dataset versions.                          | Incorporated AFDC and EV population data from 2024.                          |
| **Validity**     | Ensured each value met defined data type and domain rules.                   | Confirmed latitude/longitude values were within valid coordinate ranges.     |
| **Uniqueness**   | Removed duplicates across both datasets.                                     | Ensured unique `VIN` (vehicles) and `StationID` (charging stations).         |
| **Integrity**    | Maintained logical and relational consistency.                               | Preserved links between `Make`, `ModelYear`, and associated records.         |


### Electric Vehicle (EV) Dataset
- Handled missing values and standardized column names.  
- Converted date formats and categorical data types for consistency.  
- Calculated `ElectricRange` statistics — mean, median, outliers.  
- Logged all cleaning actions in a separate audit file for transparency.

**View Files**  
- [EV Data Cleaning Script (R)](Scripts/2_EV_Data_Cleaning.R)  
- [EV Raw Data](Data/1_Electric_Vehicle_Population_Data.csv)  
- [EV Cleaned Data](Data/2_Electric_Vehicle_Population_Clean.csv)  
- [EV Cleaning Log](Data/3_EV_Data_Cleaning_Log.csv)  
- [EV Profiling Report](Reports/EV_Profile.xlsx)

---

### Alternative Fuel Stations Dataset
- Cleaned station records, standardized addresses, and handled missing “Intersection Directions.”  
- Converted blank cells to `NULL` for SQL compatibility.  
- Verified latitude/longitude formats for geospatial joins.  
- Created a data cleaning log similar to the EV process.

**View Files**  
- [Alt Fuel Data Cleaning Script (R)](Scripts/3_Alt_Data_Cleaning_With_Log.R)  
- [Alt Fuel Raw Data](Data/4_Alternative_Fuel_Stations.csv)  
- [Alt Fuel Cleaned Data](Data/5_Alternative_Fuel_Stations_Clean.csv)  
- [Alt Fuel Cleaning Log](Data/6_Alt_Data_Cleaning_Log.csv)  
- [Alt Fuel Profiling Report](Reports/ALT_Profile.xlsx)

---

## Scripts and Workflow
1. **[1_Data_Profiling.R](Scripts/1_Data_Profiling.R)** — Profiles both datasets, checks data types, and detects anomalies.  
2. **[2_EV_Data_Cleaning.R](Scripts/2_EV_Data_Cleaning.R)** — Cleans and logs the Electric Vehicle dataset.  
3. **[3_Alt_Data_Cleaning_With_Log.R](Scripts/3_Alt_Data_Cleaning_With_Log.R)** — Cleans and logs the Alternative Fuel Stations dataset.

---

## 🧾 Next Steps — Exploratory Data Analysis (EDA)
Before proceeding to visualization and SQL joins, the next step is to:
- Ask meaningful questions such as:  
  *How does charger density relate to EV count per state or city?*  
  *Do regions with more public fast chargers show higher EV adoption?*  
- Explore the data structure, variables, and distributions using R and SQL.  
- Perform joins between the **EV** and **Alternative Fuel** datasets on location identifiers (state, city, ZIP).  
- Visualize findings using Tableau dashboards.

---

## Tools Used
- **R** for data cleaning, profiling, and transformation.  
- **SQL (MySQL)** for joining datasets and querying insights.  
- **Excel** for validation and quick exploration.  
- **Tableau** for visualization and storytelling.  

---

## Download the Project
Download the full repository as a ZIP file:  
 [Download Full Project (ZIP)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/archive/refs/heads/main.zip)

---

## Project Video
A short walkthrough video (to be posted on LinkedIn) will explain:
- Project overview and goals  
- Data sources and cleaning steps  
- Tools and workflow  
- Insights from profiling  
- Next steps (EDA and joins)

---

## Internship Details
This project fulfills **Task 1: Web Scraping / Data Cleaning** of the CodeAlpha Data Analytics Internship.  
The next phase covers **Task 2: Exploratory Data Analysis (EDA)**, using the cleaned datasets above.

---

© 2025 CodeAlpha Data Analytics Internship
