/*
Employee Attrition Data Analysis

Skills used: SELECT, COUNT, DISTINCT, CONCAT, ROUND, WHERE, CROSS JOIN, CTEs (Common Table Expressions), Subqueries,
             Joins (implicit in the subqueries), Conditional Filtering, Mathematical Operations
*/

-- After cleaning the data, we perform an analysis to answer some simple questions
------------------------------------------------------------------------------------------------------------------------------------------------

-- How many employees does the company have today?

SELECT
    COUNT(DISTINCT EmployeeID) AS EmployeeNum
FROM
    employee_data; -- 4319

------------------------------------------------------------------------------------------------------------------------------------------------

-- How many employees left the company last year?

SELECT
    COUNT(DISTINCT EmployeeID) AS YearlyAttrition
FROM
    employee_data
WHERE
    Attrition = 'Yes'; -- 1138

------------------------------------------------------------------------------------------------------------------------------------------------

-- Percentage of employees who left the company last year.

SELECT
    CONCAT(ROUND(Lefts / CONVERT(FLOAT, Employee_num) * 100, 2), '%') AS Attrition_Percentage
FROM
    (
        SELECT
            COUNT(*) AS Lefts
        FROM
            employee_data
        WHERE
            Attrition = 'Yes'
    ) table1
CROSS JOIN
    (
        SELECT
            COUNT(*) AS Employee_num
        FROM
            employee_data
    ) table2; -- 26% of employees left the company last year.

------------------------------------------------------------------------------------------------------------------------------------------------

-- How many employees with low satisfaction left the company last year?

SELECT
    COUNT(*) AS low_job_sa
FROM
    employee_data
WHERE
    Attrition = 'Yes'
    AND JobSatisfaction = 'Low'; -- 634

------------------------------------------------------------------------------------------------------------------------------------------------

-- What percentage of employees with low job satisfaction left the company?

SELECT
    CONCAT(ROUND(Low_jobSatisfaction_Left / CONVERT(FLOAT, Left_Company) * 100, 1), '%') AS percentages
FROM
    (
        SELECT
            COUNT(JobSatisfaction) AS Low_jobSatisfaction_Left
        FROM
            employee_data
        WHERE
            JobSatisfaction = 'Low'
            AND Attrition = 'Yes'
    ) table1
CROSS JOIN
    (
        SELECT
            COUNT(*) AS Left_Company
        FROM
            employee_data
        WHERE
            Attrition = 'Yes'
    ) table2; -- 55.7% of employees left the company because of low job satisfaction.

------------------------------------------------------------------------------------------------------------------------------------------------

-- How many employees, experiencing a low job environment satisfaction, left the company last year?

SELECT
    COUNT(*) AS low_job_sa
FROM
    employee_data
WHERE
    Attrition = 'Yes'
    AND EnvironmentSatisfaction = 'Low'; -- 310

------------------------------------------------------------------------------------------------------------------------------------------------

-- What percentage of employees with low job environment satisfaction left the company?

SELECT
    CONCAT(ROUND(Low_Enviromment_Left / CONVERT(FLOAT, Left_Company) * 100, 1), '%') AS percentages
FROM
    (
        SELECT
            COUNT(EnvironmentSatisfaction) AS Low_Enviromment_Left
        FROM
            employee_data
        WHERE
            EnvironmentSatisfaction = 'Low'
            AND Attrition = 'Yes'
    ) table1
CROSS JOIN
    (
        SELECT
            COUNT(*) AS Left_Company
        FROM
            employee_data
        WHERE
            Attrition = 'Yes'
    ) table2; -- 27.2% of employees left the company because of low job satisfaction.

------------------------------------------------------------------------------------------------------------------------------------------------

-- How many employees with a low work-life balance left the company last year?

SELECT
    COUNT(*) AS low_WorkLife_Ba
FROM
    employee_data
WHERE
    Attrition = 'Yes'
    AND WorkLifeBalance = 'Bad'; -- 95

------------------------------------------------------------------------------------------------------------------------------------------------

-- What percentage of employees with low work-life balance satisfaction left the company?

SELECT
    CONCAT(ROUND(Bad_WorkLifeBalance_Left / CONVERT(FLOAT, Left_Company) * 100, 1), '%') AS percentages
FROM
    (
        SELECT
            COUNT(WorkLifeBalance) AS Bad_WorkLifeBalance_Left
        FROM
            employee_data
        WHERE
            WorkLifeBalance = 'Bad'
            AND Attrition = 'Yes'
    ) table1
CROSS JOIN
    (
        SELECT
            COUNT(*) AS Left_Company
        FROM
            employee_data
        WHERE
            Attrition = 'Yes'
    ) table2; -- 8.3% of employees left the company because of low job satisfaction.

------------------------------------------------------------------------------------------------------------------------------------------------

-- How many employees with low job involvement departed from the company last year?

SELECT
    COUNT(*) AS low_JobInvolvement
FROM
    employee_data
WHERE
    Attrition = 'Yes'
    AND JobInvolvement = 'Low'; -- 75

------------------------------------------------------------------------------------------------------------------------------------------------

-- What percentage of employees with low job involvement left the company?

SELECT
    CONCAT(ROUND(Low_JobInvolvement_Left / CONVERT(FLOAT, Left_Company) * 100, 1), '%') AS percentages
FROM
    (
        SELECT
            COUNT(JobInvolvement) AS Low_JobInvolvement_Left
        FROM
            employee_data
        WHERE
            JobInvolvement = 'Low'
            AND Attrition = 'Yes'
    ) table1
