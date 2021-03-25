CREATE DATABASE Hotel

USE Hotel

-- 	Employees (Id, FirstName, LastName, Title, Notes)

CREATE TABLE Employees
(
     Id INT PRIMARY KEY,
     FirstName VARCHAR(90) NOT NULL,
     LastName VARCHAR(90) NOT NULL,
     Title VARCHAR(50) NOT NULL,
     Notes VARCHAR(MAX)
)

INSERT INTO Employees  (Id, FirstName, LastName, Title, Notes) VALUES
(1, 'Gosho', 'Goshov', 'Mr', NULL),
(2, 'Pesho', 'Peshov', 'Mr', NULL),
(3, 'Binbin', 'Lubinbin', 'Mr', NULL)

-- Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes)

CREATE TABLE Customers
(
 AccountNumber BIGINT PRIMARY KEY,
 FirstName VARCHAR(90) NOT NULL,
 LastName VARCHAR(90) NOT NULL,
 PhoneNumber CHAR(10) NOT NULL,
 EmergencyName VARCHAR(90) NOT NULL,
 EmergencyNumber CHAR(10) NOT NULL,
 Notes VARCHAR(MAX)
)

INSERT INTO Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes) VALUES
(100, 'Gosho', 'Goshov', '1234345', 'Goshko','12142', NULL),
(120, 'Bin', 'LuBinBin', '1223345', 'Ivanov','12342', NULL),
(130, 'Ivan', 'Donald', '1234345', 'Petrov','14542', NULL)


-- RoomStatus (RoomStatus, Notes)

CREATE TABLE RoomStatus
(
 RoomStatus BIT NOT NULL,
 Notes VARCHAR(MAX)
)

INSERT INTO RoomStatus VALUES
(1, NULL),
(0, NULL),
(0, NULL)

-- RoomTypes (RoomType, Notes)

CREATE TABLE RoomTypes
(
 RoomType VARCHAR(50) NOT NULL,
 Notes VARCHAR(MAX)
)

INSERT INTO RoomTypes VALUES
('Single', NULL),
('Double', NULL),
('Single', NULL)

-- BedTypes (BedType, Notes)

CREATE TABLE BedTypes
(
 BedType VARCHAR(50) NOT NULL,
 Notes VARCHAR(MAX)
)

INSERT INTO BedTypes VALUES
('Single', NULL),
('Double', NULL),
('Single', NULL)

-- Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)

CREATE TABLE Rooms
(
 RoomNumber INT PRIMARY KEY NOT NULL,
 RoomType VARCHAR(40) NOT NULL,
 BedType VARCHAR(40) NOT NULL,
 Rate VARCHAR(40) NOT NULL,
 RoomStatus BIT NOT NULL,
 Notes VARCHAR(MAX)
)

INSERT INTO Rooms VALUES
(110, 'Single', 'Single', 'Good', 0, NULL),
(120, 'Single', 'Single', 'Excellent', 1, NULL),
(130, 'Double', 'Double', 'Good', 1, NULL)

-- Payments (Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, 
-- LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes)

CREATE TABLE Payments
(
 Id INT PRIMARY KEY NOT NULL,
 EmployeeId INT NOT NULL,
 PaymentDate DATETIME NOT NULL,
 AccountNumber INT NOT NULL,
 FirstDateOccupied DATETIME NOT NULL,
 LastDateOccupied DATETIME NOT NULL,
 TotalDays INT NOT NULL,
 AmountCharged DECIMAL(15,2),
 TaxRate INT,
 TaxAmount INT,
 PaymentTotal DECIMAL(15,2),
 Notes VARCHAR(MAX)
)

INSERT INTO Payments VALUES
(110, 2122, '12/12/20', 231232, '01/12/20','10/12/20', 21, 232341, 12, 1213,23123, NULL),
(111, 2312, '10/12/20', 32342, '01/12/20','10/12/20', 11, 3232, 12, 1213,32131, NULL),
(123, 2324, '11/12/20', 3242, '01/12/20','10/12/20', 22, 234321, 22, 1213,2313, NULL)


-- Occupancies (Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)

CREATE TABLE Occupancies
(
 Id INT PRIMARY KEY NOT NULL,
 EmployeeId INT NOT NULL,
 DateOccupied DATETIME NOT NULL,
 AccountNumber INT NOT NULL,
 RoomNumber INT NOT NULL,
 RateApplied INT,
 PhoneCharge DECIMAL(15,2),
 Notes VARCHAR(MAX)
)

INSERT INTO Occupancies VALUES
(110, 2122, '12/12/20', 231232,12, 21, 21, NULL),
(111, 2312, '10/12/20', 32342,11, 11, 12, NULL),
(123, 2324, '11/12/20', 3242,10, 22, 12,NULL)