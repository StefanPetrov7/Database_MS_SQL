-- -> BUILD IN FUNCTIONS

SELECT CustomerID, 
		FirstName, 
		LastName, 
		PaymentNumber, 
		LEFT(PaymentNumber,6) + REPLICATE('*', LEN(PaymentNumber)-6)	-- -> replacing the last 6 numbers with *
	FROM Customers

-- -> Exercises: Built-in Functions

-- -> Find Names of All Employees by First Name

SELECT FirstName, LastName
	FROM Employees
	WHERE SUBSTRING(FirstName,1,2) = 'Sa'

-- -> Find Names of All Employees by Last Name 

SELECT FirstName, LastName
	FROM Employees
	WHERE LastName LIKE '%ei%'  -- -> Using wildcard to macth if the string contains 'ei'


-- -> ⦁	Find First Names of All Employees

SELECT FirstName
	FROM Employees
	WHERE DepartmentID IN(3,10)
	AND YEAR(HireDate) BETWEEN '1995' AND '2005'

-- -> ⦁	Find All Employees Except Engineers

SELECT FirstName, LastName
	FROM Employees
	WHERE JobTitle NOT LIKE '%engineer%'

-- -> ⦁	Find Towns with Name Length

SELECT [Name] 
	FROM Towns
	WHERE LEN([Name]) IN (5,6)
	ORDER BY [Name] ASC

-- -> ⦁	Find Towns Starting With

SELECT [TownID], [Name]
	FROM Towns
	WHERE SUBSTRING([Name],1,1) IN ('M','K','B','E')
	ORDER BY [Name] ASC
	 
-- -> ⦁	Find Towns Not Starting With

SELECT [TownID], [Name]
	FROM Towns
	WHERE SUBSTRING([Name],1,1) NOT IN ('R','D','B')
	ORDER BY [Name] ASC

-- -> ⦁	Create View Employees Hired After 2000 Year

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT [FirstName], [LastName]
	FROM Employees
	WHERE YEAR(HireDate) > '2000'

-- -> ⦁	Length of Last Name

SELECT FirstName, LastName
	FROM Employees
	WHERE LEN(LastName) = 5

-- -> ⦁	Rank Employees by Salary

SELECT EmployeeID,
		FirstName,
		LastName,
		Salary,
		DENSE_RANK () OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000
	ORDER BY Salary DESC
	
-- -> ⦁	Find All Employees with Rank 2

SELECT *
	FROM 
	(
		SELECT EmployeeID,
			   FirstName,
			   LastName,
			   Salary,
			   DENSE_RANK () OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
			   FROM Employees
			   WHERE Salary BETWEEN 10000 AND 50000
	) Result 
	  WHERE Rank = 2
	  ORDER BY Salary DESC

-- -> Part II – Queries for Geography Database
-- -> ⦁	Countries Holding 'A' 3 or More Times

SELECT CountryName, IsoCode
	FROM Countries
	WHERE (LEN(CountryName) - LEN(REPLACE(CountryName,'a',''))) >= 3
	ORDER BY IsoCode

-- -> Mix of Peak and River Names

select PeakName, RiverName, LOWER(CONCAT(PeakName, SUBSTRING(RiverName, 2, (LEN(RiverName)-1)))) AS Mix
	FROM Peaks as P
	JOIN  Rivers AS r
	ON RIGHT(p.PeakName,1) =  LEFT(r.RiverName,1)
	ORDER BY Mix ASC


-- -> Part III – Queries for Diablo Database
-- -> ⦁	Games from 2011 and 2012 Year

SELECT TOP(50)
	[Name], FORMAT([STart], 'yyyy-MM-dd') AS [Start]
	FROM Games
	WHERE DATEPART(YEAR,[Start]) BETWEEN 2011 AND 2012
	ORDER BY [Start],
	[Name] ASC

-- ->⦁	 User Email Providers

SELECT  Username, 
		SUBSTRING(Email, CHARINDEX('@', Email)+1, LEN(Email)) AS [Email Provider]
		FROM Users
		ORDER BY [Email Provider] ASC, 
		Username ASC

-- -> ⦁	 Get Users with IP Address Like Pattern

SELECT Username, IpAddress
	FROM Users
	WHERE IpAddress LIKE '___.1%.%.___'
	ORDER BY Username ASC
	
-- -> Show All Games with Duration and Part of the Day

SELECT 
	[Name] AS [Game],
	CASE
	WHEN DATEPART(HOUR, Start) >= 0 AND DATEPART(HOUR, Start) < 12 THEN 'Morning'
	WHEN DATEPART(HOUR, Start) >= 12 AND DATEPART(HOUR, Start) < 18 THEN 'Afternoon'
	WHEN DATEPART(HOUR, Start) >=  18 AND DATEPART(HOUR, Start)< 24 THEN 'Evening'
	END AS [Part of the Day],
	CASE
	WHEN Duration <= 3 THEN 'Extra Short'
	WHEN Duration IN (4,5,6) THEN 'Short'
	WHEN Duration > 6 THEN 'Long'
	WHEN Duration IS NULL THEN 'Extra Long'
	END AS [Duration]
	FROM Games
	ORDER BY [Name], [Duration]


-- -> Part IV – Date Functions Queries
-- -> Orders Table


Select 
	ProductName,	
	OrderDate,
	DATEADD(DAY, 3, OrderDate) AS [Pay Due],
	DATEADD(MONTH, 1, OrderDate) AS [Deliver Due]
FROM Orders


-- -> ⦁	 People Table

CREATE TABLE People
(
	 [Id] INT PRIMARY KEY IDENTITY,
	 [Name] NVARCHAR(30) NOT NULL,
	 [Birthdate] DATETIME,
)

INSERT INTO People ([Name], Birthdate) VALUES
('Victor', '2000-12-07 00:00:00.000'),
('Steven','1992-09-10 00:00:00.000'),
('Stephen','1910-09-19 00:00:00.000'),
('John','2010-01-06 00:00:00.000')

SELECT  [Name],
		DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age in Years],
		DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age in Months],
		DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age in Days],
		DATEDIFF(MINUTE, Birthdate, GETDATE()) AS [Age in Minutes]
		FROM People

