CREATE DATABASE ev_analysis;

USE ev_analysis;

CREATE TABLE ev_data (
`VIN_(1-10)` VARCHAR(10),
`County` VARCHAR(100),
City VARCHAR(100),
`State`	CHAR(2),
Postal_Code	VARCHAR(10),
Model_Year	INT,
Make	VARCHAR(50),
Model	VARCHAR(100),
Electric_Vehicle_Type	VARCHAR(50),
Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility	VARCHAR(30),
Electric_Range	INT,
Base_MSRP INT,
Legislative_District VARCHAR(10),
DOL_Vehicle_ID	BIGINT,
Longitude DECIMAL(10,6),
Latitude  DECIMAL(10,6),
Electric_Utility VARCHAR(255),
2020_Census_Tract VARCHAR(255)
);

ALTER TABLE ev_data
MODIFY COLUMN Longitude VARCHAR(255);

ALTER TABLE ev_data
MODIFY COLUMN Latitude VARCHAR(255);

SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2_Electric_Vehicle_Population_Clean.csv'
INTO TABLE ev_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DESCRIBE ev_data;

SELECT * FROM ev_analysis.ev_data;

SELECT 
    Model_Year,
    COUNT(`VIN_(1-10)`) AS Total_EV
FROM ev_data
GROUP BY Model_Year
ORDER BY Total_EV DESC
LIMIT 10;


SELECT 
    County,
    COUNT(`VIN_(1-10)`) AS Total_EV
FROM ev_data
GROUP BY County
ORDER BY Total_EV DESC
LIMIT 10;


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

SELECT 
    Model_Year,
    ROUND(AVG(Electric_Range), 2) AS Avg_Electric_Range
FROM ev_data
GROUP BY Model_Year
ORDER BY Model_Year ASC;

SELECT 
    Make,
    ROUND(AVG(Electric_Range), 2) AS Avg_Range
FROM ev_data
GROUP BY Make
ORDER BY Avg_Range DESC;

SELECT 
    Make,
    Model,
    Base_MSRP,
    Electric_Range
FROM ev_data
WHERE Base_MSRP IS NOT NULL
  AND Electric_Range IS NOT NULL;
  
SELECT 
    Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility AS CAFV_Status,
    COUNT(`VIN_(1-10)`) AS Total_Vehicles
FROM ev_data
GROUP BY CAFV_Status
ORDER BY Total_Vehicles DESC;

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


SELECT 
    Model_Year,
    ROUND(AVG(Base_MSRP), 0) AS Avg_Price,
    ROUND(AVG(Electric_Range), 1) AS Avg_Range
FROM ev_data
WHERE Base_MSRP IS NOT NULL AND Electric_Range IS NOT NULL
GROUP BY Model_Year
ORDER BY Model_Year;


SELECT 
    Model_Year,
    Make,
    COUNT(`VIN_(1-10)`) AS EV_Count
FROM ev_data
GROUP BY Model_Year, Make
ORDER BY Model_Year, EV_Count DESC;

