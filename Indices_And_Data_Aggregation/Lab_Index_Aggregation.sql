-- Lab Exercise Inexes and Aggregation functions

-- JOIN, WHERE, ORDER BY, GROUP BY, 

-- Once GROUP BY is used the selected columns is limited to the grouping data. 

SELECT DepartmentID, COUNT(*)
FROM Employees
GROUP BY DepartmentID

-- WHERE cannot be used after GROUP BY. 

SELECT DepartmentID, COUNT(*), STRING_AGG(LastName, ' ')
FROM Employees
GROUP BY DepartmentID

-- More aggregation function can be applied to that grouping columns.

SELECT DepartmentID, 
    COUNT(*), STRING_AGG(LastName, ' ') AS [Last Names], 
    SUM(Salary), MIN(Salary) AS [Sum of Salaries], 
    MAX(Salary) AS [Max Salary],
    AVG(Salary) AS [Average Salary]
FROM Employees
GROUP BY DepartmentID

-- Department total Salaries  

SELECT d.Name,
    SUM(e.Salary) AS [Total Salaries],
    COUNT(*) AS [Count]
FROM Employees AS e
LEFT JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
GROUP BY d.Name
ORDER BY [Total Salaries] DESC


-- AGG FUNC => COUNT/SUM/MIN/MAX/AVG => return scalar
 
SELECT [DepartmentID],
    MIN(Salary) AS [Min Salary]
FROM Employees
GROUP BY DepartmentID 

-- AGG FUNC => STRING_AGG

SELECT [FirstName],
    COUNT(*) AS [Same Name Count],
    STRING_AGG([Salary], ' ') AS [Salaries],
    MIN([Salary]) AS [Min Salary],
    SUM([Salary]) AS [Total Salaries]
FROM Employees
GROUP BY [FirstName]

