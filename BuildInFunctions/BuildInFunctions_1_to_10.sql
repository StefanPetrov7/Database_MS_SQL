-- Problem 1.	Find Names of All Employees by First Name


SELECT [FirstName], [LastName]
FROM Employees
WHERE [FirstName]  LIKE 'SA%'


-- Problem 2.	  Find Names of All employees by Last Name 


SELECT [FirstName], [LastName]
FROM Employees
WHERE [LastName] LIKE '%ei%'


-- Problem 3.	Find First Names of All Employees


SELECT [FirstName]
FROM Employees
WHERE [DepartmentID] IN (3,10)
AND Year([HireDate]) >= 1995 AND Year([HireDate]) <= 2005


-- Problem 4.	Find All Employees Except Engineers


SELECT [FirstName], [LastName]
FROM Employees
WHERE [JobTitle]  NOT LIKE '%engineer%'


-- Problem 5.	Find Towns with Name Length


SELECT [Name]
FROM Towns
WHERE LEN([Name]) = 5 
    OR LEN([Name]) = 6
ORDER BY [Name]


-- Problem 6.	 Find Towns Starting With


SELECT * 
FROM Towns
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]


-- Problem 7.	 Find Towns Not Starting With


SELECT * 
FROM Towns
WHERE [Name]  LIKE '[^RBD]%'
ORDER BY [Name]


-- Problem 8.	Create View Employees Hired After 2000 Year


CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT [FirstName], [LastName]
FROM Employees
WHERE DATEPART(YEAR, [HireDate]) > 2000


-- Problem 9.	Length of Last Name


SELECT [FirstName], [LastName]
FROM Employees
WHERE LEN([LastName]) = 5


-- 10. Rank Employees by Salary 


SELECT [EmployeeID], [FirstName], [LastName], [Salary], 
    DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [Rank]
FROM Employees
    WHERE [Salary] BETWEEN 10000 AND 50000
    ORDER BY [Salary] DESC


-- Problem 11.	Find All Employees with Rank 2 *
-- Another option is to create view and select VIEW to be equal 2 !!!!
-- Sub Query


SELECT * FROM
(
    SELECT [EmployeeID], [FirstName], [LastName], [Salary], 
    DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY [EmployeeID])  AS [Rank]
    FROM Employees
    WHERE [Salary] BETWEEN 10000 AND 50000 
)
AS Result
    WHERE [Rank] = 2
    ORDER BY [Salary] DESC

-- Using Geography DB
-- Problem 12.	Countries Holding ‘A’ 3 or More Times
-- Sub Query, selectring from result. 


SELECT [CountryName], [IsoCode] 
FROM
(
    SELECT [CountryName], [IsoCode],LEN([CountryName]) - LEN(REPLACE([CountryName], 'A','')) AS [Count]
    FROM Countries  
)
AS Result
WHERE [Count] >= 3
ORDER BY [IsoCode]


-- Problem 13.	 Mix of Peak and River Names


SELECT [PeakName], [RiverName], 
LOWER(LEFT([PeakName],LEN([PeakName])-1) + [RiverName]) AS Mix
FROM Peaks, Rivers
WHERE RIGHT([PeakName],1) = LEFT([RiverName],1)
ORDER BY [Mix]


-- Problem 14.	Games from 2011 and 2012 year


SELECT TOP(50)  [Name], FORMAT([Start],'yyyy-MM-dd') AS [Start]
FROM Games
WHERE DATEPART(YEAR, [Start]) BETWEEN 2011 AND 2012
ORDER BY [Start], [Name] 


-- 15. User Email Providers 


SELECT * FROM 
(
    SELECT [UserName], SUBSTRING([Email],CHARINDEX('@', [Email])+1, LEN([Email])) AS [Email]
    FROM Users
)
AS Result
ORDER BY [Email], [Username]


SELECT [UserName], SUBSTRING([Email], CHARINDEX('@',[Email])+1, LEN([Email])) AS [EmailProvider]
FROM Users
ORDER BY [EmailProvider], [Username]


-- Problem 16.	 Get Users with IPAdress Like Pattern "***.1^.^.***". 


SELECT [Username], [IpAddress]
FROM Users
WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [Username]


-- Problem 17.	 Show All Games with Duration and Part of the Day


SELECT  [Name], 
CASE
WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN DATEPART(HOUR, [Start]) BETWEEN 18 AND 23 THEN 'Evening'
END
AS [Part of the Day],  
CASE
WHEN [Duration] <= 3 THEN 'Extra Short'
WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
WHEN [Duration] > 6 THEN 'Long'
WHEN [Duration] IS NULL THEN 'Extra Long'
-- ELSE 'Extra Long'
END
AS [Duration]
FROM Games
ORDER BY [Name], [Duration]


-- Problem 18.	 Orders Table


SELECT [ProductName], 
[OrderDate],
DATEADD(DAY, 3, [OrderDate]) AS [Pay Due],
DATEADD(MONTH, 3, [OrderDate]) AS [Delivery Due],
FROM Orders