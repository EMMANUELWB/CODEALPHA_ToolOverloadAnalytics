# EV Infrastructure vs. Adoption: A Data-Driven Exploration
Exploring how the accessibility of EV charging stations influences the adoption of electric vehicles.  
Data from the **Electric Vehicle Population dataset**, analyzed using **Excel, SQL, R, and Tableau**.

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
**Electric Vehicle Population Data** — from U.S. government open data repositories.  


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

### Data Profiling Overview
Before cleaning, both datasets underwent a **comprehensive profiling process** using R.  
This step helped identify data types, missing values, outliers, and distribution patterns to guide subsequent transformations.  

**Profiling Steps Included:**
- Detection of invalid or inconsistent records (e.g., missing coordinates or blank city names).  
- Summary statistics for numeric variables (`ElectricRange`, `BaseMSRP`, etc.).  
- Frequency analysis of categorical fields like `Make`, `ModelYear`, and `FuelTypeCode`.  
- Validation of relationships between geographic and vehicle data.  

Profiling ensured the datasets met all seven **data quality dimensions** — *accuracy, completeness, consistency, timeliness, validity, uniqueness, and integrity* — before cleaning began.

---

### Profiling Script and Reports

**Script Used**  
- [Data Profiling Script (R)](Scripts/1_Data_Profiling.R)

## View Online Reports

You can explore the interactive profiling summaries directly through **GitHub Pages**:

- [View EV Profiling Report Online](https://emmanuelwb.github.io/CodeAlpha__EV-Infrastructure-vs.-Adoption-A-Data-Driven-Exploration/Reports/EV_Profile.html)


---

## Data Quality Dimensions Ensured

Both datasets were assessed and cleaned according to seven key data quality dimensions to ensure analytical reliability and transparency:

| Dimension        | Description                                                                  | Example in This Project                                                      |
| ---------------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| **Accuracy**     | Verified data values against official sources and corrected inconsistencies. | Checked vehicle manufacturers and model names for valid categories.          |
| **Completeness** | Addressed missing fields and ensured key identifiers existed.                | Filled or flagged null entries for `City`, `State`, and `FuelTypeCode`.      |
| **Consistency**  | Standardized naming conventions and data formats.                            | Used consistent `State` abbreviations and unified units for `ElectricRange`. |
| **Timeliness**   | Used the most recent and relevant dataset versions.                          | Incorporated EV population data from 2024.                          |
| **Validity**     | Ensured each value met defined data type and domain rules.                   | Confirmed latitude/longitude values were within valid coordinate ranges.     |
| **Uniqueness**   | Removed duplicates across both datasets.                                     | Ensured unique `VIN` (vehicles) and `StationID` (charging stations).         |
| **Integrity**    | Maintained logical and relational consistency.                               | Preserved links between `Make`, `ModelYear`, and associated records.         |

---

### Electric Vehicle (EV) Dataset
- Handled missing values and standardized column names.  
- Converted date formats and categorical data types for consistency.  
- Calculated `ElectricRange` statistics — mean, median, outliers.  
- Logged all cleaning actions in a separate audit file for transparency.

**View Files**  
- [EV Data Cleaning Script (R)](Scripts/2_EV_Data_Cleaning.R)  
- [EV Raw Data (View on Google Sheet)](https://docs.google.com/spreadsheets/d/15xLDvIV2umCENDPPz9xq2_-1HC8duAfIflqRc0Scdf8/edit?usp=sharing)  
- [EV Raw Data (View)](https://github.com/EMMANUELWB/CodeAlpha__EV-Infrastructure-vs.-Adoption-A-Data-Driven-Exploration/raw/main/Data/1_Electric_Vehicle_Population_Data.csv)  

- [EV Cleaned Data (View on Google Sheet)](https://docs.google.com/spreadsheets/d/1bwQfKh6nN8H2uhL8yTBAc7N9ehSsqUqA-jrKhZ_N8Ug/edit?usp=sharing)  
- [EV Cleaned Data (View)](https://github.com/EMMANUELWB/CodeAlpha__EV-Infrastructure-vs.-Adoption-A-Data-Driven-Exploration/raw/main/Data/2_Electric_Vehicle_Population_Clean.csv)  

- [EV Cleaning Log (View)](https://github.com/EMMANUELWB/CodeAlpha__EV-Infrastructure-vs.-Adoption-A-Data-Driven-Exploration/blob/main/Data/3_EV_Data_Cleaning_Log.csv)  
- [EV Profiling Report (HTML Download)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/raw/main/Reports/EV_Profile.html)  

- [EV Adoption by Year (View CSV)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/raw/main/Data/EV_Adoption_By_Year.csv)  
- [EV Average Range by Year (View CSV)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/raw/main/Data/Average_Range_By_Year.csv)  
- [EV Price vs Range Data (View CSV)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/raw/main/Data/Price%20vs%20range%20query.csv)  
- [Top Manufacturers by Year (View CSV)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/raw/main/Data/Top%20manufacturers%20by%20year.csv)  
- [Top 10 Counties (View CSV)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/raw/main/Data/Top_10_Counties.csv)  
- [County Growth Index (View CSV)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/raw/main/Data/County%20growth%20index.csv)  
- [CAFV Eligibility Distribution (View CSV)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/raw/main/Data/CAFV_Eligibility_Distribution.csv)  
- [EV Distribution Map Data (View CSV)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/raw/main/Data/EV_Distribution_Map.csv)  
- [EV Average Range by Make (View CSV)](https://github.com/EMMANUELWB/CODEALPHA_ToolOverloadAnalytics/raw/main/Data/Average_Range_By_Make.csv)

---



## Scripts and Workflow
1. **[1_Data_Profiling.R](Scripts/1_Data_Profiling.R)** — Profiles both datasets, checks data types, and detects anomalies.  
2. **[2_EV_Data_Cleaning.R](Scripts/2_EV_Data_Cleaning.R)** — Cleans and logs the Electric Vehicle dataset.  
3. **[Hypothesis1_EV_Adoption_Trend..R](Scripts/Hypothesis1_EV_Adoption_Trend..R)** — Analyzes EV adoption trends over time, generates regression plot with correlation and equation.  
4. **[Hypothesis 2 – EV Range Over Time.R](Scripts/Hypothesis%202%20%E2%80%93%20EV%20Range%20Over%20Time.R)** — Examines how average EV range has evolved by model year, with regression analysis.  
5. **[Hypothesis 3 – Price vs Range.R](Scripts/Hypothesis%203%20%E2%80%93%20Price%20vs%20Range.R)** — Investigates the relationship between vehicle price and range using regression and correlation.  
6. **[ev-script.sql](Scripts/ev-script.sql)** — Contains SQL queries for summarizing, and analyzing EV datasets.

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
- **SQL (MySQL)** for querying insights.  
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
