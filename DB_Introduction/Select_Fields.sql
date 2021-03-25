SELECT * FROM Rooms

UPDATE Rooms
SET Rate = 20 
WHERE RoomNumber = 110

UPDATE Rooms
SET Rate = 30 
WHERE RoomNumber = 120

UPDATE Rooms
SET Rate = 40 
WHERE RoomNumber = 130

SELECT * FROM Payments
UPDATE Payments
SET AmountCharged = AmountCharged * 1.10
