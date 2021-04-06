-- JOINS
-- INNER JOIN

-- Joining from Employees with FK AddressID = PK AddressID from Addresses 

SELECT * 
FROM Employees
JOIN Addresses ON Addresses.AddressID = Employees.AddressID

-- Second Join
-- PK From Towns joined with FK from Addresses

SELECT * 
FROM Employees
JOIN Addresses ON Addresses.AddressID = Employees.AddressID   -- => Relation FK with PK 
JOIN Towns ON Towns.TownID = Addresses.TownID

-- WHERE, ORDER BY can be used same as witout JOIN

SELECT * 
FROM Employees
JOIN Addresses ON Addresses.AddressID = Employees.AddressID
JOIN Towns ON Towns.TownID = Addresses.TownID
WHERE Towns.Name = 'Sofia'
ORDER BY Employees.EmployeeID DESC

-- Naming the tables with one letter when using a JOIN for better query description
-- That is needed because in the joined tables we can see columns with the same names.

SELECT  e.FirstName, e.JobTitle, a.AddressText, t.Name
FROM Employees e
JOIN Addresses  a ON a.AddressID = e.AddressID
JOIN Towns t ON t.TownID = a.TownID
WHERE t.Name = 'Sofia'
ORDER BY e.EmployeeID DESC

-- LEFT OUTER JOIN
-- If something is not matching with the relation, the LEFT table will keep it's ROW-VALUES concatenated with NULLS from the RIGHT table.

SELECT  e.FirstName, e.LastName, a.AddressText
FROM Employees e
LEFT JOIN Addresses  a ON a.AddressID = e.AddressID

-- RIGHT JOIN 

SELECT   * 
FROM Employees e
RIGHT JOIN Addresses  a ON a.AddressID = e.AddressID

-- FULL JOIN combines => INNER, LEFT and RIGHT joins

SELECT   * 
FROM Employees e
FULL JOIN Addresses  a ON a.AddressID = e.AddressID

--  Cartesian product => everything connected with everything 
-- CROSS JOIN

SELECT   * 
FROM Employees, Addresses   

SELECT   * 
FROM Employees
CROSS JOIN Departments

-- Practice Lab
-- 3 way join
-- With this inner join all the employees without addresses will be lost, we can apply LEFT join to keep them as VALUES. 

SELECT  e.FirstName, e.LastName, t.Name AS Town, a.AddressText
FROM Employees e
JOIN Addresses a ON e.AddressID = a.AddressID
JOIN Towns t ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName 

-- => LEFT JOIN 
-- If one of the joins is selected as LEFT, this should be applied for the rest of the until the end of the query, or the rows can be lost again.

SELECT  TOP(50)
    e.FirstName AS [First Name], 
    e.LastName AS [Last Name],
    t.Name AS [Town], 
    a.AddressText
FROM Employees e
LEFT JOIN Addresses a ON e.AddressID = a.AddressID
LEFT JOIN Towns t ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName 


-- Practice Lab

SELECT e.EmployeeID,
        e.FirstName,
        e.LastName,
        d.Name AS [Dept Name],
        FORMAT(e.HireDate, 'yyyy') AS [Hire Date]
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate  > 1991-01-01 AND
    -- d.Name IN('Sales', 'Finance')  -- => same 
    (d.Name = 'Sales' OR d.Name = 'Finance')
ORDER BY e.HireDate

-- Practice Lab
-- Self Reference

SELECT *
FROM Employees e
JOIN Employees m ON e.ManagerID = m.EmployeeID


SELECT e.FirstName, e.LastName, e.JobTitle, e.ManagerID, m.EmployeeID, m.FirstName, m.LastName
FROM Employees e
JOIN Employees m ON e.ManagerID = m.EmployeeID


SELECT *
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID
LEFT JOIN Employees m2 ON m.ManagerID = m2.EmployeeID
LEFT JOIN Employees m3 ON m2.ManagerID = m3.EmployeeID
LEFT JOIN Employees m4 ON m3.ManagerID = m4.EmployeeID


SELECT e.EmployeeID, 
    CONCAT_WS(' ',e.FirstName, e.LastName) AS [Employee Name], 
    CONCAT_WS(' ',m.FirstName, m.LastName) AS [Manager Name],
    d.Name AS [Department Name]
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

-- Subqueries

SELECT e.EmployeeID,
        e.FirstName,
        e.LastName,
        d.Name AS [Dept Name],
        FORMAT(e.HireDate, 'yyyy') AS [Hire Date]
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate  > 1991-01-01 AND
      d.Name IN(SELECT Name FROM Departments WHERE Name LIKE 'S%')  -- => sub query
ORDER BY e.HireDate


SELECT DepartmentID,
Name AS [Dept Name],
(SELECT AVG(Salary) FROM Employees WHERE DepartmentID = d.DepartmentID) AS [Average Salary]
FROM Departments d
ORDER BY [Average Salary]

-- GROUP BY 

SELECT AVG(Salary) AS [Average] 
FROM Employees 
GROUP BY DepartmentID 
ORDER BY [Average]

