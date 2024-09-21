-- Databases MSSQL Server Exam - 19 June 2022

CREATE DATABASE [Zoo]

USE [Zoo]

-------

CREATE TABLE [Owners]
(
 [Id] INT PRIMARY KEY IDENTITY,
 [Name] VARCHAR(50) NOT NULL,
 [PhoneNumber] VARCHAR(15) NOT NULL,
 [Address] VARCHAR(50)
)

-------

CREATE TABLE [AnimalTypes]
(
 [Id] INT PRIMARY KEY IDENTITY,
 [AnimalType] VARCHAR(30) NOT NULL,
)

-------

CREATE TABLE [Cages]
(
 [Id] INT PRIMARY KEY IDENTITY,
 [AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes](Id) NOT NULL
)

-------

CREATE TABLE [Animals]
(
 [Id] INT PRIMARY KEY IDENTITY,
 [Name] VARCHAR(30) NOT NULL,
 [BirthDate] DATE NOT NULL,
 [OwnerId] INT FOREIGN KEY REFERENCES [Owners](Id),
 [AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes](Id)NOT NULL
)

-------

CREATE TABLE [AnimalsCages]
(
	[CageId] INT FOREIGN KEY REFERENCES [Cages](Id) NOT NULL,
	[AnimalId] INT FOREIGN KEY REFERENCES [Animals](Id) NOT NULL,
	PRIMARY KEY ([CageId], [AnimalId])
)

-------

CREATE TABLE [VolunteersDepartments]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[DepartmentName] VARCHAR(30) NOT NULL
)

-------

CREATE TABLE [Volunteers]
(
 [Id] INT PRIMARY KEY IDENTITY,
 [Name] VARCHAR(50) NOT NULL,
 [PhoneNumber] VARCHAR(15) NOT NULL,
 [Address] VARCHAR(50),
 [AnimalId] INT FOREIGN KEY REFERENCES [Animals](Id),
 [DepartmentId] INT FOREIGN KEY REFERENCES [VolunteersDepartments](Id) NOT NULL
)

-------

INSERT INTO [Animals] ([Name], [BirthDate], [OwnerId], [AnimalTypeId]) VALUES
('Giraffe', '2018-09-21', 21, 1),
('Harpy Eagle', '2015-04-17', 15, 3),
('Hamadryas Baboon', '2017-11-02', NULL, 1),
('Tuatara', '2021-06-30', 2, 4)

INSERT INTO [Volunteers] ([Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId]) VALUES
('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
('Dimitur Stoev', '0877564223', NULL, 42, 4),
('Kalina Evtimov', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
('Boryana Mileva', '0888112233', NULL, 31, 5)

-------

SELECT [Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId]
FROM [Volunteers]
ORDER BY [Name] ASC,
[DepartmentId] ASC

-------

SELECT [Animals].Name, [AnimalTypes].AnimalType, FORMAT([Animals].BirthDate, 'dd.MM.yyyy') AS [BirthDate]
FROM Animals
LEFT JOIN [AnimalTypes] ON [Animals].AnimalTypeId = [AnimalTypes].Id
ORDER BY [Animals].Name ASC

-------

SELECT TOP(5) [Owners].Name, COUNT([Animals].Id) AS [CountOfAnimals]
FROM [Owners]
LEFT JOIN [Animals] ON [Owners].Id = [Animals].OwnerId
GROUP BY [Owners].Name
ORDER BY [CountOfAnimals] DESC

-------

SELECT  CONCAT([o].Name ,'-',[a].Name) AS [OwnersAnimals], [o].PhoneNumber, [ac].CageId
FROM [Owners] AS o
INNER JOIN  [Animals] AS [a] ON [o].Id = [a].OwnerId 
INNER JOIN [AnimalTypes] AS [at] ON [a].AnimalTypeId = [at].Id
INNER JOIN [AnimalsCages] AS [ac] ON [a].Id = [ac].AnimalId
WHERE [at].AnimalType = 'Mammals'
ORDER BY [o].Name ASC,
		 [a].Name DESC

-------

SELECT [v].Name, [v].PhoneNumber,  TRIM(REPLACE(REPLACE([v].Address, 'Sofia', ''), ',', '')) AS [Address]
FROM [Volunteers] AS [v]
INNER JOIN [VolunteersDepartments] AS [vd] ON [v].DepartmentId = [vd].Id
WHERE [vd].DepartmentName = 'Education program assistant' 
AND [v].Address LIKE '%Sofia%'
ORDER BY [v].Name

-------

SELECT [a].Name, YEAR([a].BirthDate) AS [BirthYear], [at].AnimalType
FROM [Animals] AS a
LEFT JOIN [AnimalTypes] AS at ON [a].AnimalTypeId = [at].Id
WHERE [a].OwnerId IS NULL AND
(   
	[at].AnimalType != 'Birds' AND
    DATEDIFF(year, [a].BirthDate, '2022-01-01') < 5
)
ORDER BY [a].Name


-------


CREATE FUNCTION dbo.udf_GetVolunteersCountFromADepartment 
(
	@VolunteersDepartment VARCHAR(MAX)
)
RETURNS INT 
AS
BEGIN
	DECLARE @Result INT;
		SET @Result = ( SELECT Count(*)
			FROM [VolunteersDepartments] AS [vt]
			INNER JOIN [Volunteers] AS [v] ON [vt].Id = [v].DepartmentId
			WHERE [vt].DepartmentName = @VolunteersDepartment)

	RETURN @Result
END



SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant') 


------

CREATE PROCEDURE  usp_AnimalsWithOwnersOrNot
(
	@AnimalName VARCHAR(30)
)
AS 
BEGIN
	       SELECT  [a].Name, ISNULL([o].Name, 'For adoption') AS [OwnersName]
					FROM [Animals] AS [a]
					LEFT JOIN [Owners] AS [o] ON [a].OwnerId = [o].Id
					WHERE [a].Name = @AnimalName
END

EXEC usp_AnimalsWithOwnersOrNot 'Pumpkinseed Sunfish' 









