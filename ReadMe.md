# EV Infrastructure vs. Adoption: A Data-Driven Exploration
Exploring how the accessibility of EV charging stations influences the adoption of electric vehicles.  
Data from the **Electric Vehicle Population dataset**, analyzed using **Excel, SQL, R, and Tableau**.

---

## Project Overview

This project is part of the CodeAlpha Data Analytics Internship.
It focuses on uncovering insights from the Electric Vehicle (EV) Population dataset to understand adoption patterns, growth trends, and key performance indicators across the United States.

The analysis follows a structured, data-driven workflow from data profiling and cleaning to exploratory data analysis (EDA) and sql-driven insights.
---

## Objective 
To analyze key patterns and trends in electric vehicle (EV) adoption using data-driven insights from the EV Population dataset.
The study focuses on how EV adoption evolved over time, which manufacturers and regions lead the market, and how electric range and price vary across models and years.

---

## Data Sources
**Electric Vehicle Population Data** — from U.S. government open data repositories.  

---

## Business Questions Explored
The analysis was designed to answer the following data-driven business questions using R, SQL, and Excel:

1. EV Adoption Trends: How has the total number of registered EVs changed over the years, and is adoption accelerating?
2. Range Evolution: What is the relationship between EV model year and the average electric range of vehicles?
3. Price vs. Range Relationship: How do average EV prices correlate with their electric range across different models and years?
4. Manufacturer Dominance: Which manufacturers consistently lead in EV sales across years and regions?  
5. Regional Adoption Patterns: Which counties or regions contribute the most to overall EV adoption, and how do they compare to national trends? 

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

## Output
### Hypothesis Analysis Figures

The following figures illustrate key insights from the EV analyses conducted using R and SQL:

1. ### EV Adoption Trend with Regression

**Regression Equation:**  
`Total EVs = -4,434,325.17 + 2,203.34 × Year`  

**R-value:** 0.89  
**P-value:** < 0.001  

**Interpretation:**  
The analysis shows a strong positive relationship between year and total EV adoption (R = 0.89), indicating that the number of EVs grows substantially over time. The P-value (< 0.001) confirms the trend is statistically significant.  

On average, total EV adoption increases by approximately **2,203 vehicles per year**. The key takeaway is the upward slope, highlighting consistent growth in EV adoption over the years.
  
   ![EV Adoption Trend](https://github.com/EMMANUELWB/CodeAlpha__EV-Infrastructure-vs.-Adoption-A-Data-Driven-Exploration/blob/main/Reports/EV_Adoption_Trend_with_Regression.png)

2. ### 2. EV Range Trend Over Years

**Regression Equation:**  
`Average Electric Range = 232.43 - 0.0606 × Year`  

**R-value:** -0.01  
**P-value:** 0.97  

**Interpretation:**  
The correlation between model year and average electric range is almost zero (R = -0.01) and not statistically significant (P = 0.97).  
This shows that **there has been no meaningful change in average EV range over the years** in this dataset.
   ![EV Range Trend](https://github.com/EMMANUELWB/CodeAlpha__EV-Infrastructure-vs.-Adoption-A-Data-Driven-Exploration/blob/main/Reports/EV_Range_Trend_with_Regression.png)

3. ### 3. EV Price vs Range Analysis

**Regression Equation:**  
`Base MSRP = 0.0035 × Electric Range - 126.59`  

**R-value:** 0.58  
**P-value:** 0.00437  

**Interpretation:**  
There is a moderate positive correlation (R = 0.58) between EV price and range, statistically significant (P = 0.00437).  
This suggests that **EVs with longer ranges tend to be more expensive**, though other factors likely also influence pricing.
   ![EV Price vs Range](https://github.com/EMMANUELWB/CodeAlpha__EV-Infrastructure-vs.-Adoption-A-Data-Driven-Exploration/blob/main/Reports/EV_Price_vs_Range_with_Regression.png)

---

## Tools Used
- **R** for data cleaning, profiling, and transformation.  
- **SQL (MySQL)** for querying insights.  
- **Excel** for validation and quick exploration.  
- **Tableau** for visualization and storytelling.  

---
## Languages Used
- R
- SQL
---

