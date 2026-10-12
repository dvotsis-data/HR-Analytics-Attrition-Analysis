
/*
=============================================================
PROJECT: HR Analytics - Employee Attrition Analysis
TOOLS: MySQL / Power BI
PURPOSE: Explore employee attrition patterns and identify
         workforce segments for further HR investigation.

NOTE: Results describe associations, not causal effects.
=============================================================
*/

USE hrdb;

-- ===========================================================
-- 1. DATA EXPLORATION & QUALITY VALIDATION
-- ===========================================================

SELECT *
FROM hr_data
LIMIT 10;

-- Check employee uniqueness
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT EmployeeNumber) AS Unique_Employees
FROM hr_data;

-- Check missing values in key analysis fields
SELECT
    COUNT(*) AS Total_Rows,
    SUM(Attrition IS NULL) AS Missing_Attrition,
    SUM(Age IS NULL) AS Missing_Age,
    SUM(Department IS NULL) AS Missing_Department,
    SUM(JobSatisfaction IS NULL) AS Missing_JobSatisfaction,
    SUM(YearsAtCompany IS NULL) AS Missing_YearsAtCompany,
    SUM(OverTime IS NULL) AS Missing_OverTime
FROM hr_data;


-- ===========================================================
-- 2. OVERALL EMPLOYEE ATTRITION
-- ===========================================================

SELECT
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS Attrition_Rate
FROM hr_data;


-- ===========================================================
-- 3. ATTRITION BY DEPARTMENT
-- ===========================================================

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS Attrition_Rate,
    ROUND(AVG(JobSatisfaction), 2)
        AS Avg_Job_Satisfaction
FROM hr_data
WHERE Department IS NOT NULL
GROUP BY Department
ORDER BY Attrition_Rate DESC;


-- ===========================================================
-- 4. ATTRITION BY AGE GROUP
-- ===========================================================

SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age <= 40 THEN '30-40'
        ELSE '41+'
    END AS Age_Group,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS Attrition_Rate
FROM hr_data
WHERE Age IS NOT NULL
GROUP BY Age_Group
ORDER BY Attrition_Rate DESC;


-- ===========================================================
-- 5. ATTRITION BY JOB SATISFACTION
-- ===========================================================

SELECT
    JobSatisfaction,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS Attrition_Rate
FROM hr_data
WHERE JobSatisfaction IS NOT NULL
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;


-- ===========================================================
-- 6. ATTRITION BY EMPLOYEE TENURE
-- ===========================================================

SELECT
    CASE
        WHEN YearsAtCompany < 2 THEN '0-1 years'
        WHEN YearsAtCompany < 5 THEN '2-4 years'
        WHEN YearsAtCompany < 10 THEN '5-9 years'
        ELSE '10+ years'
    END AS Tenure_Group,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS Attrition_Rate
FROM hr_data
WHERE YearsAtCompany IS NOT NULL
GROUP BY Tenure_Group
ORDER BY Attrition_Rate DESC;


-- ===========================================================
-- 7. ATTRITION BY OVERTIME STATUS
-- ===========================================================

SELECT
    OverTime,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS Attrition_Rate
FROM hr_data
WHERE OverTime IN ('Yes', 'No')
GROUP BY OverTime
ORDER BY Attrition_Rate DESC;


-- ===========================================================
-- 8. COMBINED ANALYSIS: TENURE × OVERTIME
-- ===========================================================

SELECT
    CASE
        WHEN YearsAtCompany < 2 THEN '0-1 years'
        ELSE '2+ years'
    END AS Tenure_Group,
    OverTime,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS Attrition_Rate
FROM hr_data
WHERE YearsAtCompany IS NOT NULL
  AND OverTime IN ('Yes', 'No')
GROUP BY Tenure_Group, OverTime
ORDER BY Attrition_Rate DESC;


-- ===========================================================
-- 9. DATA VIEW FOR POWER BI
-- ===========================================================

CREATE OR REPLACE VIEW View_HR_Analysis AS
SELECT
    EmployeeNumber,
    Age,
    Gender,
    Department,
    JobRole,
    MonthlyIncome,
    JobSatisfaction,
    Attrition,
    CASE
        WHEN Age IS NULL THEN NULL
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age <= 40 THEN '30-40'
        ELSE '41+'
    END AS Age_Group,
    CASE
        WHEN Attrition = 'Yes' THEN 1
        WHEN Attrition = 'No' THEN 0
        ELSE NULL
    END AS Attrition_Flag
FROM hr_data;
