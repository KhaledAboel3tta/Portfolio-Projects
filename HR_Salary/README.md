

***

# HR Salary Analysis Project (Comprehensive Data Analysis using Excel)

## Project Overview

This project is a complete analytical study of an **HR Data Set** with a primary focus on **Salary Analysis**. The goal is to analyze the company’s current salary distribution policies, assess fairness, and provide key recommendations to support informed business decisions regarding compensation.

**Data Scope:**
*   **Domain:** Human Resources (HR).
*   **Size:** 500 employees (rows) and 10 columns.
*   **Core Task:** Analyzing salary trends (Salary Analysis).

## Tools and Technologies Used

This project was executed entirely using **Microsoft Excel**, leveraging advanced features for data handling and modeling:

*   **Power Query:** Used for data import, cleaning, and preparation.
*   **Power Pivot:** Used to create data relationships and define measures (Key Performance Indicators).
*   **DAX (Data Analysis Expressions):** Used within Power Pivot to write formulas for KPIs and critical metrics.
*   **Pivot Tables & Charts:** Used for generating reports and visualizations.
*   **VBA Code:** Used to implement an interactive **Reset Button** function to clear all slicer filters in the workbook.
*   **Custom Number Formatting (Value Scaling):** Applied to present large numbers (like total salary) in abbreviated formats (e.g., K, M) for better readability.

## Data Preparation and Cleaning (Power Query)

Data cleaning and transformation were performed meticulously in the Power Query Editor.

1.  **Initial Assessment:** The data set contained 500 rows/employees. The `Employee ID` column was confirmed to be the Primary Key with no duplicates.
2.  **Handling Name Duplicates:** An instance of a duplicated name (`Sarah Carpenter`) was found. Upon investigation, differences in `Employee ID`, `Department` (R&D vs. HR), `Age` (53 vs. 30), `Salary` ($200k vs. $5k), and `Educational Level` (High School vs. Master's) confirmed they were **two distinct individuals**, so both records were kept.
3.  **Text Standardization:**
    *   The `Gender` column was corrected, replacing the misspelling 'M E A L' with the correct 'M A L E'.
    *   The `Location` column was standardized using the "Capitalize Each Word" function to fix inconsistent capitalization (e.g., San Jose).
    *   The `Educational Level` was unified by replacing 'Bachelor' with 'BSc'.
    *   **Trim** and **Clean** functions were applied to all text columns to remove leading/trailing spaces and non-printable characters.
4.  **Data Validation:** Age and experience ranges were inspected to ensure they fell within plausible limits (e.g., Age 22 to 60, Experience 0 to 37) to avoid obvious errors or violations of labor law (e.g., hiring under 15 or over 60).
5.  **Outlier Detection (Salary):**
    *   The **Z-Score method** was applied to the `Salary` column to identify outliers.
    *   **Z-Score Formula:** (Value - Mean) / Standard Deviation.
    *   Outliers were defined as scores greater than +3 or less than -3.
    *   Three high-salary outliers were found, all within the R&D department (Sarah Carpenter, Jordan George, Kristin). The decision was made to **keep these outliers**, assuming the data was verified as legitimate company compensation.
6.  **Job Classification:** A separate table (`Job Class`) was imported to categorize the 21 unique `Job Titles` into three major organizational levels: **Entry Level, Mid Level, and Managerial Level**.

## Data Modeling and Key Metric Creation

The data model was built in Power Pivot, and essential metrics were created using DAX.

### Relationships

A one-to-many relationship was established between the main `HR Salary` table and the `Job Class` table using the `Job Title` column.

### Core KPIs (Measures)

Initial measures were created:
*   `Employees`: Count of `Employee ID`
*   `Departments`: Distinct Count of `Department`
*   `Locations`: Distinct Count of `Location`
*   `Salaries`: Sum of `Salary`
*   `Average Salary`: Average of `Salary`

### Critical Metric Transformation (The Modified Average Salary)

A strong **Linear Correlation** was identified between `Salary` and `Experience (Years)`, indicating that experience significantly inflates the absolute salary value. To achieve a fairer comparison across different roles and tenure levels, the influence of experience had to be negated.

The **Modified Average Salary** measure was created using a Custom Column in Power Query. This metric represents the average salary earned per year of experience.

$$\text{Modified Average Salary} = \frac{\text{Salary}}{\text{Experience (Years)} + 1}$$

*   *(Note: $+1$ is added to the denominator to prevent division by zero for fresh graduates/employees with 0 experience)*.
*   **All subsequent analyses and visualizations in the dashboard rely on this Modified Average Salary**.

## Dashboard Design and Interactivity

An interactive dashboard was created to present the findings.

### Interactive Controls

*   **Slicers:** Implemented for filtering by `Department`, `Job Title`, and the custom `Job Level`.
*   **VBA Reset Button:** A button was programmed using VBA code to clear all active filters on the slicers across the entire workbook with a single click.
*   **Navigation Buttons:** Provided easy linking to switch between the Analysis sheet, the Dashboard sheet, and the Recommendations/Report sheet.

## Key Insights and Recommendations

The analysis was performed based on the **Modified Average Salary** to assess the fairness of company policy.

1.  **Location-Based Salary Gaps (Branches):**
    *   Locations were confirmed to be company branches, as seven distinct departments existed in each location.
    *   The analysis revealed **significant gaps** in the modified average salary for the same job title across different branches (e.g., Account Manager salaries were vastly different between Indianapolis and Philadelphia).
    *   **Recommendation:** The company must review and standardize compensation structures across its different branches to ensure parity for the same roles.

2.  **Disregard for Educational Level:**
    *   In many departments and levels (especially Entry Level), the analysis showed that `Educational Level` was **not a factor** in determining the modified average salary. In some instances, High School diploma holders had higher averages than those with Master's or PhDs.
    *   **Recommendation:** Salary policies should be re-evaluated to appropriately compensate higher degrees (e.g., PhD, Master's), recognizing them as a factor that should raise the average salary.

3.  **Departmental Pay Disparities:**
    *   The **Marketing** department was identified as having the highest average salaries, particularly at the Entry Level.
    *   **Recommendation:** HR management should review and adjust the salary frameworks across different departments to ensure internal equity and balance.

## Notes for GitHub Publication

To ensure that the project file functions correctly when downloaded and used by others, please note the following:

1.  **File Format:** The Excel workbook **must be saved as a Macro-Enabled Workbook (`.xlsm` or `.xlsb`)**. This is essential because the Reset Button relies on VBA code.
2.  **Macro Security:** Users must be instructed to **Enable Macros** upon opening the file.
3.  **Data Model:** The workbook contains a robust Data Model built in Power Pivot and relies on linked tables (HR Salary data and Job Classification data).
4.  **Custom Number Formatting:** The project uses a custom number format (`[>999999]0.00,,"M";[>999]0.0,"K";0`) for KPI figures.
