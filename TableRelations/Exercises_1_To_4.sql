-- Problem 1.	One-To-One Relationship

-- Primary Key from Passports will be set as foreign key in Persons.
-- In Persons we are setting the foreign key to be unique as the relation should be ONE - To - ONE


CREATE TABLE Passports
(
[PassportID] INT PRIMARY KEY IDENTITY(101,1),
[PassportNumber] NVARCHAR(100) NOT NULL 
)

CREATE TABLE Persons
(
[PersonID] INT IDENTITY PRIMARY KEY,
[FirstName] NVARCHAR(50) NOT NULL,
[Salary] DECIMAL(10,2) NOT NULL, 
[PassportID] INT UNIQUE FOREIGN KEY REFERENCES Passports(PassportID)
)

-- Insering Values into the tables 
-- First in Passports, passports ID column is skipped since the PK will be automatically given startig from 101.

INSERT INTO Passports VALUES
    ('N34FG21B'),
    ('K65LO4R7'),
    ('ZE657QP2')


-- Inserting VALUES into Persons PK is skipped again since it will be automatically given, same as for passports table.

INSERT INTO Persons VALUES
    ('Roberto',43300.00,102),
    ('Tom',	56100.00,103),
    ('Yana',	60200.00,101)


-- Problem 2.	One-To-Many Relationship.
-- PK in manufacturers is set as Foreign key in Models.
-- In ONE to MANY relation the foreign key in the child table it's not unique. 
-- Many models can have same Manufacturers. 

CREATE TABLE Manufacturers
(
    [ManufacturerID] INT IDENTITY PRIMARY KEY,
    [Name] NVARCHAR(30) NOT NULL ,
    [EstablishedOn] DATE
)

CREATE TABLE Models
(
    [ModelID] INT IDENTITY PRIMARY KEY,
    [Name] NVARCHAR(30) NOT NULL,
    [ManufacturerID] INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers
VALUES
('BMW',	'07/03/1916'),
('Tesla',	'01/01/2003'),
('Lada',	'01/05/1966')


INSERT INTO Models
VALUES
('X1', 1),
('i6',1),
('Model S',2),
('Model X',2),
('Model 3',2),
('Nova',3)


-- Problem 3.	Many-To-Many Relationship

CREATE TABLE Students
(
    [StudentId] INT IDENTITY PRIMARY KEY,
    [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Exams
(
[ExamID] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50)
)

CREATE TABLE StudentExams
(
    [StudentId] INT FOREIGN KEY REFERENCES Students(StudentId),
    [ExamID] INT FOREIGN KEY REFERENCES Exams(ExamID),
    CONSTRAINT PK_Sudents_Exams PRIMARY KEY(StudentId, ExamID)
)


INSERT INTO Students VALUES
('Mila'),
('Tony'),
('Ron')

INSERT INTO Exams VALUES 
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

INSERT INTO StudentExams VALUES
(1,	1),
(1,	2),
(2,	1),
(3,	3),
(2,	2),
(2,	3)


-- Problem 4.	Self-Referencing 

CREATE TABLE Teachers 
(
    [TeacherID] INT PRIMARY KEY IDENTITY(101,1),
    [Name] VARCHAR(50),
    [ManagerID] INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)


INSERT INTO Teachers VALUES
('John',NULL),
('Maya',106),
('Silvia',106),
('Ted',105),
('Mark',101),
('Greta',101)
