-- LAB TRIGGERS AND TRANSACTIONS

CREATE OR ALTER PROCEDURE usp_TransferFunds(@FromAccountId INT, @ToAccountId INT, @Amount MONEY)
AS
BEGIN TRANSACTION

IF (SELECT Balance FROM Accounts WHERE AccountHolderId = @FromAccountId) < @Amount
BEGIN 
    ROLLBACK;
    THROW 50001, 'Insufficient Funds', 1;
END 
  
IF NOT EXISTS (SELECT * FROM Accounts WHERE AccountHolderId = @FromAccountId) 
BEGIN
    ROLLBACK;
    THROW 50002, 'No Account available', 1;
END

IF NOT EXISTS (SELECT * FROM Accounts WHERE AccountHolderId = @ToAccountId) 
BEGIN
    ROLLBACK;
    THROW 50003, 'No Account available', 1;
END

UPDATE Accounts SET Balance -= @Amount WHERE AccountHolderId = @FromAccountId;
UPDATE Accounts SET Balance += @Amount WHERE AccountHolderId = @ToAccountId;
COMMIT
GO

SELECT * 
FROM Accounts

EXEC dbo.usp_TransferFunds 12, 3,  10000


-- TRIGGERS 

-- TRIGGERS ON UPDATE ACCOUNT => INSERT LOGS
-- TRIGGERS ON DELETE ACCOUNTHOLDERS => NO DELETE => UPDATE IsDeleted column 

CREATE TABLE AccountChanges 
(
    [Id] INT PRIMARY KEY IDENTITY NOT NULL,  -- => PK
    [AccountId] INT NOT NULL REFERENCES Accounts(Id),  -- => FK
    [OldBalance] MONEY NOT NULL,
    [NewBalance] MONEY NOT NULL,
    [DateOfChange] DATETIME NOT NULL
)


-- Deleted is the old data before the changes 
-- Inserted is the new data after the changes
-- Inserted is joining deleted in order for the trigger to obtain the correct information for the columns related to the data before and after. 

CREATE TRIGGER tr_OnAccountChangeAddLogRecord
ON Accounts FOR UPDATE 
AS  
    INSERT AccountChanges (AccountId, OldBalance, NewBalance, DateOfChange)
    SELECt i.Id,  d.Balance,  i.Balance,  GETDATE() 
    FROM inserted  AS i
    JOIN deleted AS d ON d.Id = i.Id
GO

SELECT * FROM AccountChanges

CREATE TRIGGER tr_OnDeleteAccountHoldersSetIsDeleted
ON AccountHolders INSTEAD OF DELETE
AS  
    UPDATE AccountHolders SET IsDeleted = 1
    WHERE Id IN (SELECT Id FROM deleted) 
GO


SELECT * FROM AccountHolders

