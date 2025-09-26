CREATE DATABASE Project;

SELECT 
    *
FROM
    layoff;
-- let us create a staging dataset for working

CREATE TABLE layoff_stag SELECT * FROM
    layoff;

 
-- now checking 
SELECT 
    COUNT(*)
FROM
    layoff_stag;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. NULL values or blank values
-- 4. Remove any Unnessary Column


-- -- 1.Remove Duplicates
WITH duplicates_cte AS (
SELECT * ,
	ROW_NUMBER() OVER ( PARTITION BY company, location ,industry  ,total_laid_off ,percentage_laid_off  ,`date` ,stage ,country ,funds_raised_millions ) AS rn
FROM  layoff_stag )
SELECT * FROM duplicates_cte
WHERE rn > 1;  

-- to delete duplicates i jjust make a new table of the above query and will delete all the row for which rn=2

CREATE  TABLE IF NOT EXISTS layoff_rem_dup_vt 
SELECT * ,
	ROW_NUMBER() OVER ( PARTITION BY company, location ,industry  ,total_laid_off ,percentage_laid_off  ,`date` ,stage ,country ,funds_raised_millions ) AS rn
FROM  layoff_stag ;

CREATE TABLE IF NOT EXISTS layoff_no_dup SELECT * FROM
    layoff_rem_dup_vt
WHERE
    rn = 1;
 
SELECT 
    COUNT(*)
FROM
    layoff_no_dup;

-- -- 2. Standardize the Data
SELECT 
    *
FROM
    layoff_no_dup;
SELECT DISTINCT
    COMPANY, TRIM(company)
FROM
    layoff_no_dup;
UPDATE layoff_no_dup 
SET 
    COMPANY = TRIM(company);

SELECT DISTINCT
    industry
FROM
    layoff_no_dup
ORDER BY 1;

-- From the above query we have observed that in the industry column there are some rows that are same but with the difference world So we need to change them into one 
SELECT 
    *
FROM
    layoff_no_dup
WHERE
    industry LIKE 'cryp%';

UPDATE layoff_no_dup 
SET 
    industry = 'Crypto'
WHERE
    industry LIKE 'crypt%';


SELECT DISTINCT
    industry
FROM
    layoff_no_dup
ORDER BY 1;

SELECT DISTINCT
    country
FROM
    layoff_no_dup
ORDER BY 1;

UPDATE layoff_no_dup 
SET 
    country = 'United States'
WHERE
    country LIKE 'United S%';

SELECT DISTINCT
    country
FROM
    layoff_no_dup
WHERE
    country LIKE 'United %';

-- now the most importat column date
SELECT 
    `date`,
    COALESCE(STR_TO_DATE(`date`, '%m-%d-%Y'),
            STR_TO_DATE(`date`, '%m/%d/%Y'),
            STR_TO_DATE(`date`, '%M/%D/%Y')) AS cvtdate
FROM
    layoff_no_dup;
    
UPDATE layoff_no_dup 
SET 
    `date` = COALESCE(STR_TO_DATE(`date`, '%m-%d-%Y'),
            STR_TO_DATE(`date`, '%m/%d/%Y'),
            STR_TO_DATE(`date`, '%M/%D/%Y'));

SELECT 
    `date`
FROM
    layoff_no_dup;
UPDATE layoff_no_dup 
SET 
    `date` = COALESCE(STR_TO_DATE(`date`, '%m/%d/%Y'),
            STR_TO_DATE(`date`, '%m-%d-%Y'));
UPDATE layoff_no_dup 
SET 
    `date` = COALESCE(STR_TO_DATE(`date`, '%m/%d/%Y'),
            STR_TO_DATE(`date`, '%m-%d-%Y'));

UPDATE layoff_no_dup 
SET 
    `date` = COALESCE(STR_TO_DATE(`date`, '%d-%m-%Y'),
            STR_TO_DATE(`date`, '%d/%m/%Y'));

UPDATE layoff_no_dup 
SET 
    `date` = COALESCE(STR_TO_DATE(`date`, '%d-%m-%Y'),
            STR_TO_DATE(`date`, '%d/%m/%Y'));
UPDATE layoff_no_dup 
SET 
    `date` = REPLACE(`date`, '/', '-');

SELECT 
    `date`, STR_TO_DATE(`date`, '%m-%d-%Y')
FROM
    layoff_no_dup;

UPDATE layoff_no_dup 
SET 
    `date` = STR_TO_DATE(`date`, '%m-%d-%Y');


ALTER TABLE layoff_no_dup
MODIFY COLUMN `date` DATE;

-- 3. NULL values or blank values

SELECT 
    *
FROM
    layoff_no_dup;
    
SELECT 
    company, location, industry
FROM
    layoff_no_dup
WHERE
    company IN ('Airbnb' , "Bally's Interactive", 'Carvana', 'Juul');

UPDATE layoff_no_dup
SET industry = 'Travel'
WHERE industry IN('', NULL) AND company = 'Airbnb';    


UPDATE layoff_no_dup
SET industry = 'Travel'
WHERE industry IN('', NULL) AND company = 'Airbnb';    

UPDATE layoff_no_dup
SET industry = 'Travel'
WHERE industry IN('', NULL) AND company = 'Airbnb';    

SELECT industry , company from layoff_no_dup
WHERE  company = "Bally's Interactive";

DELETE FROM layoff_no_dup
WHERE company = "Bally's Interactive" AND industry IS NULL;

UPDATE layoff_no_dup
SET industry = 'Transportation'
WHERE industry IN('', NULL) AND company = 'Carvana';    
UPDATE layoff_no_dup
SET industry = 'Consumer'
WHERE industry IN('', NULL) AND company = 'Juul';    

SELECT DISTINCT * FROM layoff_no_dup
ORDER BY 1;

SELECT  DISTINCT total_laid_off , funds_raised_millions   FROM layoff_no_dup 
ORDER BY 1,2  ;

delete from layoff_no_dup
WHERE  total_laid_off IS NULL AND percentage_laid_off IS NULL ;

delete from layoff_no_dup
WHERE  total_laid_off IS NULL AND funds_raised_millions IS NULL ;

SELECT * FROM layoff_no_dup;
ALTER TABLE layoff_no_dup
MODIFY COLUMN percentage_laid_off INT;

CREATE TABLE Clean_layoff
SELECT * FROM layoff_no_dup;

-- final table 
SELECT * FROM clean_layoff;

ALTER TABLE clean_layoff
DROP COLUMN rn;

DROP TABLE layoff_rem_dup_vt; 
DROP TABLE layoff_stag; 
 
select * FROM layoff;
seleCt * FROM clean_layoff; 
