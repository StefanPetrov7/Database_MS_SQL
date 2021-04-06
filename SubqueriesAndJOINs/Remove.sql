-- Test from the Lab

-- Concat with separator and taking only the first left char from the first name.

SELECT [FirstName], [LastName],
CONCAT_WS('.', LEFT([FirstName], 1), LastName) AS [FullName]
FROM Employees

-- Taking length name.

SELECT [FirstName], [LastName],
CONCAT_WS('.', LEFT([FirstName], 1), [LastName]) AS [FullName],
LEN([FirstName]) AS [NameLenght]
FROM Employees

-- Replacing 

SELECT [FirstName], [LastName],
CONCAT_WS('.', LEFT([FirstName], 1), [LastName]) AS [FullName],
LEN([FirstName]) AS [NameLenght],
LEFT([LastName], 2) + '****' AS [Replaced]
FROM Employees

-- Replicate

SELECT [FirstName], [LastName],
CONCAT_WS('.', LEFT([FirstName], 1), [LastName]) AS [FullName],
LEN([FirstName]) AS [NameLenght],
LEFT([FirstName],2) + REPLACE('*', LEN([FirstName])-2, 0) AS [Replaced]
FROM Employees