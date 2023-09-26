/*
Employee Attrition Data Cleaning

Skills used: Joins, Temp Tables, CTE's, Window Functions, Creating Views, Converting Data Types,
             SELECT, INTO, sp_rename, UPDATE, DELETE, COUNT, GROUP BY, CASE, ALTER TABLE, DROP COLUMN, DISTINCT
*/

------------------------------------------------------------------------------------------------------------------------------------------------

/*** Creating Temp Tables ***/
SELECT
    m1.EmployeeID,
    Department,
    Gender,
    PercentSalaryHike,
    StockOptionLevel,
    TrainingTimesLastYear,
    TotalWorkingYears,
    YearsAtCompany,
    YearsSinceLastPromotion,
    Attrition,
    JobRole,
    MonthlyIncome,
    JobInvolvement,
    PerformanceRating,
    EnvironmentSatisfaction,
    JobSatisfaction,
    WorkLifeBalance,
    DistanceFromHome
INTO employee_data 
FROM manager_survey_data m1
INNER JOIN employee_survey_data m2
ON m1.EmployeeID = m2.EmployeeID
INNER JOIN general_data m3
ON m2.EmployeeID = m3.EmployeeID;

/*** Wrangling data ***/
-- Start by changing bad column names. In this case, we'll change the TOTALWORKINGYEARS column name to 'TotalWorkingYears'
-- and the atriiitdon column name to Attrition
EXEC sp_rename 'employee_data.TOTALWORKINGYEARS', 'TotalWorkingYears', 'COLUMN'; 
EXEC sp_rename 'employee_data.atriiitdon', 'Attrition', 'COLUMN';

-- Now use ‘TRIM’ to remove all unwanted spaces from all text columns. This is the beginning of standardization.
UPDATE employee_data
SET Department = TRIM(Department),
    Gender = TRIM(Gender),
    JobRole = TRIM(JobRole);

------------------------------------------------------------------------------------------------------------------------------------------------

-- Check for null values
SELECT TOP (1000) [EmployeeID],
    [Department],
    [Gender],
    [PercentSalaryHike],
    [StockOptionLevel],
    [TrainingTimesLastYear],
    [TotalWorkingYears],
    [YearsAtCompany],
    [YearsSinceLastPromotion],
    [Attrition],
    [JobRole],
    [MonthlyIncome],
    [JobInvolvement],
    [PerformanceRating],
    [EnvironmentSatisfaction],
    [JobSatisfaction],
    [WorkLifeBalance],
    [DistanceFromHome]
FROM [SQL TUTORIAL].[dbo].[employee_data]
WHERE [EmployeeID] IS NULL
    OR [Department] IS NULL
    OR [Gender] IS NULL
    OR [PercentSalaryHike] IS NULL
    OR [StockOptionLevel] IS NULL
    OR [TrainingTimesLastYear] IS NULL
    OR [TotalWorkingYears] IS NULL
    OR [YearsAtCompany] IS NULL
    OR [YearsSinceLastPromotion] IS NULL
    OR [Attrition] IS NULL
    OR [JobRole] IS NULL
    OR [MonthlyIncome] IS NULL
    OR [JobInvolvement] IS NULL
    OR [PerformanceRating] IS NULL
    OR [EnvironmentSatisfaction] IS NULL
    OR [JobSatisfaction] IS NULL
    OR [WorkLifeBalance] IS NULL
    OR [DistanceFromHome] IS NULL;

-- The following columns contain nulls: total working hours, environment, job satisfaction, work life balance

-- The Worklifebalance column contains 38 nulls.
SELECT
    COUNT (*) AS worklifebalance
FROM employee_data
WHERE WorkLifeBalance IS NULL;

-- The TotalWorkingYears column contains 9 nulls.
SELECT
    COUNT (*) AS totalworkingyears
FROM employee_data
WHERE TotalWorkingYears IS NULL;

-- The JobSatisfaction column contains 20 nulls.
SELECT
    COUNT (*) AS jobsatisfaction
FROM employee_data
WHERE JobSatisfaction IS NULL;

-- The EnvironmentalSatisfaction column contains 25 nulls.
SELECT
    COUNT (*) AS environmentalSatisfaction
FROM employee_data
WHERE EnvironmentSatisfaction IS NULL;

------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete rows with missing values

-- JobSatisfaction
DELETE FROM employee_data
WHERE JobSatisfaction IS NULL;

-- EnvironmentalSatisfaction
DELETE FROM employee_data
WHERE EnvironmentSatisfaction IS NULL;

-- TotalWorkingYears
DELETE FROM employee_data
WHERE TotalWorkingYears IS NULL;

-- WorkLifeBalance
DELETE FROM employee_data
WHERE WorkLifeBalance IS NULL;

------------------------------------------------------------------------------------------------------------------------------------------------

-- Check for duplicates
SELECT
    EmployeeID,
    COUNT(EmployeeID) AS duplicates
