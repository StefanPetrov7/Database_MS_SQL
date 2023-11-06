-- -> Table relations lab exercises 

CREATE DATABASE CoursesTest

CREATE TABLE Students
(
	[Id] INT IDENTITY PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[FacultyNumber] CHAR(6) UNIQUE NOT NULL,
	[Photo] VARBINARY(MAX),
	[DateOfEnlistemnt] DATE,
	[Courses] NVARCHAR(50)
)

CREATE TABLE Towns
(
	[Id] INT IDENTITY PRIMARY KEY ,
	[Name] NVARCHAR(50) UNIQUE 
)

CREATE TABLE Courses
(
	[Id] INT IDENTITY PRIMARY KEY,
	[Name] NVARCHAR(1000) NOT NULL,
	[TownId] INT,
	CONSTRAINT FK_Course_Towns  -- -> FK to Table Towns 
	FOREIGN KEY (TownId)
	REFERENCES Towns(Id)
)

CREATE TABLE StudentsInCourses  -- -> Many to Many relation (Students <-> Courses)
(
	[StudentId] INT REFERENCES Students(Id),  -- -> Reference to Students
	[CourseId] INT REFERENCES Courses(Id), -- -> Reference to Courses
	CONSTRAINT PK_StudentCourses PRIMARY KEY(StudentId, CourseId), -- -> Composite Primary Key 
	[Mark] DECIMAL (3,2)  -- -> Additional column 
)

DROP TABLE Courses

ALTER TABLE Students
DROP COLUMN Courses

SELECT c.[Name] AS [Course Name], t.[Name] As [Town Name]
	FROM Courses AS c
	JOIN Towns AS t
	ON c.TownId = t.Id 

DROP DATABASE CoursesTest

Use Geography

SELECT m.MountainRange, p.PeakName, p.Elevation
	FROM Peaks AS p
	JOIN Mountains AS m
	ON p.MountainId = m.Id
	WHERE MountainRange = 'Rila'
	ORDER BY Elevation DESC

-- -> Table Relations Exercise

CREATE DATABASE Test

Use Test

-- -> One-To-One Relationship

CREATE TABLE Passports
(
	[PassportID] INT PRIMARY KEY,
	[PassportNumber] NVARCHAR(50) UNIQUE NOT NULL
)

INSERT INTO Passports(PassportID, PassportNumber) VALUES
	(101, 'N34FG21B'),
	(102, 'K65LO4R7'),
	(103, 'ZE657QP2')


CREATE TABLE Persons	
(
	[PersonID] INT IDENTITY PRIMARY KEY,
	[FirstName] NVARCHAR(50) NOT NULL,
	[Salary] DECIMAL(12,2) NOT NULL,
	[PassportID] INT UNIQUE,
	CONSTRAINT FK_Persons_Passports
	FOREIGN KEY(PassportID)
	REFERENCES Passports(PassportID)
)

INSERT INTO Persons(FirstName,Salary, PassportID) VALUES
	('Roberto', 43300.00, 102),
	('Tom', 56100.00, 103),
	('Yana', 60200.00, 101)


SELECT * 
	FROM Persons AS p
	JOIN Passports AS pa
	ON p.PassportID = pa.PassportID

DROP TABLE Passports
DROP TABLE Persons

-- -> One-To-Many Relationship

CREATE TABLE Models
(
	[ModelID] INT PRIMARY KEY,
	[Name] NVARCHAR(20) NOT NULL,
)

ALTER TABLE Models
ADD ManufacturerID INT 

INSERT INTO Models (ModelID, [Name]) VALUES
	(101,'X1'),
	(102,'i6'),
	(103,'Model S'),
	(104, 'Model X'),
	(105, 'Model 3'),
	(106,'Nova')

CREATE TABLE Manufacturers
(
	[ManufacturerID] INT IDENTITY PRIMARY KEY,
	[Name] NVARCHAR(20) NOT NULL,
	[EstablishedOn] DATE NOT NULL,
)

INSERT INTO Manufacturers([Name], EstablishedOn) VALUES
	('BMW', '07/03/1916'),
	('Tesla','01/01/2003'),
	('Lada', '01/05/1966')

ALTER TABLE Models
	ADD CONSTRAINT FK_Models_Manufacturers
	FOREIGN KEY(ManufacturerID)
	REFERENCES Manufacturers(ManufacturerID)

SELECT *
	FROM Models

SELECT *
	FROM Manufacturers

SELECT *
	FROM Manufacturers AS ma
	JOIN Models as mo
	ON ma.ManufacturerID = mo.ManufacturerID


-- -> Many-To-Many Relationship

USE Test 

CREATE TABLE Students
(
	[StudentID] INT IDENTITY PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
)

INSERT INTO Students ([Name]) VALUES
	('Mila'),
	('Toni'),
	('Ron')

CREATE TABLE Exams
(
	[ExamID] INT PRIMARY KEY, 
	[Name] NVARCHAR(50),
)

INSERT INTO Exams(ExamID, [Name]) VALUES
	(101,'SpringMVC'),
	(102,'Neo4j'),
	(103,'Oracle 11g')

CREATE TABLE StudentsExams
(
	[StudentID] INT REFERENCES Students(StudentID), -- -> references to PK from Students table
	[ExamID] INT REFERENCES Exams(ExamID), -- -+ references to PK from Exams table 
	CONSTRAINT PK_StudentExams PRIMARY KEY(StudentID, ExamID)  -- -> composite primary key 
        -- ->CONSTRAINT FK_StudentID FOREIGN KEY(StudentID) REFERENCES Students(StudentID), -- -> alternative code foradding FK
        -- -> CONSTRAINT FK_ExamID FOREIGN KEY(ExamID) REFERENCES Exams(ExamID) -- -> alternative code foradding FK
)

INSERT INTO StudentsExams(StudentID, ExamID) VALUES
	(1,101),
	(1,102),
	(2,101),
	(3,103),
	(2,102),
	(2,103)



-- -> Self-Referencing 

CREATE TABLE Teachers
(
	[TeacherID] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[ManagerID] INT REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers(TeacherID, [Name], ManagerID) VALUES 
	(101, 'John', NULL),
	(102,'Maya', 106),
	(103, 'Silvia', 106),
	(104, 'Ted', 105),
	(105, 'Mark', 101),
	(106, 'Greta', 101)

-- ->  Online Store Database

CREATE DATABASE OnLineStore

CREATE TABLE Cities
(
	[CityID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Customers
(
	[CustomerID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[Birthday] DATE NOT NULL,
	[CityID] INT,
	CONSTRAINT FK_CustomersCities
	FOREIGN KEY (CityID)
	REFERENCES Cities(CityID)
)

CREATE TABLE Orders
(
	[OrderID] INT  PRIMARY KEY IDENTITY,
	[CustomerID] INT,
	CONSTRAINT FK_OrdersCustomers
	FOREIGN KEY (CustomerID)
	REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes
(
	[ItemTypeID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50)
)

CREATE TABLE Items
(
	[ItemID] INT  PRIMARY KEY IDENTITY, 
	[Name] VARCHAR(50) NOT NULL,
	[ItemTypeID] INT,
	CONSTRAINT FK_ItemsItemsTypes
	FOREIGN KEY (ItemTypeID)
	REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems
(
	[OrderID] INT FOREIGN KEY REFERENCES Orders(OrderID),
	[ItemID] INT FOREIGN KEY REFERENCES Items(ItemID),
	CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID, ItemID)
)
