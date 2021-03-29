-- 2.	Find All Information About Departments

SELECT * 
FROM Departments

-- 3.	Find all Department Names

SELECT Name
FROM Departments

-- 4.	Find Salary of Each Employee

SELECT FirstName, LastName, Salary
FROM Employees

-- 5.	Find Full Name of Each Employee

SELECT FirstName, MiddleName, LastName
FROM Employees

-- 6.	Find Email Address of Each Employee

SELECT FirstName + '.' + LastName + '@softuni.bg' AS FullEmailAddress
FROM Employees

-- 7.	Find All Different Employee’s Salaries

SELECT DISTINCT Salary 
FROM Employees

-- 8.	Find all Information About Employees => job title is “Sales Representative”. 

SELECT *
FROM Employees
WHERE JobTitle = 'Sales Representative'

-- 9.	Find Names of All Employees by Salary in Range => [20000, 30000].

SELECT FirstName, LastName, JobTitle
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

-- 10 Find Names of All Employees => employees whose salary is 25000, 14000, 12500 or 23600. 

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS FullName
FROM Employees
WHERE Salary = 25000 OR Salary = 14000 OR Salary = 12500 OR Salary = 23600

-- 11.	 Find All Employees Without Manager
-- use IS not = as [=NULL will always return false]

SELECT FirstName, LastName
FROM Employees
WHERE ManagerID IS NULL