FROM employee_data
GROUP BY EmployeeID
HAVING COUNT(EmployeeID) > 1;

------------------------------------------------------------------------------------------------------------------------------------------------

-- Verifying Standardization
-- Ensuring consistency in the 'department' column by identifying and correcting any inconsistent data entries.

SELECT 
    Department
FROM employee_data
GROUP BY Department;

-- Update inconsistent values in the 'Department' column
UPDATE employee_data
SET 
    Department =
    CASE 
        WHEN Department = 'SaLES' THEN 'Sales'
        WHEN Department = 'reSEARCHANDDEvelopment' THEN 'Research & Development'
        ELSE Department
    END
WHERE Department = 'SaLES' OR Department = 'reSEARCHANDDEvelopment';

-- Check for inconsistent data entries in the 'JobRole' column
SELECT 
    JobRole
FROM employee_data
GROUP BY JobRole;

-- Update inconsistent values in the 'JobRole' column
UPDATE employee_data
SET
    JobRole = 
    CASE
        WHEN JobRole = 'HUMANRESOURCES' THEN 'Human Resources'
        WHEN JobRole = 'SaLESExecutive' THEN 'Sales Executive'
        ELSE JobRole
    END
WHERE JobRole = 'HUMANRESOURCES' OR JobRole = 'SaLESExecutive';

-- Change the values of the 'Attrition' column: 0 = No, 1 = Yes
ALTER TABLE employee_data
ALTER COLUMN Attrition varchar(3); 

-- Update the values of the 'Attrition' column
UPDATE employee_data
SET
    Attrition = 
    CASE 
        WHEN Attrition = 0 THEN 'No'
        WHEN Attrition = 1 THEN 'Yes'
        ELSE Attrition
    END;

-- Update other columns with similar patterns (JobInvolvement, PerformanceRating, EnvironmentSatisfaction, JobSatisfaction, WorkLifeBalance)

ALTER TABLE employee_data
ALTER COLUMN JobInvolvement varchar(50);

UPDATE employee_data
SET
    JobInvolvement = 
    CASE 
        WHEN JobInvolvement = 1 THEN 'Low'
        WHEN JobInvolvement = 2 THEN 'Medium'
        WHEN JobInvolvement = 3 THEN 'High'
        WHEN JobInvolvement = 4 THEN 'Very High'
        ELSE JobInvolvement
    END;

-- PerformanceRating
ALTER TABLE employee_data
ALTER COLUMN PerformanceRating varchar(50);

UPDATE employee_data
SET
    PerformanceRating = 
    CASE 
        WHEN PerformanceRating = 1 THEN 'Low'
        WHEN PerformanceRating = 2 THEN 'Good'
        WHEN PerformanceRating = 3 THEN 'Excellent'
        WHEN PerformanceRating = 4 THEN 'Outstanding'
        ELSE PerformanceRating
    END;

-- EnvironmentSatisfaction
ALTER TABLE employee_data
ALTER COLUMN EnvironmentSatisfaction varchar(50);

UPDATE employee_data
SET
    EnvironmentSatisfaction = 
    CASE 
        WHEN EnvironmentSatisfaction = 1 THEN 'Low'
        WHEN EnvironmentSatisfaction = 2 THEN 'Medium'
        WHEN EnvironmentSatisfaction = 3 THEN 'High'
        WHEN EnvironmentSatisfaction = 4 THEN 'Very High'
        ELSE EnvironmentSatisfaction
    END;

-- JobSatisfaction
ALTER TABLE employee_data
ALTER COLUMN JobSatisfaction varchar(50);

UPDATE employee_data
SET
    JobSatisfaction = 
    CASE 
        WHEN JobSatisfaction = 1 THEN 'Low'
        WHEN JobSatisfaction = 2 THEN 'Medium'
        WHEN JobSatisfaction = 3 THEN 'High'
        WHEN JobSatisfaction = 4 THEN 'Very High'
        ELSE JobSatisfaction
    END;

-- WorkLifeBalance
ALTER TABLE employee_data
ALTER COLUMN WorkLifeBalance varchar(50);

UPDATE employee_data
SET
    WorkLifeBalance = 
    CASE 
        WHEN WorkLifeBalance = 1 THEN 'Bad'
        WHEN WorkLifeBalance = 2 THEN 'Good'
        WHEN WorkLifeBalance = 3 THEN 'Better'
        WHEN WorkLifeBalance = 4 THEN 'Best'
        ELSE WorkLifeBalance
    END;

-- All the employees have a performance rating of either "Excellent" or "Outstanding." As a result, we could remove this column from the table
-- since it won't affect the analysis.
ALTER TABLE employee_data
DROP COLUMN PerformanceRating;

-- Now we check one last time to ensure that the df_employees table is clean and ready to be used for analysis. 
-- We have done all of this without changing the actual database, which is very important.
SELECT * 
FROM employee_data;