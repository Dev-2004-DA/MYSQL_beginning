-- Cafe Sales - Dirty Data for Cleaning Training
-- Dirty Cafe Sales Dataset

-- About Dataset
-- Dirty Cafe Sales Dataset
-- Overview
-- The Dirty Cafe Sales dataset contains 10,000 rows of synthetic data representing sales transactions in a cafe. This dataset is intentionally "dirty," with missing values, inconsistent data, and errors introduced to provide a realistic scenario for data cleaning and exploratory data analysis (EDA). It can be used to practice cleaning techniques, data wrangling, and feature engineering.

-- File Information
-- File Name: dirty_cafe_sales.csv
-- Number of Rows: 10,000
-- Number of Columns: 8
-- Columns Description
-- Column Name	Description	Example Values
-- Transaction ID	A unique identifier for each transaction. Always present and unique.	TXN_1234567
-- Item	The name of the item purchased. May contain missing or invalid values (e.g., "ERROR").	Coffee, Sandwich
-- Quantity	The quantity of the item purchased. May contain missing or invalid values.	1, 3, UNKNOWN
-- Price Per Unit	The price of a single unit of the item. May contain missing or invalid values.	2.00, 4.00
-- Total Spent	The total amount spent on the transaction. Calculated as Quantity * Price Per Unit.	8.00, 12.00
-- Payment Method	The method of payment used. May contain missing or invalid values (e.g., None, "UNKNOWN").	Cash, Credit Card
-- Location	The location where the transaction occurred. May contain missing or invalid values.	In-store, Takeaway
-- Transaction Date	The date of the transaction. May contain missing or incorrect values.	2023-01-01
-- Data Characteristics
-- Missing Values:

-- Some columns (e.g., Item, Payment Method, Location) may contain missing values represented as None or empty cells.
-- Invalid Values:

-- Some rows contain invalid entries like "ERROR" or "UNKNOWN" to simulate real-world data issues.
-- Price Consistency:

-- Prices for menu items are consistent but may have missing or incorrect values introduced.
-- Menu Items
-- The dataset includes the following menu items with their respective price ranges:

-- Item	Price($)
-- Coffee	2
-- Tea	1.5
-- Sandwich	4
-- Salad	5
-- Cake	3
-- Cookie	1
-- Smoothie	4
-- Juice	3
-- Use Cases
-- This dataset is suitable for:

-- Practicing data cleaning techniques such as handling missing values, removing duplicates, and correcting invalid entries.
-- Exploring EDA techniques like visualizations and summary statistics.
-- Performing feature engineering for machine learning workflows.
-- Cleaning Steps Suggestions
-- To clean this dataset, consider the following steps:

-- Handle Missing Values:

-- Fill missing numeric values with the median or mean.
-- Replace missing categorical values with the mode or "Unknown."
-- Handle Invalid Values:

-- Replace invalid entries like "ERROR" and "UNKNOWN" with NaN or appropriate values.
-- Date Consistency:

-- Ensure all dates are in a consistent format.
-- Fill missing dates with plausible values based on nearby records.
-- Feature Engineering:

-- Create new columns, such as Day of the Week or Transaction Month, for further analysis.
-- License
-- This dataset is released under the CC BY-SA 4.0 License. You are free to use, share, and adapt it, provided you give appropriate credit.

-- Feedback
-- If you have any questions or feedback, feel free to reach out through the dataset's discussion board on Kaggle.

CREATE DATABASE project3;

DESCRIBE dirty_cafe_sales;
SELECT COUNT(*) FROM dirty_cafe_sales; 

												--  column 1

SELECT DISTINCT COUNT(`Transaction ID`) FROM dirty_cafe_sales; 

SELECT DISTINCT `Transaction ID` FROM dirty_cafe_sales; 

SELECT  `Transaction ID` FROM dirty_cafe_sales WHERE `Transaction ID` IS NULL  ; 

-- changing data type of Column 1  to fix length ie Varchar
ALTER TABLE dirty_cafe_sales
MODIFY COLUMN `Transaction ID` VARCHAR(20);

-- altering Primary key  
ALTER TABLE dirty_cafe_sales
ADD CONSTRAINT pk PRIMARY KEY (`Transaction ID`);

												--  column 2
