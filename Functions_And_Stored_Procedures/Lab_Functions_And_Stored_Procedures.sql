-- FUNCTIONS AND STORED PROCEDURES LAB

-- T-SQL

DECLARE @Year SMALLINT = 2020;  -- => cell of memory with name, variable
SELECT @Year

SET @Year = @Year + 1;  -- => change value
SELECT @Year

-- Creating Variable of type Table 

DECLARE @MyTempTable TABLE(Id INT PRIMARY KEY IDENTITY, Name NVARCHAR(MAX))
INSERT INTO @MyTempTable (Name) VALUES ('Stefan')
SELECT * 
FROM @MyTempTable

-- Conditional statement

IF YEAR(GETDATE()) = 2021 
    SET @Year = 2021
ELSE IF YEAR(GETDATE()) = 2020 
    SET @Year = 2022
ELSE 
    SET @Year = 2022

SELECT @Year

--  BEGIN and END should be used => { }

IF YEAR(GETDATE()) = 2021 
    BEGIN
    SET @Year = 2021
    INSERT INTO @MyTempTable (Name) VALUES ('Stefan')
    END
ELSE IF YEAR(GETDATE()) = 2020 
    BEGIN
    SET @Year = 2022
    END
ELSE 
    SET @Year = 2022



-- CASE use


SELECT 
CASE @Year
    WHEN 2020 THEN 2020
    WHEN 2021 THEN 2021
    ELSE 'Unknown Year'
END

-- Loops

GO

DECLARE @Year SMALLINT = 1990;
SELECT @Year, COUNT(*)
FROM Employees
WHERE YEAR(HireDate) > @Year

GO

DECLARE @Year SMALLINT = 1990;
WHILE (@Year <= 2008)
BEGIN
    SELECT @Year, COUNT(*)
    FROM Employees
    WHERE YEAR(HireDate) > @Year
    SET @Year = @Year +1
    IF @Year = 2006
    BREAK
END

-- Functions And Stored Procedures 

-- SECOND POWER FUNC

GO

DECLARE @BASENUM INT = 2
DECLARE @EXP INT = 45

-- CREATE FUNCTION udf_BigIntPower(@BASE INT,@EXP INT)
-- RETURNS DECIMAL(38)
-- AS
-- BEGIN
--     DECLARE @RESULT DECIMAL(38) = 1
--     WHILE (@EXP>0)
--     BEGIN
--         SET @RESULT = @RESULT*@BASE 
--         SET @EXP-=1
--     END
--     RETURN @RESULT
-- END

-- SELECT dbo.udf_BigIntPower(2,40)

-- Create Function that return Table 

-- CREATE FUNCTION udf_ReturnEmployeesByYear(@Year INT)
-- RETURNS TABLE
-- AS 
-- RETURN 
-- (
--     SELECT * FROM Employees
--     WHERE YEAR(HireDate) = @Year
-- )



-- Lab =>	Salary Level Function


CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@Salary MONEY)
RETURNS VARCHAR(10)
AS
BEGIN
    IF @Salary IS NULL RETURN NULL
    ELSE IF @Salary < 30000 RETURN 'Low'
    ELSE IF @Salary >= 30000 AND @Salary <= 50000 RETURN 'Average'
    ELSE IF  @Salary > 50000 RETURN 'High'
    RETURN NULL
END

GO 

SELECT [FirstName], [LastName], [Salary], dbo.ufn_GetSalaryLevel(Salary) AS [Slary Level]
FROM Employees

-- Create Stored Procedure

CREATE OR ALTER PROCEDURE usp_RecreateProjects
AS
   INSERT INTO Projects([Name], [Description], [StartDate],[EndDate]) 
   SELECT '[New]' +  [Name], [Description], [StartDate],[EndDate] FROM Projects
GO  

--

CREATE OR ALTER PROCEDURE usp_CreateNamesWithSalaries(@Count INT)
AS
   INSERT INTO NamesWithSalaries(FullName, Salary) 
   SELECT TOP(@Count) FullName, Salary FROM NamesWithSalaries
GO  

-- 

CREATE OR ALTER PROCEDURE usp_AddEmployeeToProjects(@EmployeeId INT, @ProjectId INT)
AS
    DECLARE @CountEmployeeProject INT = 
        (SELECT COUNT(*) EmployeesProjects
            WHERE EmployeeId = @EmployeeId
                AND ProjectId = @ProjectId)

    IF @CountEmployeeProject > 0
        THROW 50001, 'This Employee already in the project', 1

    INSERT INTO EmployeesProjects(EmployeeId, ProjectId)
        VALUES(@EmployeeId, @ProjectId)

GO

--

CREATE OR ALTER PROCEDURE usp_AddProject(@EmployeeId INT, @ProjectId INT)
AS
    DECLARE @EmployeeProjects INT = 
        (SELECT COUNT(*) FROM EmployeesProjects
            WHERE EmployeeId = @EmployeeId)

    IF (@EmployeeProjects >= 3)
        THROW 50001, 'Employee has more than 3 projects', 1

      DECLARE @EmployeeInThisProjectCount INT = 
        (SELECT COUNT(*) FROM EmployeesProjects
            WHERE EmployeeId = @EmployeeId
            AND ProjectId= @ProjectId)
    
    IF (@EmployeeInThisProjectCount>=1)
        THROW 50002, 'Employee already in this project', 1

    INSERT INTO EmployeesProjects (EmployeeId,ProjectId)
        VALUES(@EmployeeId,@ProjectId)

GO


-- Try Catch Syntaxis

BEGIN TRY 
    SELECT 1/0
END TRY
BEGIN CATCH
    SELECT @@ERROR, ERROR_NUMBER(), ERROR_LINE(), ERROR_PROCEDURE(),ERROR_MESSAGE(), ERROR_STATE(),ERROR_SEVERITY()
END CATCH


