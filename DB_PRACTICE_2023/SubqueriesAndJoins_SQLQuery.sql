-- -> Exercises: Subqueries and Joins
-- -> Part I – Queries for SoftUni Database


-- -> Employee Address

SELECT TOP(5)
	e.EmployeeID, e.JobTitle, a.AddressID, a.AddressText
	FROM Employees AS e
	LEFT JOIN Addresses AS a
	ON e.AddressID = a.AddressID
	ORDER BY a.AddressID ASC

-- -> Addresses with Towns

SELECT TOP(50)
	e.FirstName, e.LastName, t.[Name], a.AddressText
	FROM Employees AS e
	LEFT JOIN Addresses AS a
	ON e.AddressID = a.AddressID
	LEFT JOIN Towns AS t
	ON a.TownID = t.TownID
	ORDER BY e.FirstName ASC, 
	e.LastName ASC

-- -> Sales Employee

SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name] AS [DepartmentName]
	FROM Employees AS e
	LEFT JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE d.[Name] = 'Sales'
	ORDER BY e.EmployeeID ASC

-- -> Employee Departments

SELECT TOP(5)
	e.EmployeeID, 
	e.FirstName,
	e.Salary,
	d.[Name] AS [DepartmentName]
	FROM Employees AS e
	LEFT JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE e.Salary > 15000
	ORDER BY d.DepartmentID ASC

-- -> Employees Without Project

SELECT TOP(3)
	e.EmployeeID,
	e.FirstName
	FROM Employees AS e
	LEFT JOIN EmployeesProjects as ep
	ON e.EmployeeID = ep.EmployeeID
	LEFT JOIN Projects as p
	ON ep.ProjectID = p.ProjectID
	WHERE p.ProjectID IS NULL
	ORDER BY e.EmployeeID ASC

-- -> Employees Hired After

SELECT e.FirstName,
	   e.LastName,
	   e.HireDate,
	   d.[Name] AS [DeptName]
	FROM Employees AS e
	LEFT JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE d.[Name] IN ('Sales' , 'Finance') AND
	e.HireDate > '1999-01-01'
	ORDER BY e.HireDate ASC

-- -> Employees with Project

SELECT TOP(5) 
	e.EmployeeID,
	e.FirstName,
	p.[Name] AS [ProjectName]
	FROM Employees AS e
	LEFT JOIN EmployeesProjects as ep ON e.EmployeeID = ep.EmployeeID
	LEFT JOIN Projects as p ON ep.ProjectID = p.ProjectID
	WHERE p.StartDate > '2002-08-13'
	AND p.EndDate IS NULL
	ORDER BY e.EmployeeID ASC

-- -> Employee 24

SELECT e.EmployeeID,
		e.FirstName,
		CASE 
		WHEN DATEPART(YEAR, p.StartDate) > 2003 THEN NULL
		ELSE p.[Name]
		END
	 AS [ProjectName]
	FROM Employees AS e
	LEFT JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
	LEFT JOIN Projects AS p ON ep.ProjectID = p.ProjectID
	WHERE e.EmployeeID = 24

-- -> Employee Manager

SELECT  emp.EmployeeID, 
		emp.FirstName,
		emp.ManagerID,
		mgr.FirstName
	FROM Employees AS emp
	LEFT JOIN Employees AS mgr ON emp.ManagerID = mgr.EmployeeID
	WHERE emp.ManagerID IN(3,7)
	ORDER BY emp.EmployeeID ASC

-- -> Employees Summary

SELECT TOP(50)
	   emp.EmployeeID,
	   emp.FirstName + ' ' + emp.LastName AS [EmployeeName],
	   mgr.FirstName + ' ' + mgr.LastName AS [ManagerName],
	   dep.[Name]
	FROM Employees AS emp
	LEFT JOIN Employees AS mgr ON emp.ManagerID = mgr.EmployeeID
	LEFT JOIN Departments as dep ON emp.DepartmentID = dep.DepartmentID
	ORDER BY emp.EmployeeID

-- -> Min Average Salary

SELECT TOP(1)
		AVG(Salary) AS [MinAverageSalary]
		FROM Employees
		GROUP BY DepartmentID
		ORDER BY [MinAverageSalary] ASC

-- -> Part II – Queries for Geography Database
-- -> Highest Peaks in Bulgaria


SELECT mc.CountryCode,
	   m.MountainRange,
	   p.PeakName,
	   p.Elevation
	FROM Peaks AS p
	LEFT JOIN Mountains as m ON p.MountainId = m.Id
	LEFT JOIN MountainsCountries AS mc ON m.ID = mc.MountainId 
	WHERE mc.CountryCode = 'BG'
	AND p.Elevation > 2835
	ORDER BY p.Elevation DESC

-- -> Count Mountain Ranges

SELECT mc.CountryCode,
	COUNT(m.MountainRange) AS [MountainRanges]
	FROM MountainsCountries AS mc
	LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
	WHERE mc.CountryCode IN('BG','RU','US')
	GROUP BY mc.CountryCode
	
-- -> Countries With or Without Rivers

SELECT  TOP(5)
		c.CountryName,
		r.RiverName
	FROM Countries AS c
	LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
	LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
	WHERE c.ContinentCode = 'AF'
	ORDER BY c.CountryName ASC

-- -> *Continents and Currencies!!!!

SELECT ContinentCode, CurrencyCode, CurrencyUsage FROM
(
		SELECT ContinentCode, CurrencyCode, COUNT(CurrencyCode) AS CurrencyUsage,
		DENSE_RANK () OVER (PARTITION BY ContinentCode ORDER BY COUNT(CurrencyCode) DESC) AS Ranked
		FROM Countries
		GROUP BY ContinentCode, CurrencyCode
) AS k
		WHERE Ranked = 1 AND CurrencyUsage > 1
		ORDER BY ContinentCode

-- -> Countries Without Any Mountains

SELECT COUNT(c.CountryName)
	FROM Countries AS c
	LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	WHERE mc.CountryCode IS NULL

-- -> Highest Peak and Longest River by Country

SELECT TOP(5)
		c.CountryName, MAX(p.Elevation) AS [HighestPeakElevation],  MAX(r.[Length]) AS [LongestRiverLength]
		FROM Countries AS c
		LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
		LEFT JOIN Peaks AS p ON p.MountainId = m.Id
		LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
		LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
	    GROUP BY c.CountryName
		ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, c.CountryName

-- -> Highest Peak Name and Elevation by Country
-- -> ZERO POINTS?! Query work fine

SELECT TOP(5) x.CountryName AS [Country],
		   	  x.PeakName AS [Highest Peak Name], 
			  x.HighestPeak AS [Highest Peak Elevation], 
			  x.MountainRange AS [Mountain]
	FROM 
(
		SELECT c.CountryName, 
		ISNULL(p.PeakName, '(no highest peak)') AS PeakName,
		ISNULL(MAX(p.Elevation), 0) AS HighestPeak,
		ISNULL(m.MountainRange, 'no mountain') AS MountainRange,
		DENSE_RANK () OVER (PARTITION BY c.CountryName ORDER BY p.Elevation DESC ) AS Ranked
		FROM Countries AS c
		LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
		LEFT JOIN Peaks AS p ON m.Id = p.MountainId
		GROUP BY c.CountryName, p.PeakName, p.Elevation, m.MountainRange
) AS x
		WHERE Ranked = 1
		ORDER BY x.CountryName, x.PeakName


	
		
 


