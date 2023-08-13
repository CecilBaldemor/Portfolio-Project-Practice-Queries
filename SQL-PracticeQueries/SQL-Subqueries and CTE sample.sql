 /*

 SUBqueries
 */

 SELECT *
 FROM EmployeeSalary

 --Subquery in SELECT

 SELECT EmployeeID, Salary, (Select AVG(Salary) FROM EmployeeSalary)
 FROM EmployeeSalary


 --Partition BY

 SELECT EmployeeID, Salary, AVG(Salary) over() AS AllAvgSalary
 FROM EmployeeSalary

--Subqueries for FROM

SELECT a.AllAvgSalary,a. EmployeeID
 FROM(SELECT EmployeeID, Salary, AVG(Salary) over() AS AllAvgSalary
 FROM EmployeeSalary)AS a

 --Subqueries for WHERE

 SELECT EmployeeID, JobTitle, Salary
 FROM EmployeeSalary
 WHERE EmployeeID In (
		SELECT EmployeeID FROM EmployeeDemographics 
		WHERE Age>30)


**************

		
--CTEs

WITH CTE_Employee AS
(SELECT FirstName, LastName, Gender, salary,
		COUNT(Gender) over (Partition by Gender) AS TotalGender,
		AVG(Salary) over (Partition by Gender) AS AvgSalGender
FROM EmployeeDemographics dem
join EmployeeSalary sal
		on dem.EmployeeID= sal.EmployeeID
WHERE salary> 45000)

SELECT *
FRom CTE_Employee




*********
/*

Today's Topic: String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower

*/

--Drop Table EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 

	



-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors
 

-- Using Substring

Select SUBSTRING(err.FirstName,1,3), SUBSTRING(dem.FirstName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on SUBSTRING(err.FirstName,1,3) = SUBSTRING(dem.FirstName,1,3)
	

SELECT *
FROM EmployeeErrors

SELECT*
FROM EmployeeDemographics



-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, UPPER(FirstName)
from EmployeeErrors