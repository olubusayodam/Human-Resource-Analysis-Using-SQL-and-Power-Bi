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

SELECT TermDate
FROM HumanResource

SELECT *
FROM HumanResource
WHERE TermDate IS NOT NULL AND TRY_CAST(TermDate AS DATE) IS NULL;

UPDATE HumanResource
SET TermDate = CAST(TermDate AS DATE)

UPDATE HumanResource
SET TermDate = CONVERT(DATE, TermDate)
WHERE TermDate IS NOT NULL;