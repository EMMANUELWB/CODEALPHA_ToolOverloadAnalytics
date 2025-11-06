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


CREATE TABLE alt_fuel_data (
    `Fuel_Type_Code` VARCHAR(50),
  `Station_Name` VARCHAR(255),
  `Street_Address` VARCHAR(255),
  `Intersection_Directions` VARCHAR(255),
  `City` VARCHAR(100),
  `State` VARCHAR(10),
  `ZIP` VARCHAR(20),
  `Plus4` VARCHAR(10),
  `Station_Phone` VARCHAR(50),
  `Status_Code` VARCHAR(20),
  `Expected_Date` VARCHAR(50),
  `Groups_With_Access_Code` VARCHAR(255),
  `Access_Days_Time` VARCHAR(255),
  `Cards_Accepted` VARCHAR(255),
  `BD_Blends` VARCHAR(50),
  `NG_Fill_Type_Code` VARCHAR(50),
  `NG_PSI` VARCHAR(50),
  `EV_Level1_EVSE_Num` INT,
  `EV_Level2_EVSE_Num` INT,
  `EV_DC_Fast_Count` INT,
  `EV_Other_Info` TEXT,
  `EV_Network` VARCHAR(100),
  `EV_Network_Web` VARCHAR(255),
  `Geocode_Status` VARCHAR(50),
  `Latitude` DECIMAL(12,8),
  `Longitude` DECIMAL(12,8),
  `Date_Last_Confirmed` VARCHAR(50),
  `ID` INT,
  `Updated_At` DATETIME,
  `Owner_Type_Code` VARCHAR(50),
  `Federal_Agency_ID` VARCHAR(50),
  `Federal_Agency_Name` VARCHAR(255),
  `Open_Date` INT,
  `Hydrogen_Status_Link` VARCHAR(255),
  `NG_Vehicle _Class` VARCHAR(50),
  `LPG_Primary` VARCHAR(50),
  `E85_Blender_Pump` VARCHAR(50),
  `EV_Connector_Types` VARCHAR(255),
  `Country` VARCHAR(50),
  `Intersection_Directions_(French)` VARCHAR(255),
  `Access_Days_Time(French)` VARCHAR(255),
  `BD_Blends(French)` VARCHAR(50),
  `Groups_With_Access_Code(French)` VARCHAR(255),
  `Hydrogen_Is_Retail` VARCHAR(10),
  `Access_Code` VARCHAR(50),
  `Access_Detail_Code` VARCHAR(255),
  `Federal_Agency_Code` VARCHAR(50),
  `Facility_Type` VARCHAR(100),
  `CNG_Dispenser_Num` VARCHAR(50),
  `CNG_On-Site_Renewable_Source` VARCHAR(50),
  `CNG_Total_Compression_Capacity` VARCHAR(50),
  `CNG_Storage_Capacity` VARCHAR(50),
  `LNG_On-Site_Renewable_Source` VARCHAR(50),
  `E85_Other_Ethanol_Blends` VARCHAR(50),
  `EV_Pricing` VARCHAR(255),
  `EV_Pricing(French)` VARCHAR(255),
  `LPG_Nozzle_Types` VARCHAR(50),
  `Hydrogen_Pressures` VARCHAR(50),
  `Hydrogen_Standards` VARCHAR(50),
  `CNG_Fill_Type_Code` VARCHAR(50),
  `CNG_PSI` VARCHAR(50),
  `CNG_Vehicle_Class` VARCHAR(50),
  `LNG_Vehicle_Class` VARCHAR(50),
  `EV_On-Site_Renewable_Source` VARCHAR(50),
  `Restricted_Access` VARCHAR(10),
  `RD_Blends` VARCHAR(50),
  `RD_Blends(French)` VARCHAR(50),
  `RD_Blended_with_Biodiesel` VARCHAR(50),
  `RD_Maximum_Biodiesel_Level` VARCHAR(50),
  `NPS_Unit_Name` VARCHAR(100),
  `CNG_Station_Sells_Renewable_Natural_Gas` VARCHAR(10),
  `LNG_Station _Sells _Renewable_Natural_Gas` VARCHAR(10),
  `Maximum_Vehicle_Class` VARCHAR(50),
  `EV_Workplace_Charging` VARCHAR(10),
  `Funding_Sources` VARCHAR(255)
);

ALTER TABLE alt_fuel_data
MODIFY COLUMN `Open_Date` VARCHAR(55);

ALTER TABLE alt_fuel_data 
MODIFY COLUMN Access_Days_Time VARCHAR(1000);
 ALTER TABLE alt_fuel_data MODIFY COLUMN Plus4 VARCHAR(20);

ALTER TABLE alt_fuel_data MODIFY COLUMN `EV_DC_Fast_Count` VARCHAR(100);

 ALTER TABLE alt_fuel_data MODIFY COLUMN `Date_Last_Confirmed` VARCHAR(100);

ALTER TABLE alt_fuel_data 
MODIFY COLUMN `Open_Date` VARCHAR(100);

ALTER TABLE alt_fuel_data 
MODIFY COLUMN  `Access_Days_Time` VARCHAR(1000);

ALTER TABLE alt_fuel_data 
MODIFY COLUMN  `Plus4` VARCHAR(1000);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/5_Alternative_Fuel_Stations_Clean.csv'
INTO TABLE alt_fuel_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW COLUMNS FROM alt_fuel_data;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/5_Alternative_Fuel_Stations_FIXED3.csv'
INTO TABLE alt_fuel_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE alt_fuel_data 
MODIFY COLUMN `Intersection_Directions_(French)` VARCHAR(2000);

ALTER TABLE alt_fuel_data
MODIFY COLUMN `Intersection_Directions` VARCHAR(2000),
MODIFY COLUMN `Intersection_Directions_(French)` VARCHAR(2000);


USE ev_analysis;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/5_Alternative_Fuel_Stations_Clean.csv'
INTO TABLE alt_fuel_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
