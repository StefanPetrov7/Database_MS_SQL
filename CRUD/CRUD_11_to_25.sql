-- 2.	Find All Information About Departments

SELECT * 
FROM Departments

-- 3.	Find all Department Names

SELECT Name
FROM Departments

-- 4.	Find Salary of Each Employee

SELECT FirstName, LastName, Salary
FROM Employees

-- 5.	Find Full Name of Each Employee

SELECT FirstName, MiddleName, LastName
FROM Employees

-- 6.	Find Email Address of Each Employee

SELECT FirstName + '.' + LastName + '@softuni.bg' AS FullEmailAddress
FROM Employees

-- 7.	Find All Different Employee’s Salaries

SELECT DISTINCT Salary 
FROM Employees

-- 8.	Find all Information About Employees => job title is “Sales Representative”. 

SELECT *
FROM Employees
WHERE JobTitle = 'Sales Representative'

-- 9.	Find Names of All Employees by Salary in Range => [20000, 30000].

SELECT FirstName, LastName, JobTitle
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

-- 10 Find Names of All Employees => employees whose salary is 25000, 14000, 12500 or 23600. 

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS FullName
FROM Employees
WHERE Salary = 25000 OR Salary = 14000 OR Salary = 12500 OR Salary = 23600

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS FullName
FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600)

-- 11.	 Find All Employees Without Manager
-- use IS not = as [=NULL will always return false]

SELECT FirstName, LastName
FROM Employees
WHERE ManagerID IS NULL

-- 12.	 Find All Employees with Salary More Than 50000

SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > 50000

-- 13.	 Find 5 Best Paid Employees.

SELECT TOP(5) FirstName, Salary
FROM Employees
ORDER BY Salary DESC

-- 14.	Find All Employees Except Marketing

SELECT FirstName, LastName
FROM Employees 
WHERE JobTitle NOT LIKE '%Marketing'

SELECT FirstName, LastName
FROM Employees 
WHERE DepartmentID != 4

-- 15.	Sort Employees Table

SELECT * 
FROM Employees
ORDER BY 
    Salary DESC,
    FirstName ASC,
    LastName DESC,
    MiddleName ASC

-- 16.	 Create View Employees with Salaries


CREATE VIEW V_EmployeesSalaries AS
SELECT FirstName, LastName, Salary
FROM Employees

SELECT * FROM V_EmployeesSalaries

-- 17.	Create View Employees with Job Titles

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName +  ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS FullName
FROM Employees

-- Update view VIEW V_EmployeeNameJobTitle

DROP VIEW V_EmployeeNameJobTitle
GO

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName +  ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS FullName, JobTitle
FROM Employees


SELECT * FROM V_EmployeeNameJobTitle

-- 18 Distinct Job Titles

SELECT DISTINCT JobTitle
FROM Employees


-- 19.	Find First 10 Started Projects

SELECT TOP(10) *
FROM Projects 
ORDER BY StartDate, Name

-- 20.	 Last 7 Hired Employees

SELECT  TOP(7) *
FROM Employees
ORDER BY HireDate DESC
        
        
-- 21.	Increase Salaries
-- Department ID - 1, 4, 46, 42

SELECT * 
FROM Employees 
WHERE DepartmentID IN (1,4,2,11)


UPDATE Employees
SET Salary *= 1.12
WHERE DepartmentID IN (1,2,4,11)

SELECT Salary
FROM Employees

-- 21 Different Approach

UPDATE Employees 
SET Salary *= 1.12
WHERE DepartmentID IN 
(
    SELECT DepartmentID 
    FROM Departments
    WHERE Name = 'Engineering'
    OR Name = 'Tool Design' 
    OR Name = 'Marketing'
    OR Name = 'Information Services'
)
SELECT Salary
FROM Employees


-- 22.	 All Mountain Peaks
-- Using Geography DB

SELECT PeakName
FROM Peaks
ORDER BY PeakName

-- 23.	 Biggest Countries by Population

SELECT TOP(30) *
FROM Countries
WHERE ContinentCode = 'EU'
ORDER BY Population DESC

-- 24.	 *Countries and Currency (Euro / Not Euro)

SELECT CountryName, CurrencyCode,
    CASE  CurrencyCode WHEN 'EUR' THEN 'Euro'
    ELSE 'NotEuro'
    END AS Curency
FROM Countries

-- 25.	 All Diablo Characters

SELECT * 
FROM Characters
ORDER BY Name







     





 


