-- Exercises: Functions and Stored Procedures

-- 1.	Queries for SoftUni Database

-- 1.	Employees with Salary Above 35000


CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
    SELECT [FirstName], [LastName] FROM 
    Employees
    WHERE [Salary] > 35000
GO

EXEC dbo.usp_GetEmployeesSalaryAbove35000


-- 2.	Employees with Salary Above Number


CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@Salary DECIMAL(18,4))
AS
    SELECT [FirstName], [LastName] FROM 
    Employees
    WHERE [Salary] >= @Salary
GO 

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 100000


--3.	Town Names Starting With


CREATE PROCEDURE usp_GetTownsStartingWith(@Letter VARCHAR(20)) 
AS
    SELECT [Name] AS [Town] 
    FROM Towns
    WHERE LEFT([Name], LEN(@Letter)) = @Letter


GO


-- Differenet Approach


CREATE PROCEDURE usp_GetTownsStartingWith(@Letter VARCHAR(20)) 
AS
    SELECT [Name] AS [Town] 
    FROM Towns
    WHERE [Name] LIKE @Letter + '%'
GO

EXEC usp_GetTownsStartingWith B


-- 4.	Employees from Town


CREATE PROCEDURE usp_GetEmployeesFromTown (@TownName NVARCHAR(20))
AS
    SELECT [FirstName], [LastName]
    FROM Employees AS e
    JOIN Addresses AS a ON a.AddressID = e.AddressID
    JOIN Towns AS t ON t.TownID = a.TownID
    WHERE t.[Name] = @TownName
GO


EXEC usp_GetEmployeesFromTown Sofia


-- 5.	Salary Level Function


CREATE FUNCTION ufn_GetSalaryLevel(@Salary DECIMAL(18,4))
RETURNS NVARCHAR(10)
AS
BEGIN
    IF  @Salary < 30000 RETURN 'Low'
    ELSE IF  @Salary >= 30000 AND @Salary <= 50000 RETURN 'Average'
    ELSE IF @Salary > 50000 RETURN 'High'
    ELSE RETURN NULL
    RETURN NULL
END


SELECT [FirstName], [LastName], [Salary], dbo.ufn_GetSalaryLevel([Salary]) AS [Slary Level]
FROM Employees
