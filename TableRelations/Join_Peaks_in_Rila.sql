-- Problem 9.	*Peaks in Rila

SELECT * 
FROM Mountains
WHERE MountainRange = 'Rila'

SELECT * 
FROM Peaks
WHERE MountainId = 17

SELECT * 
FROM Mountains
JOIN Peaks ON Peaks.MountainId = Mountains.Id
WHERE Mountains.MountainRange = 'Rila'

SELECT MountainRange, PeakName, Elevation
FROM Mountains
JOIN Peaks ON Peaks.MountainId = Mountains.Id
WHERE Mountains.MountainRange = 'Rila'
ORDER BY Peaks.Elevation DESC