SELECT DISTINCT item FROM dirty_cafe_sales
ORDER BY 1;
-- so we have 3 impurietiies ERROR , '' . UNKNOWN

SELECT * FROM dirty_cafe_sales
WHERE item IN('','UNKNOWN','ERROR')
ORDER BY item;

UPDATE dirty_cafe_sales
SET item = NULL
WHERE item IN('','UNKOWN','UNKNOWN','ERROR');

												--  column 3
                                                
SELECT  Quantity FROM dirty_cafe_sales
WHERE Quantity IS NULL;
-- no problem in this column  

												--  column 4

SELECT DISTINCT `Price Per Unit` FROM dirty_cafe_sales;

ALTER TABLE dirty_cafe_sales
MODIFY COLUMN `Price Per Unit` DECIMAL(2,1);

-- Column cleared
 
												--  column 5
SELECT DISTINCT `Total Spent` FROM dirty_cafe_sales
ORDER BY 1;

-- filling impurities 

UPDATE dirty_cafe_sales
SET `Total Spent`  = ''
WHERE `Total Spent` IN(NULL);

UPDATE dirty_cafe_sales
SET `Total Spent`  = UPPER(TRIM(`Total Spent`));


ALTER TABLE dirty_cafe_sales
MODIFY COLUMN  `Total Spent` DECIMAL(10,2);

SELECT * FROM dirty_cafe_sales;

-- done 

										-- Column 6  
SELECT DISTINCT `Payment Method` FROM dirty_cafe_sales;                                        

SELECT `Payment Method`,COUNT(`Payment Method`)
FROM dirty_cafe_sales
GROUP BY `Payment Method`;

UPDATE dirty_cafe_sales
SET `Payment Method` = ''
WHERE `Payment Method` IN ('','ERROR','UNKNOWN');
CREATE TABLE dfs AS
SELECT *, 
		LAG(`Payment Method`,1,'Credit Card') OVER () AS Payment_Method
 FROM dirty_cafe_sales
;

SELECT * FROM dfs;

UPDATE dfs
SET `Payment Method` = ''
WHERE `Payment Method` IN ('k');

ALTER TABLE dfs
ADD COLUMN PM VARCHAR(20); 

UPDATE dfs
SET PM = REPLACE(`Payment_method`,`Payment_method`,`Payment Method`) ;

SELECT * ,REPLACE(`Payment_method`,`Payment_method`,`Payment Method`) FROM dfs;

-- WHERE `Payment method` NOT IN ('') ;

SELECT * FROM dfs;

UPDATE dfs
SET PM = Payment_Method
WHERE PM='';                

UPDATE dfs
SET PM = `Payment Method`
WHERE PM='';                

alter table dfs
DROP COLUMN Payment_Method;
 
alter table dfs
DROP COLUMN `Payment Method`;
 
SELECT * FROM dfs;

ALTER TABLE dfs 
CHANGE COLUMN PM `Payment Method` VARCHAR(20);

-- column 6 done 

								-- 	Column 7 
SELECT DISTINCT Location FROM dfs;      
               
SELECT Location, COUNT(Location) FROM dfs
GROUP BY Location; 

SELECT *  FROM dfs
WHERE Location IN('','ERROR','UNKNOWN') AND ITEM IS NULL AND `Transaction Date`IN('','ERROR','UNKNOWN'); 

DELETE FROM dfs
WHERE Location IN('','ERROR','UNKNOWN') AND ITEM IS NULL AND `Transaction Date`IN('','ERROR','UNKNOWN'); 

SELECT *  FROM dfs
WHERE Location IN('','ERROR','UNKNOWN') AND ITEM IS NULL; 

SELECT * , LAG(Location,1,'In-store')
									OVER() AS stagloc 
FROM dfs1;                         


           
-- FIlling some rows of Item
SELECT DISTINCT `Price Per Unit` FROM dfs;

SELECT Item ,Quantity, `Price Per Unit`,`Total Spent`  FROM dfs
WHERE `Price Per Unit` = 1.5;

UPDATE dfs
SET Item = 'Tea'
WHERE `Price Per Unit` = 1.5;
         

