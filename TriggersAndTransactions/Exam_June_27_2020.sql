-- Database Basics MS SQL Exam – 27 June 2020

-- Section 1. DDL 

-- 1.	Database design

CREATE DATABASE WMS

-- DROP TABLE Clients

CREATE TABLE Clients  
(
    [ClientId] INT PRIMARY KEY IDENTITY,
    [FirstName] VARCHAR(50) NOT NULL,
    [LastName] VARCHAR(50) NOT NULL,
    [Phone] CHAR(12) CHECK(LEN(Phone) = 12) NOT NULL
)

-- ALTER TABLE Clients   
-- ADD CONSTRAINT ck_CheckPhoneNumberLength CHECK (DATALENGTH([Phone]) = 12 )

-- DROP TABLE Mechanics

CREATE TABLE Mechanics  
(
    [MechanicId] INT PRIMARY KEY IDENTITY,
    [FirstName] VARCHAR(50) NOT NULL,
    [LastName] VARCHAR(50)NOT NULL,
    [Address] VARCHAR(255) NOT NULL   
)

-- DROP TABLE Models

CREATE TABLE Models  
(
    [ModelId] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) UNIQUE NOT NULL
)

-- DROP TABLE Jobs

CREATE TABLE Jobs   
(
    [JobId] INT PRIMARY KEY IDENTITY,
    [ModelId] INT FOREIGN KEY REFERENCES Models(ModelId) NOT NULL,
    [Status] VARCHAR(11)  DEFAULT 'Pending' CHECK([Status] IN ('Pending','In Progress','Finished')) NOT NULL,
    [ClientId] INT FOREIGN KEY REFERENCES Clients([ClientId]) NOT NULL,      
    [MechanicId] INT FOREIGN KEY REFERENCES Mechanics([MechanicId]),
    [IssueDate] DATE NOT NULL,
    [FinishDate] DATE
)

-- ALTER TABLE Jobs    -- => Add Constraint for Jobs Table [Status] Column 
-- ADD CONSTRAINT ck_CheckValuesForStatus CHECK([Status] IN ('Pending','In Progress','Finished'))

-- DROP TABLE Orders

CREATE TABLE Orders  
(
    [OrderId] INT PRIMARY KEY IDENTITY,
    [JobId] INT FOREIGN KEY REFERENCES Jobs([JobId]) NOT NULL,
    [IssueDate] DATE,
    [Delivered] BIT  DEFAULT 0 
)

-- DROP TABLE Vendors

CREATE TABLE Vendors 
(
    [VendorId] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) UNIQUE NOT NULL
)

-- DROP TABLE Parts

CREATE TABLE Parts   
(
    [PartId] INT PRIMARY KEY IDENTITY,
    [SerialNumber] VARCHAR(50) UNIQUE NOT NULL,
    [Description] VARCHAR(255),
    [Price] DECIMAL(15,2) CHECK ([Price] > 0) NOT NULL,      
    [VendorId] INT FOREIGN KEY REFERENCES Vendors(VendorId) NOT NULL,
    [StockQty] INT DEFAULT 0 CHECK([StockQty] >= 0)    -- Cannot be negative 
)

-- DROP TABLE OrderParts

CREATE TABLE OrderParts  -- READY 
(
    [OrderId] INT FOREIGN KEY REFERENCES Orders(OrderId) NOT NULL,
    [PartId] INT FOREIGN KEY REFERENCES Parts(PartId) NOT NULL,
    [Quantity] INT  DEFAULT 1 CHECK([Quantity] > 0),
    CONSTRAINT PK_OrdersParts PRIMARY KEY (OrderId, PartId)  -- => Composite key 
)

-- DROP TABLE PartsNeeded

CREATE TABLE PartsNeeded  -- READY 
(
    [JobId] INT FOREIGN KEY REFERENCES Jobs(JobId) NOT NULL,
    [PartId] INT FOREIGN KEY REFERENCES Parts(PartId) NOT NULL,
    [Quantity] INT  DEFAULT 1 CHECK([Quantity] > 0),
    CONSTRAINT PK_JobsParts PRIMARY KEY(JobId, PartId)  -- => Composite key 
)


-- Section 2. DML

-- 2.	Insert

INSERT INTO Clients VALUES 
('Teri',	'Ennaco',	'570-889-5187'),
('Merlyn',	'Lawler',	'201-588-7810'),
('Georgene',	'Montezuma',	'925-615-5185'),
('Jettie',	'Mconnell',	'908-802-3564'),
('Lemuel',	'Latzke',	'631-748-6479'),
('Melodie',	'Knipp',	'805-690-1682'),
('Candida',	'Corbley',	'908-275-8357')

INSERT INTO Parts  (SerialNumber, Description, Price,VendorId) VALUES
('WP8182119', 'Door Boot Seal', 117.86, 2),
('W10780048', 'Suspension Rod',  42.81, 1),
('W10841140', 'Silicone Adhesive', 6.77, 4),
('WPY055980', 'High Temperature Adhesive',  13.94, 3)


-- 3.	Update