CROSS JOIN
    (
        SELECT
            COUNT(*) AS Left_Company
        FROM
            employee_data
        WHERE
            Attrition = 'Yes'
    ) table2; -- 6.6% of employees left the company because of low job satisfaction.

------------------------------------------------------------------------------------------------------------------------------------------------

-- How many women and men left the company last year?
-- I first created three temporary tables with the info I need.

WITH female AS
    (
        SELECT
            COUNT(Gender) AS Female_count
        FROM
            employee_data
        WHERE
            Gender = 'Female'
            AND Attrition = 'Yes'
    ), -- count of females who left the company

male AS
    (
        SELECT
            COUNT(Gender) AS Male_count
        FROM
            employee_data
        WHERE
            Gender = 'Male'
            AND Attrition = 'Yes'
    ), -- count of males who left the company

attrition AS
    (
        SELECT
            COUNT(*) AS attrition_count
        FROM
            employee_data
        WHERE
            Attrition = 'Yes'
    ) -- count of employees who left the company

SELECT
    Male_count, Female_count
FROM
    female f1
CROSS JOIN
    male m1; -- 669 males and 469 females left the company last year.

------------------------------------------------------------------------------------------------------------------------------------------------

-- What percentage of men left the company last year?

SELECT
    CONCAT(ROUND(Male_count / CONVERT(FLOAT, attrition_count) * 100, 1), '%') AS percentage_male_left
FROM
    attrition
CROSS JOIN
    male; -- Out of all the people who left the company last year, 58.8% were male.

------------------------------------------------------------------------------------------------------------------------------------------------

-- What percentage of women left the company last year?

SELECT
    CONCAT(ROUND(Female_count / CONVERT(FLOAT, attrition_count) * 100, 1), '%') AS percentage_female_left
FROM
    attrition
CROSS JOIN
    female; -- Out of all the people who left the company last year, 41.2% were female.

------------------------------------------------------------------------------------------------------------------------------------------------

-- Salary by Department. Note: Salary is in Indian Rupees.
-- How many employees left the company for each department?

SELECT
    Department,
    COUNT(*) AS num_employee_left
FROM
    employee_data
WHERE
    Attrition = 'Yes'
GROUP BY
    Department
ORDER BY
    num_employee_left DESC;

------------------------------------------------------------------------------------------------------------------------------------------------

-- How many employees left the company for each JobRole?

SELECT
    JobRole,
    COUNT(*) AS num_employee_left
FROM
    employee_data
WHERE
    Attrition = 'yes'
GROUP BY
    JobRole
ORDER BY
    num_employee_left DESC;

------------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average duration of an employee.

SELECT
    AVG(YearsAtCompany) AS avg_duration
FROM
    employee_data; -- On average, employees last 7 years working for the company.

------------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average duration of employment for employees in each department.

SELECT
    Department,
    AVG(YearsAtCompany) AS avg_duration
FROM
    employee_data
GROUP BY
    Department;

------------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the number of employees with salaries below the department average who left the company.

SELECT
    COUNT(*) AS NumEmpl_below_average_salary
FROM
    employee_data e1
WHERE
    Attrition = 'Yes'
    AND MonthlyIncome < (
        SELECT
            AVG(MonthlyIncome)
        FROM
            employee_data e2
        WHERE
            e1.Department = e2.Department
    ); -- Out of the 1,138 employees who left the company last year, 769 had salaries below the department-based average.

------------------------------------------------------------------------------------------------------------------------------------------------

-- Percentage of employees who left the company and earned below the department average.

WITH average AS
    (
        SELECT
            COUNT(*) AS NumEmpl_below_average_salary
        FROM
            employee_data e1
        WHERE
            Attrition = 'Yes'
            AND MonthlyIncome < (
                SELECT
                    AVG(MonthlyIncome)
                FROM
                    employee_data e2
                WHERE
                    e1.Department = e2.Department
            )
    ),
counts AS
    (
        SELECT
            CONVERT(FLOAT, COUNT(*)) AS Attrition_count
        FROM
            employee_data
        WHERE
            Attrition = 'Yes'
    )

SELECT
    CONCAT(ROUND(NumEmpl_below_average_salary / Attrition_count * 100, 1), '%') AS percentage_left_below_salary
FROM
    counts
CROSS JOIN
    average; -- 67.7% of employees who left the company had a salary below the department average.

------------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average years since the last promotion for employees who left

SELECT
    AVG(YearsSinceLastPromotion) AS AvgYearsSinceLastPromotion_Left
FROM
    employee_data
WHERE
    Attrition = 'Yes'; -- 2 years

-- Calculate the average years since the last promotion for employees who stayed

SELECT
    AVG(YearsSinceLastPromotion) AS AvgYearsSinceLastPromotion_Stayed
FROM
    employee_data
WHERE
    Attrition = 'No'; -- 2 years

------------------------------------------------------------------------------------------------------------------------------------------------

-- Calculate the average tenure (total working years) of employees who left

SELECT
    AVG(TotalWorkingYears) AS AvgTenure_Left
FROM
    employee_data
WHERE
    Attrition = 'Yes'; -- The average tenure of employees who left the company is 9 years

-- Calculate the average tenure (total working years) of employees who stayed

SELECT
    AVG(TotalWorkingYears) AS AvgTenure_Stayed
FROM
    employee_data
WHERE
    Attrition = 'No'; -- The average tenure of employees who stayed at the company is 11 years