SELECT Item ,Quantity, `Price Per Unit`,`Total Spent`  FROM dfs
WHERE `Price Per Unit` = 5.0;

UPDATE dfs
SET Item = 'Salad'
WHERE `Price Per Unit` = 5.0;
                  

SELECT Item ,Quantity, `Price Per Unit`,`Total Spent`  FROM dfs
WHERE `Price Per Unit` = 1.0;

UPDATE dfs
SET Item = 'Cookie'
WHERE `Price Per Unit` = 1.0;                  


SELECT Item ,Quantity, `Price Per Unit`,`Total Spent`  FROM dfs
WHERE `Price Per Unit` = 2.0;

UPDATE dfs
SET Item = 'Coffee'
WHERE `Price Per Unit` = 2.0;                  



SELECT Item ,Quantity, `Price Per Unit`,`Total Spent` FROM dfs
WHERE `Price Per Unit` = 3.0 OR `Price Per Unit` = 4.0 ;

CREATE TABLE dfs1 AS
SELECT * , LAG(Item,1,'') OVER() AS stagitem 
FROM dfs;

DROP TABLE dfs1;

SELECT * , LAG(Item,1,'') OVER() AS stagitem 
FROM dfs
WHERE Item IS NULL or Item IN('Smoothie','Sandwich','Juice','Cake');


UPDATE dfs1
SET Item = ''
WHERE Item IS NULL ;                  

START  TRANSACTION ;

ALTER TABLE dfs1
MODIFY COLUMN stagitem TEXT;

SELECT * FROM dfs1;

UPDATE dfs1
SET Item = COALESCE(Item,Stagitem); 

ALTER TABLE dfs1
DROP COLUMN stagitem; 

-- column 1 and 6 are cleaned
 
SELECT * FROM dfs1;
										
												-- column 7

SELECT DISTINCT Location FROM dfs1;

UPDATE dfs1
SET Location = ''
WHERE Location IN('','ERROR','UNKNOWN');

SELECT Location , COUNT(LOCATION) FROM dfs1
GROUP BY Location;

UPDATE dfs1
SET Location = NULL
WHERE Location = '';
 
CREATE TABLE dfs2 AS 
SELECT * , LAG(Location,1,'In-store')OVER() AS stagLoc 
FROM dfs1;

UPDATE dfs2
SET Location =  COALESCE(Location, stagloc);

ALTER TABLE dfs2
DROP COLUMN stagloc;


									-- Column  8 
SELECT DISTINCT `Transaction Date` FROM dfs1;          

COMMIT ;

SELECT * FROM dfs1;

SELECT `Transaction Date`, COALESCE(STR_TO_DATE(`Transaction Date`,'%Y-%m-%d'),STR_TO_DATE(`Transaction Date`,'%Y/%m/%d'))                
FROM dfs1; 
						

UPDATE dfs1
SET `Transaction Date` = NULL
WHERE `Transaction Date` = 'UNKNOWN ' OR `Transaction Date` = ''  OR `Transaction Date` = 'ERROR';


SELECT DISTINCT `Transaction Date`                
FROM dfs1
ORDER BY 1 DESC; 


SELECT  `Transaction Date`                
FROM dfs1
WHERE `Transaction Date`= '' ; 

UPDATE dfs1
SET `Transaction Date` = NULL
WHERE `Transaction Date` = 'ERROR';


UPDATE dfs1
SET `Transaction Date` = COALESCE(STR_TO_DATE(`Transaction Date`,'%Y-%m-%d'),STR_TO_DATE(`Transaction Date`,'%Y/%m/%d'))      ;                        

ALTER TABLE dfs1
MODIFY COLUMN `Transaction Date` DATE;

-- ####### CLEANING DONE 

SELECT * FROM dfs1;

-- one last updateing total spent column and location column 

UPDATE dfs1
SET `Total Spent`= Quantity * `Price PEr unit` ;

RENAME TABLE dfs to dirty_cafe_sales_stag_1;

RENAME TABLE dfs1 to dirty_cafe_sales_stag_2;

RENAME TABLE dfs2 to FINAL_dfs;

