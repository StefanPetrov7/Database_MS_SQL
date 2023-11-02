-- -> Select DB

USE SoftUni

-- -> Select three columns and order them by descending

SELECT FirstName, LastName, JobTitle
	FROM dbo.Employees
	ORDER BY FirstName ASC 

-- -> Select Emplyees column

SELECT * FROM Employees

-- -> Select two columns as one and add two more after them 

SELECT FirstName + ' '  + LastName AS [Full Name], JobTitle, Salary
	FROM Employees

-- -> Using distinct to remove the repeat lines

SELECT DISTINCT JobTitle
	FROM Employees

-- -> Sorting using WHERE and a predicate 

SELECT FirstName, LastName, JobTitle
	FROM Employees
	WHERE Salary > 1000

SELECT FirstName, LastName, JobTitle, HireDate
	FROM Employees
	WHERE Salary > 2000 AND HireDate > '2000'
	ORDER BY FirstName ASC 

SELECT FirstName + ' ' + LastName AS [Full Name]
	FROM Employees

SELECT TOP(10)
	FirstName + ' ' + LastName + ' ' + STR(Salary) AS [Full Name and salary]
	FROM Employees

-- -> When looking for NULL values operator IS has to be used, instead of =

SELECT FirstName, LastName
	FROM Employees
	WHERE ManagerID IS NOT NULL 

-- -> LIKE %....% => contains in a string, looking for the value between the % symbol 
-- -> RegEx can be used with LIKE example => LIKE '[ABDC]%'....

SELECT FirstName, LastName, JobTitle
	FROM Employees
	WHERE JobTitle LIKE '%Manager%'

-- -> Creating VIEW's

CREATE VIEW v_EmployeesWithSalariesOver2000 AS
	SELECT FirstName, LastName, JobTitle
	FROM Employees
	WHERE Salary > 2000

SELECT * FROM v_EmployeesWithSalariesOver2000

DROP VIEW v_EmployeesWithSalariesOver2000

CREATE VIEW v_EmployeesManagers AS
	SELECT FirstName, LastName, JobTitle
	FROM Employees
	WHERE JobTitle LIKE '%Manager%'

SELECT * FROM v_EmployeesManagers

DROP VIEW v_EmployeesManagers

-- ->  Select new DB

Use Geography

CREATE VIEW v_HighiestPeak AS
SELECT TOP(1) 
	PeakName, Elevation, MountainId
	FROM Peaks
	ORDER BY Elevation DESC

DROP VIEW v_HighiestPeak

USE SoftUni

-- -> Update table example

UPDATE Employees
	SET LastName = 'Test'
	WHERE EmployeeID = 1

UPDATE Projects
	SET EndDate = GETDATE()
	WHERE EndDate IS NULL

SELECT * FROM Projects
WHERE EndDate = '2023-11-02 23:01:00'




