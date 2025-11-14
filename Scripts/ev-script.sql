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


-- Create a cleaned copy of the table
CREATE TABLE 2_Electric_Vehicle_Population_Clean AS
SELECT *
FROM ev_data;


SELECT *
INTO OUTFILE 'C:/Users/DellGadget/Desktop/CODEALPHA_ToolOverloadAnalytics/Data/2_Electric_Vehicle_Population_Clean.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM `2_Electric_Vehicle_Population_Clean`;

SHOW VARIABLES LIKE 'secure_file_priv';

SELECT *
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2_Electric_Vehicle_Population_Clean.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM `2_Electric_Vehicle_Population_Clean`;


-- Drop the old cleaned table 
DROP TABLE IF EXISTS `2_Electric_Vehicle_Population_Clean`;

USE ev_analysis;

-- Drop the old table to save with header
DROP TABLE IF EXISTS `2_Electric_Vehicle_Population_Clean`;

CREATE TABLE `2_Electric_Vehicle_Population_Clean` AS
SELECT `VIN_(1-10)`,
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
       Longitude,
       Latitude,
       Electric_Utility,
       `2020_Census_Tract`
FROM ev_data;


SELECT 'VIN_(1-10)','County','City','State','Postal_Code','Model_Year','Make','Model','Electric_Vehicle_Type','Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility','Electric_Range','Base_MSRP','Legislative_District','DOL_Vehicle_ID','Longitude','Latitude','Electric_Utility','2020_Census_Tract'
UNION ALL
SELECT `VIN_(1-10)`,
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
       Longitude,
       Latitude,
       Electric_Utility,
       `2020_Census_Tract`
FROM ev_data
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2_Electric_Vehicle_Population_Clean.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


USE ev_analysis;


CREATE TABLE ev_original_range (
    Model_Year INT,
    Make VARCHAR(100),
    Model VARCHAR(150),
    Electric_Vehicle_Type VARCHAR(100),
    Electric_Range INT,
    original_range INT,
    original_range1 INT
);



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/original_ranges_for_update.csv'
INTO TABLE ev_original_range
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
IGNORE 1 ROWS
(Model_Year, Make, Model, Electric_Vehicle_Type, Electric_Range, @original_range, @original_range1)
SET 
original_range = NULLIF(@original_range, ''),
original_range1 = NULLIF(@original_range1, '');

SELECT * FROM ev_analysis.ev_original_range;


SELECT COUNT(*) AS blanks_now_null
FROM ev_original_range
WHERE original_range IS NULL OR original_range1 IS NULL;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

-- Update Electric_Range in ev_data using ev_original_range
UPDATE ev_data AS e
JOIN ev_original_range AS r
  ON e.Model_Year = r.Model_Year
 AND UPPER(e.Make) = UPPER(r.Make)
 AND e.Model = r.Model
 AND e.Electric_Vehicle_Type = r.Electric_Vehicle_Type
SET e.Electric_Range = r.original_range1
WHERE e.Model_Year = 2025;

-- Update Electric_Range in ev_data using ev_original_range for 2023
UPDATE ev_data AS e
JOIN ev_original_range AS r
  ON e.Model_Year = r.Model_Year
 AND UPPER(e.Make) = UPPER(r.Make)
 AND e.Model = r.Model
 AND e.Electric_Vehicle_Type = r.Electric_Vehicle_Type
SET e.Electric_Range = r.original_range1
WHERE e.Model_Year = 2023;


-- Update 1000 rows at a time
UPDATE ev_data AS e
JOIN ev_original_range AS r
  ON e.Model_Year = r.Model_Year
 AND UPPER(e.Make) = UPPER(r.Make)
 AND e.Model = r.Model
 AND e.Electric_Vehicle_Type = r.Electric_Vehicle_Type
SET e.Electric_Range = r.original_range1
WHERE e.Model_Year = 2023
LIMIT 1000;

-- To check how many rows are left
SELECT COUNT(*) AS remaining
FROM ev_data AS e
JOIN ev_original_range AS r
  ON e.Model_Year = r.Model_Year
 AND UPPER(e.Make) = UPPER(r.Make)
 AND e.Model = r.Model
 AND e.Electric_Vehicle_Type = r.Electric_Vehicle_Type
WHERE e.Model_Year = 2023
  AND e.Electric_Range <> r.original_range1;


-- list of all years that still need updating
SELECT e.Model_Year, COUNT(*) AS rows_to_update
FROM ev_data AS e
JOIN ev_original_range AS r
  ON e.Model_Year = r.Model_Year
 AND UPPER(e.Make) = UPPER(r.Make)
 AND e.Model = r.Model
 AND e.Electric_Vehicle_Type = r.Electric_Vehicle_Type
WHERE e.Electric_Range <> r.original_range1
GROUP BY e.Model_Year
ORDER BY e.Model_Year;

UPDATE ev_data AS e
JOIN ev_original_range AS r
  ON e.Model_Year = r.Model_Year
 AND UPPER(e.Make) = UPPER(r.Make)
 AND e.Model = r.Model
 AND e.Electric_Vehicle_Type = r.Electric_Vehicle_Type
SET e.Electric_Range = r.original_range1
WHERE e.Electric_Range < 5;

-- extending timeout for reading data
SET SESSION net_read_timeout = 600;   -- default is 30 seconds

-- Wait longer for writing data
SET SESSION net_write_timeout = 600;  -- default is 60 seconds



-- Prepare a procedure to update in batches
DELIMITER $$

CREATE PROCEDURE update_ev_ranges()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE y INT;

    -- Cursor to iterate over all years present in ev_data
    DECLARE year_cursor CURSOR FOR
        SELECT DISTINCT Model_Year FROM ev_data ORDER BY Model_Year;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN year_cursor;

    year_loop: LOOP
        FETCH year_cursor INTO y;
        IF done THEN
            LEAVE year_loop;
        END IF;

        -- Repeat updating 5000 rows at a time for this year until all are updated
        update_loop: LOOP
            UPDATE ev_data AS e
            JOIN ev_original_range AS r
              ON e.Model_Year = r.Model_Year
             AND UPPER(e.Make) = UPPER(r.Make)
             AND e.Model = r.Model
             AND e.Electric_Vehicle_Type = r.Electric_Vehicle_Type
            SET e.Electric_Range = r.original_range1
            WHERE e.Model_Year = y
              AND e.Electric_Range <> r.original_range1
            LIMIT 5000;

            -- Exit loop if no more rows need updating
            IF ROW_COUNT() = 0 THEN
                LEAVE update_loop;
            END IF;
        END LOOP update_loop;

    END LOOP year_loop;

    CLOSE year_cursor;
END$$

DELIMITER ;

-- Run the procedure
CALL update_ev_ranges();

-- Drop the procedure after running
DROP PROCEDURE update_ev_ranges;





