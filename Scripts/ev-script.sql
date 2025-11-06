/* GitHub language detection override
   This is a placeholder to ensure this file is recognized as SQL
*/


-- EV SQL Analysis Script
-- will Contains queries for analyzing EV adoption, charger density,
-- average range by model year, price vs range correlations,
-- and top manufacturers per year.



-- Create a new database for EV analysis
CREATE DATABASE ev_analysis;

-- Select the database to use
USE ev_analysis;

-- Create the EV data table with all necessary columns
CREATE TABLE ev_data (
    `VIN_(1-10)` VARCHAR(10),
    `County` VARCHAR(100),
    City VARCHAR(100),
    `State` CHAR(2),
    Postal_Code VARCHAR(10),
    Model_Year INT,
    Make VARCHAR(50),
    Model VARCHAR(100),
    Electric_Vehicle_Type VARCHAR(50),
    Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility VARCHAR(30),
    Electric_Range INT,
    Base_MSRP INT,
    Legislative_District VARCHAR(10),
    DOL_Vehicle_ID BIGINT,
    Longitude DECIMAL(10,6),
    Latitude DECIMAL(10,6),
    Electric_Utility VARCHAR(255),
    2020_Census_Tract VARCHAR(255)
);

-- Modify Longitude column to VARCHAR (to handle inconsistent formats)
ALTER TABLE ev_data
MODIFY COLUMN Longitude VARCHAR(255);

-- Modify Latitude column to VARCHAR (to handle inconsistent formats)
ALTER TABLE ev_data
MODIFY COLUMN Latitude VARCHAR(255);

-- Check MySQL variables for secure file loading
SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'local_infile';

-- Enable local file loading
SET GLOBAL local_infile = 1;

-- Load the cleaned EV CSV data into the table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2_Electric_Vehicle_Population_Clean.csv'
INTO TABLE ev_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Display table structure to confirm columns
DESCRIBE ev_data;

-- Preview all records in the table
SELECT * FROM ev_analysis.ev_data;

-- Aggregate total EV count per model year, ordered by descending total, showing top 10
SELECT 
    Model_Year,
    COUNT(`VIN_(1-10)`) AS Total_EV
FROM ev_data
GROUP BY Model_Year
ORDER BY Total_EV DESC
LIMIT 10;


-- Total number of EVs per County, showing the top 10 counties by total vehicles
SELECT 
    County,
    COUNT(`VIN_(1-10)`) AS Total_EV
FROM ev_data
GROUP BY County
ORDER BY Total_EV DESC
LIMIT 10;


-- Compare Early Adopters (Model Year <= 2015) vs Recent Adopters (Model Year >= 2020) by County
-- Calculates growth percentage of recent adopters relative to early adopters
SELECT 
    County,
    SUM(CASE WHEN Model_Year <= 2015 THEN 1 ELSE 0 END) AS Early_Adopters,
    SUM(CASE WHEN Model_Year >= 2020 THEN 1 ELSE 0 END) AS Recent_Adopters,
    ROUND(
        (SUM(CASE WHEN Model_Year >= 2020 THEN 1 ELSE 0 END) /
         NULLIF(SUM(CASE WHEN Model_Year <= 2015 THEN 1 ELSE 0 END), 0)) * 100, 2
    ) AS Growth_Percent
FROM ev_data
GROUP BY County
ORDER BY Growth_Percent DESC;


-- Average Electric Range per Model Year, ordered chronologically
SELECT 
    Model_Year,
    ROUND(AVG(Electric_Range), 2) AS Avg_Electric_Range
FROM ev_data
GROUP BY Model_Year
ORDER BY Model_Year ASC;


-- Average Electric Range per Make, ordered from highest to lowest
SELECT 
    Make,
    ROUND(AVG(Electric_Range), 2) AS Avg_Range
FROM ev_data
GROUP BY Make
ORDER BY Avg_Range DESC;


-- List of EVs with non-null price and electric range, showing key attributes
SELECT 
    Make,
    Model,
    Base_MSRP,
    Electric_Range
FROM ev_data
WHERE Base_MSRP IS NOT NULL
  AND Electric_Range IS NOT NULL;


-- Count of vehicles by CAFV eligibility status
SELECT 
    Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility AS CAFV_Status,
    COUNT(`VIN_(1-10)`) AS Total_Vehicles
FROM ev_data
GROUP BY CAFV_Status
ORDER BY Total_Vehicles DESC;


-- Aggregate EVs by City and State, with average latitude and longitude for mapping
SELECT 
    City,
    State,
    COUNT(`VIN_(1-10)`) AS Total_EV,
    ROUND(AVG(Latitude), 5) AS Avg_Latitude,
    ROUND(AVG(Longitude), 5) AS Avg_Longitude
FROM ev_data
WHERE Latitude IS NOT NULL AND Longitude IS NOT NULL
GROUP BY City, State
ORDER BY Total_EV DESC;

-- Average Price and Average Electric Range by Model Year
SELECT 
    Model_Year,
    ROUND(AVG(Base_MSRP), 0) AS Avg_Price,
    ROUND(AVG(Electric_Range), 1) AS Avg_Range
FROM ev_data
WHERE Base_MSRP IS NOT NULL AND Electric_Range IS NOT NULL
GROUP BY Model_Year
ORDER BY Model_Year;


-- EV count by Model Year and Make, showing highest counts per year
SELECT 
    Model_Year,
    Make,
    COUNT(`VIN_(1-10)`) AS EV_Count
FROM ev_data
GROUP BY Model_Year, Make
ORDER BY Model_Year, EV_Count DESC;

