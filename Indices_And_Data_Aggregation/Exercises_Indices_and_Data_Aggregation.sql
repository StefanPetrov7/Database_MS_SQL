-- Exercises: Indices and Data Aggregation

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