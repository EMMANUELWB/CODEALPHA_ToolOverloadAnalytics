-- Purpose: aggregates and summarizes the Electric Vehicle Population dataset
-- Contains: table creation, data load, and analysis queries for:
--   - Adoption by year
--   - Average range by year and by make
--   - Price vs range analysis
--   - Manufacturer counts by year
--   - Regional (county/city) summaries and growth index


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


-- Core analysis queries (aligned to business questions)

-- A. EV Adoption by Model Year (trend), ordered by ascending total, showing top 10
SELECT 
    Model_Year,
    COUNT(`VIN_(1-10)`) AS Total_EV
FROM ev_data
WHERE Model_Year IS NOT NULL
GROUP BY Model_Year
ORDER BY Model_Year ASC;
       
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

USE ev_analysis;
SET SQL_SAFE_UPDATES = 0;


-- TESLA MODEL 3: BEV, correct range ~320 miles
UPDATE ev_data
  SET Electric_Range = 320
WHERE Make = 'TESLA'
  AND Model = 'MODEL 3'
  AND Electric_Vehicle_Type = 'BEV'
  AND Electric_Range = 0;

-- TESLA MODEL S: BEV, correct range ~405 miles
UPDATE ev_data
  SET Electric_Range = 405
WHERE Make = 'TESLA'
  AND Model = 'MODEL S'
  AND Electric_Vehicle_Type = 'BEV'
  AND Electric_Range = 0;

-- TESLA MODEL X: BEV, correct range ~340 miles
UPDATE ev_data
  SET Electric_Range = 340
WHERE Make = 'TESLA'
  AND Model = 'MODEL X'
  AND Electric_Vehicle_Type = 'BEV'
  AND Electric_Range = 0;

-- TESLA MODEL Y: BEV, correct range ~310 miles
UPDATE ev_data
  SET Electric_Range = 310
WHERE Make = 'TESLA'
  AND Model = 'MODEL Y'
  AND Electric_Vehicle_Type = 'BEV'
  AND Electric_Range = 0;

-- NISSAN LEAF: BEV, correct range ~150 miles
UPDATE ev_data
  SET Electric_Range = 150
WHERE Make = 'NISSAN'
  AND Model = 'LEAF'
  AND Electric_Vehicle_Type = 'BEV'
  AND Electric_Range = 0;

-- CHEVROLET BOLT EV: BEV, correct range ~259 miles
UPDATE ev_data
  SET Electric_Range = 259
WHERE Make = 'CHEVROLET'
  AND Model = 'BOLT EV'
  AND Electric_Vehicle_Type = 'BEV'
  AND Electric_Range = 0;

-- CHEVROLET VOLT: PHEV, correct range ~53 miles
UPDATE ev_data
  SET Electric_Range = 53
WHERE Make = 'CHEVROLET'
  AND Model = 'VOLT'
  AND Electric_Vehicle_Type = 'BEV'
  AND Electric_Range = 0;

-- BMW i3: BEV (or BEV + Range-Extender option), correct range ~153 miles
UPDATE ev_data
  SET Electric_Range = 153
WHERE Make = 'BMW'
  AND Model = 'I3'
  AND Electric_Vehicle_Type = 'BEV'
  AND Electric_Range = 0;

-- AUDI Q5 e: PHEV, correct range ~23 miles
UPDATE ev_data
  SET Electric_Range = 23
WHERE Make = 'AUDI'
  AND Model = 'Q5 E'
  AND Electric_Vehicle_Type = 'BEV'
  AND Electric_Range = 0;

-- HYUNDAI BEVs
UPDATE ev_data
SET Electric_Range = 258
WHERE Make = 'HYUNDAI' 
	AND Model = 'KONA ELECTRIC' 
	AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

UPDATE ev_data
SET Electric_Range = 303
WHERE Make = 'HYUNDAI' 
	AND Model = 'IONIQ 5' 
    AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

UPDATE ev_data
SET Electric_Range = 305
WHERE Make = 'HYUNDAI' 
	AND Model = 'IONIQ 6' 
    AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

-- KIA BEVs
UPDATE ev_data
SET Electric_Range = 310
WHERE Make = 'KIA' 
	AND Model = 'EV6' 
	AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

UPDATE ev_data
SET Electric_Range = 253
WHERE Make = 'KIA' 
	AND Model = 'NIRO' 
	AND Electric_Range = 0 
	AND Electric_Vehicle_Type = 'BEV';

UPDATE ev_data
SET Electric_Range = 111
WHERE Make = 'KIA' 
	AND Model = 'SOUL EV' 
    AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

-- FORD BEVs
UPDATE ev_data
SET Electric_Range = 270
WHERE Make = 'FORD' 
	AND Model = 'MUSTANG MACH-E' 
    AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

UPDATE ev_data
SET Electric_Range = 126
WHERE Make = 'FORD' 
	AND Model = 'F-150' 
	AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

-- RIVIAN BEVs
UPDATE ev_data
SET Electric_Range = 314
WHERE Make = 'RIVIAN' 
	AND Model = 'R1T' 
	AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

UPDATE ev_data
SET Electric_Range = 316
WHERE Make = 'RIVIAN' 
	AND Model = 'R1S' 
    AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

-- LUCID and POLESTAR
UPDATE ev_data
SET Electric_Range = 520
WHERE Make = 'LUCID' 
	AND Model = 'AIR' 
	AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

UPDATE ev_data
SET Electric_Range = 270
WHERE Make = 'POLESTAR' 
	AND Model = 'PS2' 
    AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

-- VOLKSWAGEN BEVs
UPDATE ev_data
SET Electric_Range = 125
WHERE Make = 'VOLKSWAGEN' 
	AND Model = 'E-GOLF' 
    AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

UPDATE ev_data
SET Electric_Range = 260
WHERE Make = 'VOLKSWAGEN' 
	AND Model = 'ID.4' 
	AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

-- Jaguar / Genesis / Mercedes BEVs
UPDATE ev_data
SET Electric_Range = 234
WHERE Make = 'JAGUAR' 
	AND Model = 'I-PACE' 
	AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

UPDATE ev_data
SET Electric_Range = 236
WHERE Make = 'GENESIS' 
	AND Model = 'GV60' 
    AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';

UPDATE ev_data
SET Electric_Range = 305
WHERE Make = 'MERCEDES-BENZ' 
	AND Model = 'EQS-CLASS SEDAN' 
    AND Electric_Range = 0 
    AND Electric_Vehicle_Type = 'BEV';


SET SQL_SAFE_UPDATES = 1;



