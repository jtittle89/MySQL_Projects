-- Beginning Data
SELECT *
FROM hr_analytics;

-- Current Employee Count by Age Group
SELECT 
	AgeGroup,
    COUNT(*) as current_employee_count
FROM hr_analytics
WHERE Attrition = 'No'
GROUP BY AgeGroup;

-- Current Employees by Department
SELECT Department, COUNT(*) as current_employee_count
FROM hr_analytics
WHERE Attrition = 'No'
GROUP BY Department; 

-- Company Attrition Rate (Columns for Yes, No, Total Employees, and Attrition Rate using sub queries)
 SELECT
	(SELECT COUNT(*) FROM hr_analytics WHERE Attrition = 'Yes') AS previous_employees,
    (SELECT COUNT(*) FROM hr_analytics WHERE Attrition = 'No') AS current_employees,
    COUNT(*) AS total_employees,
    CONCAT(ROUND(((SELECT COUNT(*) FROM hr_analytics WHERE Attrition = 'Yes')/COUNT(*))*100,2),"%") AS attrition_rate
 FROM hr_analytics;

-- Current Employees by Gender (Columns for Male and Female)
SELECT 
	(SELECT COUNT(*) FROM hr_analytics WHERE Gender = 'Male') AS male_employees,
    (SELECT COUNT(*) FROM hr_analytics WHERE Gender = 'Female') AS female_employees
FROM hr_analytics
GROUP BY male_employees;

-- Pay gap between male and female employees based on job role
SELECT 
    JobRole,
    ROUND(AVG(CASE WHEN Gender = 'Male' THEN MonthlyIncome END), 2) AS male_income,
    ROUND(AVG(CASE WHEN Gender = 'Female' THEN MonthlyIncome END), 2) AS female_income,
    ROUND(
        COALESCE(AVG(CASE WHEN Gender = 'Male' THEN MonthlyIncome END), 0) - 
        COALESCE(AVG(CASE WHEN Gender = 'Female' THEN MonthlyIncome END), 0), 
    2) AS income_difference
FROM hr_analytics
GROUP BY JobRole;

-- Top and Lowest Income Employees (Try to do top 5 for both, try ChatGBT for assistance)
(SELECT EmployeeNumber, MonthlyIncome, Department, JobRole, "Top 5 Income" AS Income_Category
 FROM hr_analytics
 ORDER BY MonthlyIncome DESC
 LIMIT 5)
 
UNION ALL

(SELECT EmployeeNumber, MonthlyIncome, Department, JobRole,"Bottom 5 Income" AS Income_Category
 FROM hr_analytics
 ORDER BY MonthlyIncome ASC
 LIMIT 5);

-- Lowest Employee Job Satisfaction (Use CASE statement for a column stating that employees need to be spoken to)
SELECT
	EmployeeNumber,
    JobRole,
    JobSatisfaction,
    "Speak to Manager" AS Action_Needed
FROM hr_analytics
WHERE JobSatisfaction = 1 AND Attrition = 'No';

SELECT 
	(SELECT COUNT(*) FROM hr_analytics WHERE JobSatisfaction = 1 AND Attrition = 'No') AS current_emp_low_job_sat,
    (SELECT COUNT(*) FROM hr_analytics WHERE Attrition = 'No') AS total_current_employees,
    CONCAT(ROUND((SELECT COUNT(*) FROM hr_analytics WHERE JobSatisfaction = 1 AND Attrition = 'No')/(SELECT COUNT(*) FROM hr_analytics WHERE Attrition = 'No')*100,2),"%") as rate
FROM hr_analytics
GROUP BY current_emp_low_job_sat;

-- Percent Raise (SalaryHike) compared to performance (Determine average PercentSalaryHike based on Performance Rating, maybe also department)
SELECT Department, ROUND(avg(PercentSalaryHike),0) AS avg_raise,PerformanceRating
FROM hr_analytics
GROUP BY Department, PerformanceRating
ORDER BY Department;

-- Work Location based on DistanceFromHome (CASE statement for employees who can work in office, hybrid, or remote based on distance from home, group by the options)
SELECT 
	CASE
		WHEN DistanceFromHome <= 10 THEN "In Office"
        WHEN DistanceFromHome between 11 AND 20 THEN "Hybrid"
        ELSE "Work From Home"
	END AS work_location,
	COUNT(*) as employee_count
FROM hr_analytics
WHERE Attrition = 'No'
GROUP BY work_location;

-- Average monthly income based on job role and education. Showing the pay difference based on job role and education.

WITH income_data AS (
    SELECT 
        JobRole,
        CASE
            WHEN Education = 1 THEN "Technical Degree"
            WHEN Education = 2 THEN "Associates Degree"
            WHEN Education = 3 THEN "Bachelors Degree"
            WHEN Education = 4 THEN "Masters Degree"
            ELSE "Doctorate"
        END AS education_level,
        ROUND(AVG(MonthlyIncome), 2) AS avg_income
    FROM hr_analytics
    WHERE Attrition = 'No'
    GROUP BY JobRole, Education
)
SELECT 
    JobRole,
    education_level,
    avg_income,
    ROUND(avg_income - LAG(avg_income) OVER (ORDER BY avg_income ASC), 2) AS pay_difference
FROM income_data
ORDER BY avg_income ASC;


