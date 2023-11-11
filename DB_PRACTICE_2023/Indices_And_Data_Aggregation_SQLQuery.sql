-- -> Indices and Data Aggregation

-- -> LAB Exercises

SELECT d.[Name], COUNT(*) AS [TeamCount] ,SUM(Salary) AS [Total Salary]
	FROM Employees AS e
	LEFT JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
	GROUP BY d.[Name]
	HAVING SUM(e.Salary) > 15000

-- ->Part I – Queries for Gringotts Database

-- ->Records' Count

SELECT COUNT(*) AS Records
	FROM WizzardDeposits

-- -> Longest Magic Wand

SELECT TOP(1) MagicWandSize AS [LongestMagicWand]
	FROM WizzardDeposits
	ORDER BY MagicWandSize DESC


-- -> Longest Magic Wand Per Deposit Groups

SELECT DepositGroup, MAX(MagicWandSize) AS [LongestMagicWand]
	FROM WizzardDeposits
	GROUP BY DepositGroup

-- -> Smallest Deposit Group Per Magic Wand Size

SELECT TOP(2) DepositGroup
	FROM WizzardDeposits
	GROUP BY DepositGroup
	ORDER BY AVG(MagicWandSize) ASC

-- -> Deposits Sum

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
	FROM WizzardDeposits
	GROUP BY DepositGroup

-- -> Deposits Sum for Ollivander Family

SELECT DepositGroup, SUM(DepositAmount)
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup

-- -> Deposits Filter

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup
	HAVING SUM(DepositAmount) < 150000
	ORDER BY [TotalSum] DESC

-- ->  Deposit Charge

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge)
	FROM WizzardDeposits
	GROUP BY DepositGroup, MagicWandCreator
	ORDER BY MagicWandCreator, DepositGroup ASC

-- -> Age Groups

SELECT x.[AgeGroup], COUNT(*) AS [WizardCount]
FROM 
(
	SELECT CASE	
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN Age > 60 THEN '[61+]'
		END AS [AgeGroup]
	FROM WizzardDeposits
)AS x
GROUP BY [AgeGroup]

-- -> First Letter => NOT GIVING POINTS :( 

SELECT SUBSTRING(FirstName,1,1) AS FirstLetter
	FROM WizzardDeposits
	WHERE DepositGroup = 'Troll Chest'
	GROUP BY FirstName
	ORDER BY FirstLetter

-- => 100 POINTS?!

SELECT [FirstLetter] FROM 
(
    SELECT LEFT([FirstName],1) AS [FirstLetter]
    FROM WizzardDeposits
    WHERE [DepositGroup] = 'Troll Chest'
    GROUP BY [FirstName]
) As x
GROUP BY [FirstLetter]


-- -> Average Interest 

SELECT DepositGroup, IsDepositExpired ,AVG(DepositInterest) AS [AverageInterest]
	FROM WizzardDeposits
	WHERE DepositStartDate > '01/01/1985'
	GROUP BY DepositGroup, IsDepositExpired
	ORDER BY DepositGroup DESC, IsDepositExpired ASC 

-- -> Rich Wizard, Poor Wizard *

SELECT SUM(x.Difference) AS [SumDifference]
FROM 
(
	SELECT  f.FirstName AS [Host Wizard], f.DepositAmount AS [Host Wizard Deposit], 
			s.FirstName AS [Guest Wizard], s.DepositAmount AS [Guest Wizard Deposit],
			f.DepositAmount- s.DepositAmount AS [Difference]
			FROM WizzardDeposits AS f
	JOIN WizzardDeposits AS s ON f.Id   = s.Id - 1
) AS X


-- -> Part II – Queries for SoftUni Database
-- -> Departments Total Salaries

SELECT DepartmentID, SUM(Salary)
	FROM Employees
	GROUP BY DepartmentID
	ORDER BY DepartmentID

-- ->  Employees Minimum Salaries

SELECT DepartmentID, MIN(Salary)
	FROM Employees
	WHERE DepartmentID IN (2,5,7)
	AND HireDate > '01/01/2000'
	GROUP BY DepartmentID

-- ->  Employees Average Salaries

SELECT * 
	INTO [ExtractedData]
	FROM Employees
	WHERE Salary > 30000

DELETE 
	FROM [ExtractedData]
	WHERE ManagerID = 42

UPDATE [ExtractedData]
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS [AverageSalary]
	FROM [ExtractedData]
	GROUP BY DepartmentID


-- -> ⦁	Employees Maximum Salaries


SELECT x.DepartmentID, x.MaxSalary
FROM 
(
	SELECT DepartmentID, MAX(Salary) AS [MaxSalary]
	FROM Employees
	GROUP BY  DepartmentID
)AS x
	WHERE x.MaxSalary NOT BETWEEN 30000 AND 70000


-- -> ⦁	Employees Count Salaries

SELECT COUNT(Salary) AS [Count]
	FROM Employees
	WHERE ManagerID IS NULL 

-- ->  *3rd Highest Salary

SELECT DepartmentID, Salary AS [ThirdHighestSalary]
FROM 
(
	SELECT DepartmentID, Salary,
	DENSE_RANK () OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Ranked
	FROM Employees
	GROUP BY DepartmentID, Salary
) AS x
	WHERE Ranked = 3

-- ->  **Salary Challenge

SELECT TOP(10)  emp.FirstName, emp.LastName, emp.DepartmentID
	FROM Employees AS emp
	WHERE Salary > 
	(
		SELECT AVG(Salary)
		FROM Employees
		WHERE DepartmentID = emp.DepartmentID
		GROUP BY DepartmentID
	)