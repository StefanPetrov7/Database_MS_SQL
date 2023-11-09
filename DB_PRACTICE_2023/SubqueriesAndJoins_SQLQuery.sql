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