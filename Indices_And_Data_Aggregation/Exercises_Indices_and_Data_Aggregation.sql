-- Exercises: Indices and Data Aggregation

-- Using DB Gringotts

-- 1. Records’ Count

SELECT COUNT(*) AS [Count]
FROM WizzardDeposits

-- 2. Longest Magic Wand

SELECT TOP(1) [MagicWandSize] AS [LongestMagicWand]
FROM WizzardDeposits
ORDER BY MagicWandSize DESC

--  ==>

SELECT MAX([MagicWandSize]) AS [LongestMagicWand]
FROM WizzardDeposits


-- 3. Longest Magic Wand Per Deposit Groups

SELECT  [DepositGroup],
     MAX([MagicWandSize]) AS [LongestMagicWand]
FROM WizzardDeposits
GROUP BY [DepositGroup]

-- 4. * Smallest Deposit Group Per Magic Wand Size

SELECT [DepositGroup] FROM
(
    SELECT TOP(2) [DepositGroup],
        AVG([MagicWandSize]) AS [LongestMagicWand]
    FROM WizzardDeposits
    GROUP BY [DepositGroup]
    ORDER BY [LongestMagicWand]   
) AS x

--  ==> 

SELECT TOP(2) [DepositGroup]
FROM WizzardDeposits
GROUP BY [DepositGroup]
ORDER BY AVG([MagicWandSize])  

-- 5. Deposits Sum

SELECT [DepositGroup],
    SUM([DepositAmount]) AS [TotalSum]
FROM WizzardDeposits
GROUP BY [DepositGroup]

-- 6. Deposits Sum for Ollivander Family

SELECT [DepositGroup],
    SUM([DepositAmount]) AS [TotalSum]
FROM WizzardDeposits
WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]

-- 7. Deposits Filter

SELECT [DepositGroup],
    SUM([DepositAmount]) AS [TotalSum]
FROM WizzardDeposits
WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]
HAVING SUM([DepositAmount]) < 150000
ORDER BY [TotalSum] DESC

-- 8.  Deposit Charge

SELECT [DepositGroup],
    [MagicWandCreator],
    MIN([DepositCharge])
FROM WizzardDeposits
GROUP BY [DepositGroup], [MagicWandCreator]
ORDER BY [MagicWandCreator]

-- 9. Age Groups

SELECT [AgeGroup],
COUNT(*) AS [WizardCount]
FROM 
(
    SELECT [Age],
    CASE 
    WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]' 
    WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]' 
    WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]' 
    WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]' 
    WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]' 
    WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]' 
    WHEN [Age] > 60 THEN '[61+]' 
    END AS [AgeGroup]
    FROM WizzardDeposits
) AS x
GROUP BY [AgeGroup]

-- 10. First Letter

SELECT [FirstLetter] FROM 
(
    SELECT LEFT([FirstName],1) AS [FirstLetter]
    FROM WizzardDeposits
    WHERE [DepositGroup] = 'Troll Chest'
    GROUP BY [FirstName]
) As x
GROUP BY [FirstLetter]

-- 11. Average Interest 

SELECT [DepositGroup],
    [IsDepositExpired],
    AVG([DepositInterest])
FROM WizzardDeposits
WHERE [DepositStartDate] >= '01/01/1985' 
GROUP BY [DepositGroup], [IsDepositExpired]
ORDER BY [DepositGroup] DESC, [IsDepositExpired]

-- 12. * Rich Wizard, Poor Wizard

SELECT SUM(Guest.[DepositAmount] - Host.[DepositAmount])AS [SumDifference]
FROM WizzardDeposits as Host
JOIN WizzardDeposits as Guest ON  Guest.Id+1 = Host.Id

-- 13. Departments Total Salaries

-- Using DB SoftUni

SELECT [DepartmentID],
SUM(Salary) AS [TotalSalary] 
FROM Employees
GROUP BY [DepartmentID]
ORDER BY [DepartmentID]

-- 14. Employees Minimum Salaries

SELECT [DepartmentID],
    MIN(Salary) AS [MinimumSalary]
FROM Employees
WHERE [DepartmentID] IN(2,5,7) AND [HireDate] > '01/01/2000'
GROUP BY [DepartmentID]

-- 15. Employees Average Salaries

SELECT * INTO EmployeeUpdate 
FROM Employees 
WHERE [Salary] > 30000

DELETE FROM EmployeeUpdate 
WHERE [ManagerID] = 42

UPDATE EmployeeUpdate 
SET [Salary] = [Salary] + 5000
WHERE [DepartmentID] = 1

SELECT [DepartmentID],
AVG([Salary]) AS [AverageSalary]
FROM EmployeeUpdate
GROUP BY [DepartmentID]

DROP TABlE EmployeeUpdate

-- 16. Employees Maximum Salaries

SELECT [DepartmentID],
MAX([Salary]) AS [MaxSalary]
FROM Employees
GROUP BY [DepartmentID]
HAVING MAX([Salary]) NOT BETWEEN 30000 AND 70000

-- 17. Employees Count Salaries

SELECT COUNT(*) AS [Count]
FROM Employees
WHERE [ManagerID] IS NULL

-- 18. *3rd Highest Salary

SELECT 
x.[DepartmentID],
x.[Salary] AS [ThirdHighestSalary]
FROM 
(
    SELECT [DepartmentID],[Salary],
        DENSE_RANK() OVER (PARTITION BY [DepartmentID] ORDER BY MAX([Salary]) DESC) AS [Ranked]
    FROM Employees
    GROUP BY [DepartmentID], [Salary]
) As x
WHERE x.[Ranked] = 3

--19. **Salary Challenge

SELECT TOP(10) [FirstName],
    [LastName],
    [DepartmentID]
FROM Employees AS Emp
WHERE [Salary] > 
                (
                    SELECT    AVG([Salary])
                    FROM Employees
                    WHERE [DepartmentID] = emp.[DepartmentID]
                    GROUP BY [DepartmentID]
                )
ORDER BY [DepartmentID]
                



    














