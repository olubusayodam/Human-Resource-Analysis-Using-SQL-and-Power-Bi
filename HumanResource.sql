USE PortfolioProject

SELECT *
FROM HumanResource

--Renaming the columns in the table

sp_rename 'HumanResource.id','ID','Column';
sp_rename 'HumanResource.first_name','First_Name','Column';
sp_rename 'HumanResource.last_name','Last_Name','Column';
sp_rename 'HumanResource.birthdate','BirthDate','Column';
sp_rename 'HumanResource.gender','Gender','Column';
sp_rename 'HumanResource.race','Race','Column';
sp_rename 'HumanResource.department','Department','Column';
sp_rename 'HumanResource.jobtitle','JobTitle','Column';
sp_rename 'HumanResource.location','Location','Column';
sp_rename 'HumanResource.hire_date','Hire_Date','Column';
sp_rename 'HumanResource.termdate','TermDate','Column';
sp_rename 'HumanResource.location_city','Location_City','Column';
sp_rename 'HumanResource.location_state','Location_State','Column';

--Checking for all the columns
SELECT *
FROM HumanResource


--checking for the datatypes in the data
sp_help HumanResource


SELECT BirthDate
FROM HumanResource


--Converting the BirthDate Format into similar format
UPDATE HumanResource
SET BirthDate = CASE
    WHEN BirthDate LIKE '%/%' THEN CONVERT(DATE, BirthDate, 101)
    WHEN BirthDate LIKE '%-%' THEN CONVERT(DATE, BirthDate, 101)
    ELSE NULL
END;

--Converting BirthDate from VarChar to Date
ALTER TABLE HumanResource
ALTER COLUMN BirthDate DATE

--Converting Hire Date into correct format
sp_help HumanResource

SELECT Hire_Date
FROM HumanResource

UPDATE HumanResource
SET Hire_Date = CASE
    WHEN CHARINDEX('/', Hire_Date) > 0 THEN CONVERT(DATE, Hire_date, 101)
    ELSE CONVERT(DATE, Hire_Date, 1)
END;


--Converting Hire_Date from VarChar to Date
ALTER TABLE HumanResource
ALTER COLUMN Hire_Date DATE

SELECT Hire_Date
FROM HumanResource

sp_help HumanResource

--Working with TermDate
--Converting TermDate to a Date type
UPDATE HumanResource
SET TermDate = CONVERT(DATE, LEFT(TermDate, 10), 120)
WHERE TermDate IS NOT NULL AND TermDate != ' ';


ALTER TABLE HumanResource
ALTER COLUMN TermDate DATE;

--Adding a new colum age
ALTER TABLE HumanResource
ADD age INT;

--Calculate the age FROM THE BIRTHDATE
UPDATE HumanResource
SET age = DATEDIFF(YEAR, BirthDate, GETDATE());

SELECT BirthDate,age 
FROM HumanResource

--Getting the youngest and the oldest 
SELECT MIN(age) AS Youngest,
       MAX(age) AS Oldest
FROM HumanResource;

--What is the gender breakdown of employees in the company
 SELECT Gender, count(*) AS count
 FROM HumanResource
 GROUP BY Gender

 --What is the Race/Ethnicity breakdown of employees in the company
 SELECT Race, Count(*) AS CountOfRace
 FROM HumanResource
 GROUP BY RACE
 ORDER BY Count(*) asc

 --What is the age distribution of employees in the company?
 SELECT MIN(age) AS Youngest,
       MAX(age) AS Oldest
FROM HumanResource;

--Creating age group
SELECT 
    CASE
        WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
    END AS age_group, 
    gender, 
    COUNT(*) AS count
FROM HumanResource
GROUP BY
    CASE
        WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
    END,
    gender;

--How many Employees work at headquarters versus remote locations
SELECT Location, Count(Location) AS countofLocation
FROM HumanResource
GROUP BY Location

--Average Length of Employment for Employees who have been terminated
SELECT
   ROUND(AVG(DATEDIFF(day, Hire_Date, TermDate) / 365.0), 0) AS avg_length_employment
FROM HumanResource
WHERE 
    TermDate <= GETDATE() 
    AND TermDate IS NOT NULL 
    AND Hire_Date IS NOT NULL
    AND age >= 18;

--How does the gender distribution vary across departments and job titles
SELECT department,gender,COUNT(*) AS count
FROM HumanResource
GROUP BY Department,Gender
ORDER BY  Department

--What is the distribution of JobTitles across the company
SELECT JobTitle, count(*) AS count
FROM HumanResource
GROUP BY JobTitle
ORDER BY JobTitle

--Which department has the highest turnover rate
--Creating a subquery
SELECT Department, 
       total_count, 
       terminated_count, 
       terminated_count * 1.0 / total_count AS termination_rate
FROM (
    SELECT Department, 
           COUNT(*) AS total_count,
           SUM(CASE WHEN TRY_CAST(TermDate AS DATE) IS NOT NULL AND TRY_CAST(TermDate AS DATE) <= GETDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM HumanResource
    WHERE age >= 18
    GROUP BY Department
) AS subquery
ORDER BY termination_rate DESC;

--What is the distribution of employees across locations by city and state

SELECT Location_state, COUNT(*) AS CountState
FROM HumanResource
GROUP BY Location_state
ORDER BY CountState DESC;

--
SELECT Location_City, COUNT(*) AS CountCity
FROM HumanResource
GROUP BY Location_City
ORDER BY CountCity DESC;

--How has the companys employee count changed over time based on hire and term dates
SELECT 
    year, 
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((hires - terminations) * 100.0 / hires, 2) AS net_change_percent
FROM (
    SELECT
        YEAR(Hire_Date) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN TRY_CAST(TermDate AS DATE) IS NOT NULL AND TRY_CAST(TermDate AS DATE) <= GETDATE() THEN 1 ELSE 0 END) AS terminations
    FROM HumanResource
    GROUP BY YEAR(Hire_Date)
) AS subquery
ORDER BY Year ASC;

--What is the average age of employees in each department?
SELECT
    Department,
    ROUND(AVG(age), 0) AS avg_age
FROM HumanResource
WHERE age >= 18
GROUP BY Department;






















  
