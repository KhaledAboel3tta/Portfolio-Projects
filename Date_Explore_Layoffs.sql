#-- ======================================================================================================================
#-- Layoffs Dataset - Exploratory Data Analysis (EDA)
#-- Author: Khaled Aboel3tta
#-- Description: SQL analysis of layoffs data with summary insights by company, date, industry, stage, and rolling totals
#-- ======================================================================================================================

#-- Step 1: View raw data
SELECT * 
FROM layoffs_staging2;

#-- Check for NULL or blank values in key columns
#-- (total_laid_off and percentage_laid_off contain missing data)

#-- Step 2: Company-level summary of layoffs
SELECT 
    company, 
    SUM(total_laid_off) AS total_laid_off, 
    MAX(total_laid_off) AS max_single_layoff, 
    MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

#-- Step 3: Date range of layoffs
SELECT 
    MIN(STR_TO_DATE(`date`, '%Y-%m-%d')) AS first_layoff_date, 
    MAX(STR_TO_DATE(`date`, '%Y-%m-%d')) AS last_layoff_date
FROM layoffs_staging2;

#-- Step 4: Layoffs by industry
SELECT 
    industry, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

#-- Step 5: Layoffs by year
SELECT 
    YEAR(STR_TO_DATE(`date`, '%Y-%m-%d')) AS `year`, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY `year`
ORDER BY `year` DESC;

#-- Step 6: Layoffs by company stage
SELECT 
    stage, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

#-- Step 7: Rolling monthly layoffs total
WITH rolling_total AS (
    SELECT 
        SUBSTRING(`date`, 1, 7) AS `month`, 
        SUM(total_laid_off) AS monthly_total
    FROM layoffs_staging2
    WHERE `date` IS NOT NULL
    GROUP BY `month`
)
SELECT 
    `month`, 
    monthly_total, 
    SUM(monthly_total) OVER (ORDER BY `month`) AS rolling_total
FROM rolling_total;

#-- Step 8: Top 5 companies with highest layoffs per year
WITH company_cte AS (
    SELECT 
        company, 
        YEAR(STR_TO_DATE(`date`, '%Y-%m-%d')) AS `year`, 
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, `year`
),
company_year_rank AS (
    SELECT 
        *, 
        DENSE_RANK() OVER (PARTITION BY `year` ORDER BY total_laid_off DESC) AS ranking
    FROM company_cte
    WHERE `year` IS NOT NULL
)
SELECT 
    `year`, 
    company, 
    total_laid_off, 
    ranking
FROM company_year_rank
WHERE ranking <= 5
ORDER BY `year`, ranking;