-- Step 1

SELECT * 
FROM Mechanics

-- Step 2

SELECT * 
FROM Jobs
WHERE [Status] = 'In Progres'

-- Solution 

UPDATE  Jobs 
SET [MechanicId] = 3, [Status] = 'In Progress'
WHERE [Status] = 'Pending'


-- 4.	Delete

-- First we need to delete from the mapping table 

DELETE  FROM  OrderParts WHERE  OrderId  =  19
DELETE  FROM Orders WHERE OrderId = 19 


-- Section 3. Querying 

-- 5.	Mechanic Assignments

SELECT m.[FirstName] + ' ' + m.[LastName], j.[Status], j.[IssueDate]
FROM Mechanics AS m
JOIN Jobs AS j ON j.MechanicId = m.MechanicId
ORDER BY m.MechanicId, j.IssueDate, j.JobId


-- 6.	Current Clients


SELECT c.[FirstName] + ' ' + c.[LastName], DATEDIFF(DAY, j.IssueDate , '04/24/2017') AS [Days going], j.[Status]
FROM Clients AS c
JOIN Jobs AS j ON j.ClientId = c.ClientId
WHERE j.[Status] <> 'Finished'
ORDER BY [Days going] DESC, c.[ClientId] ASC


-- 7.	Mechanic Performance


SELECT  m.FirstName + ' ' + m.LastName AS [Mechanic],
SUM(DATEDIFF(DAY, j.IssueDate, j.FinishDate)) / COUNT(j.JobId) AS [Average Days]
FROM Mechanics AS m 
JOIN Jobs AS j ON j.MechanicId = m.MechanicId
WHERE j.FinishDate IS NOT NULL
GROUP BY  m.MechanicId, m.FirstName, m.LastName
ORDER BY m.MechanicId ASC


-- 8.	Available Mechanics


SELECT  m.FirstName + ' ' + m.LastName
FROM Mechanics AS m 
LEFT JOIN Jobs AS j ON j.MechanicId = m.MechanicId
WHERE j.JobId IS NULL OR 
                        (
                            SELECT COUNT(JobId)
                            FROM Jobs
                            WHERE [Status] <> 'Finished' AND MechanicId = m.MechanicId
                            GROUP BY [MechanicId], [Status]
                        ) IS NULL 
GROUP BY m.MechanicId, m.FirstName + ' ' + m.LastName

-- Different approach ?!?!

SELECT  m.FirstName + ' ' + m.LastName AS [Available]
FROM Mechanics AS m 
LEFT JOIN Jobs AS j ON j.MechanicId = m.MechanicId
WHERE j.JobId IS NULL OR 'Finished' = ALL 
                                        (
                                            SELECT j.[Status]
                                            FROM Jobs
                                            WHERE j.MechanicId = m.MechanicId
                                        )            
GROUP BY m.MechanicId, m.FirstName + ' ' + m.LastName
ORDER BY m.MechanicId


-- 9.	Past Expenses

-- WRONG for JUDGE 

SELECT j.JobId, SUM(p.Price) AS [Total]
FROM Jobs AS j
JOIN PartsNeeded AS pn ON pn.JobId = j.JobId
JOIN Parts AS p ON p.PartId = pn.PartId
WHERE j.[Status] = 'Finished'
GROUP BY j.JobId
ORDER BY [Total] DESC, j.JobId

-- Different approach 

SELECT j.JobId, 
CASE 
WHEN SUM(p.Price * op.Quantity ) IS NULL THEN 0.00
ELSE SUM(p.Price * op.Quantity )
END AS [Total]
FROM Jobs AS j 
LEFT JOIN Orders AS o ON o.JobId = j.JobId
LEFT JOIN OrderParts AS op ON op.OrderId = o.OrderId
LEFT JOIN Parts AS p ON p.PartId = op.PartId
WHERE j.[Status] = 'Finished'
GROUP BY j.JobId
ORDER BY [Total] DESC, j.JobId


-- Different Syntax


SELECT j.JobId, ISNULL(SUM(p.Price * op.Quantity ),0) AS [Total]
FROM Jobs AS j 
LEFT JOIN Orders AS o ON o.JobId = j.JobId
LEFT JOIN OrderParts AS op ON op.OrderId = o.OrderId
LEFT JOIN Parts AS p ON p.PartId = op.PartId
WHERE j.[Status] = 'Finished'
GROUP BY j.JobId
ORDER BY [Total] DESC, j.JobId


-- 10.	Missing Parts

SELECT p.PartId, 
p.[Description], 
pn.Quantity AS [Requiered],
p.StockQty AS [In Stock] ,
op.Quantity AS [Ordered] ,
o.Delivered AS [Delivered]
FROM Parts AS p 
    JOIN PartsNeeded AS pn ON pn.PartId = p.PartId
    JOIN OrderParts AS op ON op.PartId =  p.PartId
    JOIN Jobs AS j ON j.JobId = pn.JobId
LEFT JOIN Orders AS o ON o.JobId = j.JobId
WHERE j.[Status] != 'Finished' 









