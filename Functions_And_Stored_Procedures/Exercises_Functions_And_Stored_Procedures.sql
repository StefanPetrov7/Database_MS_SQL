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



-- 6.	Employees by Salary Level


CREATE PROCEDURE usp_EmployeesBySalaryLevel (@SalaryLevel NVARCHAR(10))
AS
    SELECT [FirstName] , [LastName]
    FROM Employees
    WHERE  dbo.ufn_GetSalaryLevel([Salary]) = @SalaryLevel
GO

EXEC dbo.usp_EmployeesBySalaryLevel Low


-- 7.	Define Function


CREATE FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(20), @word NVARCHAR(20)) 
RETURNS BIT 
BEGIN
DECLARE @Count INT = 1
WHILE (@Count <= LEN(@word))
BEGIN
    DECLARE @CurrentLetter CHAR(1) = SUBSTRING(@word, @Count, 1)
        IF CHARINDEX(@CurrentLetter, @setOfLetters) = 0
        RETURN 0
    SET @Count += 1
END 
RETURN 1
END
GO 

SELECT dbo.ufn_IsWordComprised('oistmiahf', 'halves') 


-- 8.	* Delete Employees and Departments


ALTER TABLE Departments
ALTER COLUMN ManagerID INT NULL
-- step 1
DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE  DepartmentID = 1)
-- step 2
UPDATE Employees
SET ManagerID = NULL 
WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = 1)
-- step 3
UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN  (SELECT EmployeeID FROM Employees WHERE DepartmentID = 1)
-- step 4
UPDATE Departments 
SET ManagerID  = NULL 
WHERE DepartmentID = 1
-- step 5
DELETE 
FROM Employees
WHERE DepartmentId = 1
-- step 6
DELETE 
FROM Departments
WHERE DepartmentID = 1 





CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT) 
AS
-- step 1
ALTER TABLE Departments
ALTER COLUMN ManagerID INT NULL
-- step 2
DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE  DepartmentID = @departmentId)
-- step 3
UPDATE Employees
SET ManagerID = NULL 
WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)
-- step 4
UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN  (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)
-- step 5
UPDATE Departments 
SET ManagerID  = NULL 
WHERE DepartmentID = @departmentId
-- step 6
DELETE 
FROM Employees
WHERE DepartmentId = @departmentId
-- step 7
DELETE 
FROM Departments
WHERE DepartmentID = @departmentId
-- step 8
SELECT COUNT(*)
FROM Employees 
WHERE DepartmentID = @departmentId

GO

-- => should return 0 

EXEC dbo.usp_DeleteEmployeesFromDepartment 2 


-- USING BANK DB

-- 9.	Find Full Name


CREATE PROCEDURE usp_GetHoldersFullName 
AS
    SELECT [FirstName]+ ' ' + [LastName] AS [Full Name]
    FROM AccountHolders
GO

EXEC dbo.usp_GetHoldersFullName


-- 10.	People with Balance Higher Than


CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan (@Balance DECIMAL(18,4))
AS
    SELECT [FirstName], [LastName]
    FROM AccountHolders AS ah
    JOIN Accounts AS a ON a.AccountHolderId = ah.Id
    GROUP BY [FirstName], [LastName]
    HAVING SUM([Balance]) > @Balance
    ORDER BY [FirstName], [LastName]
GO 

EXEC usp_GetHoldersWithBalanceHigherThan 50000


-- 11.	Future Value Function


CREATE FUNCTION ufn_CalculateFutureValue (@Sum DECIMAL(18,4), @Yrate FLOAT, @years INT)
RETURNS DECIMAL(18,4)
BEGIN
    DECLARE @Result DECIMAL(18,4) = @Sum * POWER((1+ @Yrate),@years)
    RETURN @Result
END



SELECT dbo.ufn_CalculateFutureValue (1000, 0.1,  5 )


-- 12.	Calculating Interest


CREATE PROCEDURE usp_CalculateFutureValueForAccount (@AcnID INT, @Yrate FLOAT)
AS
SELECT a.[Id],
       ah.[FirstName],      
       ah.[LastName], 
       a.[Balance] AS [Current Balance], 
        dbo.ufn_CalculateFutureValue([Balance], @Yrate, 5) AS [Balance in 5 years]
FROM AccountHolders AS ah
JOIN Accounts AS a ON a.AccountHolderId = ah.Id
WHERE a.[Id] = @AcnID

GO 

EXEC dbo.usp_CalculateFutureValueForAccount 1, 0.1



SELECT *,
        dbo.ufn_CalculateFutureValue([Balance], 0.1, 5) AS [Balance in 5 years]
FROM AccountHolders AS ah
JOIN Accounts AS a ON a.AccountHolderId = ah.Id
WHERE a.[Id] = 1


-- USING DIABLO DB

-- 13.	*Scalar Function: Cash in User Games Odd Rows


CREATE FUNCTION ufn_CashInUsersGames(@GameName NVARCHAR(20))
RETURNS TABLE
AS
RETURN
(
SELECT SUM(x.SumCash) AS [SumCash]
FROM 
    (
        SELECT [Cash] AS [SumCash],
        ROW_NUMBER() OVER (ORDER BY [Cash] DESC ) AS [Row Number]
        FROM UsersGames AS ug
        JOIN Games AS g ON g.Id = ug.GameId
        WHERE g.[Name] = @GameName
    ) AS x
WHERE [Row Number] % 2 = 1
)


SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist')





