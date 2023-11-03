Use Softuni

SELECT * 
	FROM Departments

SELECT  [Name]
	FROM Departments

SELECT FirstName, LastName, Salary
	FROM Employees

SELECT FirstName, MiddleName, LastName
	FROM Employees

SELECT FirstName + '.' + LastName + '@softuni.bg' AS [Full Email Address]
	FROM Employees
	
SELECT DISTINCT Salary
	FROM Employees

SELECT *
	FROM Employees
	WHERE JobTitle = 'Sales Representative'

SELECT FirstName, LastName, JobTitle
	FROM Employees
	WHERE Salary BETWEEN 20000 AND 30000

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [Full Name]
	FROM Employees	
	WHERE Salary = 25000 OR Salary = 14000 OR Salary =  12500 OR Salary = 23600

SELECT FirstName, LastName
	FROM Employees
	WHERE ManagerID IS NULL

SELECT  FirstName, LastName, Salary
	FROM Employees		
	WHERE Salary > 50000
	ORDER BY Salary DESC

SELECT TOP(5)
	FirstName, LastName
	FROM Employees
	ORDER BY Salary DESC

SELECT FirstName, LastName
	FROM Employees
	WHERE DepartmentID != 4

SELECT *
	FROM Employees
	ORDER BY Salary DESC,
	FirstName ASC,
	LastName DESC,
	MiddleName ASC

CREATE VIEW V_EmployeesSalaries AS
SELECT FirstName, LastName, Salary
	FROM Employees
	
DROP VIEW V_EmployeesSalaries

-- -> Need to be checked

CREATE VIEW V_EmployeeNameJobTitle AS
	SELECT FirstName + ' ' + ISNULL(MiddleName, ' ') + ' ' + LastName AS [Full Name], JobTitle
	FROM Employees

DROP VIEW V_EmployeeNameJobTitle

-- ->

SELECT DISTINCT JobTitle
	FROM Employees

SELECT TOP(10) *
	FROM Projects
	ORDER BY StartDate ASC,
	[Name] ASC


SELECT TOP(7) FirstName, LastName, HireDate
	FROM Employees
	ORDER BY HireDate DESC

-- -> Need to be checked

UPDATE Employees	
	SET Salary = Salary * 1.12
	WHERE JobTitle LIKE '%Marketing%' OR 
	JobTitle LIKE '%Tool%' OR
	JobTitle LIKE '%Engineering%' OR
	JobTitle LIKE '%Information %'

SELECT *
FROM Employees	
	WHERE JobTitle LIKE '%Marketing%' OR 
	JobTitle LIKE '%Tool%' OR
	JobTitle LIKE '%Engineering%' OR
	JobTitle LIKE '%Information %'

SELECT Salary
	FROM Employees

-- ->

Use Geography

SELECT PeakName
	FROM Peaks
	ORDER BY PeakName ASC

SELECT TOP(30) [CountryName], [Population]
	FROM Countries
	WHERE ContinentCode = 'EU'
	ORDER BY Population DESC


SELECT CountryName, CountryCode,
	CASE 
	WHEN CurrencyCode = 'EUR' THEN 'Euro'
	WHEN CountryCode != 'EUR' THEN 'Not Euro'
	END AS [Currency] 
	FROM Countries
	ORDER BY CountryName Asc

Use Diablo

SELECT [Name]
	FROM Characters
	ORDER BY [Name] ASC








	








