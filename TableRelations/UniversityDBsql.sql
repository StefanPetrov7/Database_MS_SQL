CREATE DATABASE UniversityDatabase

USE UniversityDatabase

CREATE TABLE Majors
(
    [MajorID] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Subjects
(
    [SubjectID] INT IDENTITY PRIMARY KEY,
    [SubjectName] NVARCHAR(50) NOT NULL
)


CREATE TABLE Students
(
[StudentID] INT IDENTITY PRIMARY KEY,
[StudentNumber] INT NOT NULL,
[StudentName] NVARCHAR(50) NOT NULL,
[MajorID] INT FOREIGN KEY REFERENCES Majors(MajorID)
)


CREATE TABLE Agenda
(
    [StudentID] INT FOREIGN KEY REFERENCES Students(StudentID),
    [SubjectID] INT FOREIGN KEY REFERENCES Subjects(SubjectID),
    CONSTRAINT PK_Students_Subjects PRIMARY KEY(StudentID, SubjectID)
)


CREATE TABLE Payments
(
    [PaymentID] INT PRIMARY KEY IDENTITY,
    [PaymentDate] DATE NOT NULL,
    [PaymentAmount] DECIMAL(6,2) NOT NULL,
    [StudentID] INT FOREIGN KEY REFERENCES Students(StudentID)
)
