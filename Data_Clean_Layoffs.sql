-- STEP 1 DUPLICATED VALUES -- 

USE world_layoffs;

# Step 1: Create a staging table to work with (duplicate of raw table)
DROP TABLE IF EXISTS layoffs_staging;

# Creat Backup
CREATE TABLE layoffs_staging 
LIKE layoffs;
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

# Identify Duplicates Using row_num()
WITH duplicate_cte AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off,
                        percentage_laid_off, `date`, stage, country, funds_raised_millions
           ORDER BY company
         ) AS row_num
  FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

# Create a clean staging table to store de-duplicated data
DROP TABLE IF EXISTS layoffs_staging2;

CREATE TABLE layoffs_staging2 (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Step 4: Insert only de-duplicated rows (row_num = 1)
INSERT INTO layoffs_staging2
SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off,
                        percentage_laid_off, `date`, stage, country, funds_raised_millions
           ORDER BY company
         ) AS row_num
  FROM layoffs_staging
) AS ranked
WHERE row_num = 1;

-- Step 5: Review the cleaned data
SELECT *
FROM layoffs_staging2; # No duplicated value 

SELECT company, TRIM(company)
FROM layoffs_staging2; # show the trim test 

UPDATE layoffs_staging2
SET company = TRIM(company); # update the trimp surely in tables

SELECT distinct industry 
from layoffs_staging2
ORDER BY 1; # notice that cryptocurrency is repeated 

SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';  # transfter any cryptocurreny to crypto 

SELECT DISTINCT location 
FROM layoffs_staging2
ORDER BY 1; # well there is no problem 

SELECT DISTINCT country 
FROM layoffs_staging2
ORDER BY 1; # well there is no problem 

# i find data about Isreal offcourse i will remove it 
DELETE 
FROM layoffs_staging2
WHERE location LIKE 'Israel%'
OR country LIKE 'Israel%';

# we find unclean data about usa. replace usa 
SELECT DISTINCT country 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

# Other Method To Trailing
SELECT distinct TRIM(TRAILING '.' from country) 
FROM layoffs_staging2 
ORDER BY 1;

# Update The Formate Of The Date 
SELECT `date`,
str_to_date(`date`, '%m/%d/%Y') AS new_date
FROM layoffs_staging2;

UPDATE layoffs_Staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

# Chage The Date From Text To Date By Alter Table 
ALTER TABLE layoffs_staging2
MODIFY `date` DATE;

-- Step 3 >> NULL Values

# discover null values 
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL; 

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL OR industry = '';


# convert blanks to null values to easy dealing with 
UPDATE layoffs_staging2 
SET industry = NULL
WHERE industry = ''; 

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

# replace null with date 
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

# check if null values are replace from the industry or not (Done)
SELECT * from layoffs_staging2; 

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND 
percentage_laid_off IS NULL;

# delete this nulls because we do not know how to deal with
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND 
percentage_laid_off IS NULL;

# now rewove row_num 
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

