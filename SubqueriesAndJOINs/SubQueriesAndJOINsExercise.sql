-- Exercises: Subqueries and Joins
-- USING SoftUni DB for the exercises

-- 1.	Employee Address

SELECT TOP(5)
    e.EmployeeID,
    e.JobTitle,
    e.AddressID,
    a.AddressText
FROM Employees AS e
LEFT JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY a.AddressID 

-- 2.	Addresses with Towns

SELECT TOP(50)
    e.FirstName,
    e.LastName,
    t.Name AS [Town],
    a.AddressText
FROM Employees AS e
LEFT JOIN Addresses AS a ON e.AddressID = a.AddressID
LEFT JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName


-- 3.	Sales Employee

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.Name AS [DepartmentName]
FROM Employees AS e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY e.EmployeeID

-- 4.	Employee Departments

SELECT TOP(5)
    e.EmployeeID,
    e.FirstName,
    e.Salary,
    d.Name AS [DepartmentName]
FROM Employees AS e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY e.DepartmentID

-- 5.	Employees Without Project

SELECT TOP(3)
    e.EmployeeID,
    e.FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
WHERE ep.EmployeeID IS NULL
ORDER BY e.EmployeeID

-- 6.	Employees Hired After

SELECT 
    em.FirstName,
    em.LastName,
    em.HireDate,
    dep.Name AS [DeptName]
FROM Employees AS em
JOIN Departments AS dep ON em.DepartmentID = dep.DepartmentID
WHERE em.HireDate > '1999-01-01'
AND dep.Name IN('Sales', 'Finance')
ORDER BY em.HireDate

-- 7.	Employees with Project

SELECT TOP(5)
    e.EmployeeID,
    e.FirstName,
    p.Name AS [ProjectName]
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE p.StartDate > 13/08/2002 AND p.EndDate IS NULL
ORDER BY e.EmployeeID

-- 8.	Employee 24

SELECT 
    e.EmployeeID,
    e.FirstName,
    CASE
    WHEN  DATEPART(YEAR, P.StartDate) >=2005 THEN NULL
    ELSE P.Name
    END AS [ProjectName]
FROM Employees AS e
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects as p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24 

-- 9.	Employee Manager

SElECT 
    e.EmployeeID,
    e.FirstName,
    m.EmployeeID,
    m.FirstName
FROm Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN(3,7)
ORDER BY e.EmployeeID

-- 10. Employee Summary

SElECT TOP(50)
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS [EmployeeName],
    m.FirstName + ' ' + m.LastName AS [ManagerName],
    d.Name AS [DepartmentName]
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

-- 11. Min Average Salary

SELECT TOP(1) AVG(e.Salary) AS [MinAverageSalary]
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name
ORDER BY [MinAverageSalary] 

--  USING Geography DB for the exercises
-- 12. Highest Peaks in Bulgaria

SELECT 
    mc.CountryCode,
    m.MountainRange,
    p.PeakName,
    p.Elevation
FROM MountainsCountries AS mc
JOIN Mountains m ON mc.MountainId = m.Id
RIGHT JOIN Peaks AS p ON mc.MountainId = p.MountainId
WHERE mc.CountryCode ='BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

-- 13. Count Mountain Ranges

SELECT 
mc.CountryCode, 
COUNT(*) AS [MountainRanges]
FROM MountainsCountries AS mc
JOIN Mountains AS m ON mc.MountainId = m.Id
WHERE mc.CountryCode IN('US','RU','BG')
GROUP BY mc.CountryCode

-- 10. Countries with Rivers

SELECT TOP(5)
c.CountryName,
r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
WHERE c.ContinentCode = 'AF' 
ORDER BY c.CountryName

-- 15. *Continents and Currencies


SELECT ContinentCode, CurrencyCode, Result.[CurrencyUsage]
FROM
(
    SELECT 
    ContinentCode,
    CurrencyCode,
    COUNT(CurrencyCode) AS [CurrencyUsage],
    DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY COUNT(CurrencyCode) DESC) AS [Ranked]
    FROM Countries 
    GROUP BY ContinentCode, CurrencyCode  -- Grouped by the projected[ContinentCode, CurrencyCode] 
) AS Result
WHERE [Ranked] = 1 AND [CurrencyUsage] > 1
ORDER BY ContinentCode

-- 16 Countries Without Any Mountains

SELECT 
COUNT(CountryName) AS [Count]
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId =  m.Id
WHERE m.Id IS NULL

-- 17. Highest Peak and Longest River by Country

SELECT TOP(5)
c.CountryName,
MAX(p.Elevation) AS [HighestPeakElevation],
MAX(r.Length) AS [LongestRiverLength]
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p ON p.MountainId = m.Id
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
GROUP BY c.CountryName
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, c.CountryName

-- 18. Highest Peak Name and Elevation by Country


SELECT 
[CountryName], [HighestPeak], [Highest Peak Elevation], [Mountain]
FROM
(
SELECT 
c.CountryName,
CASE 
WHEN p.PeakName IS NULL THEN '(no highest peak)'
ELSE p.PeakName
END AS [HighestPeak],
CASE 
WHEN p.Elevation IS NULL THEN '0'
ELSE p.Elevation
END AS [Highest Peak Elevation],
CASE
WHEN m.MountainRange IS NULL THEN '(no mountain)'
ELSE m.MountainRange
END AS [Mountain],
DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS [Ranked]
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p ON p.MountainId = m.Id
GROUP BY c.CountryName, p.PeakName, m.MountainRange, p.Elevation
) AS Result 
WHERE [Ranked] = 1
ORDER BY [CountryName], [Highest Peak Elevation]

-- Different approach

SELECT TOP(5) k.[CountryName],k.[Highest Peak Name], k.[Highest Peak Elevation], k.[Mountain]
FROM 
(
    SELECT TOP(5)
    c.CountryName,
    ISNULL(p.PeakName, '(no highest peak)') AS [Highest Peak Name],
    ISNULL(m.MountainRange,'(no mountain)') AS [Mountain],
    ISNULL(MAX(p.Elevation), '0') AS [Highest Peak Elevation],
    DENSE_RANK() OVER (PARTITION BY CountryName ORDER BY MAX(p.Elevation) DESC) AS [Ranked]
    FROM Countries AS c
    LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
    LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
    LEFT JOIN Peaks AS p ON p.MountainId = m.Id
    GROUP BY c.CountryName, p.PeakName, m.MountainRange
) AS k
WHERE [Ranked] = 1
ORDER BY [CountryName], [Highest Peak Elevation]



