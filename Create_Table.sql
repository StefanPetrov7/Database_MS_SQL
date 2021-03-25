CREATE TABLE Users 
(
[Id] BIGINT PRIMARY KEY IDENTITY,
Username VARCHAR(30) NOT NULL,
[Password] VARCHAR(26) NOT NULL,
ProfilePicture VARCHAR(MAX),  
LastLogInTime DATETIME,
IsDeleted BIT,
)
INSERT INTO  Users 
 (Username, [Password], ProfilePicture, LAstLogInTime, IsDeleted)
 VALUES
 ('Trump', 'sfdsfds', 'https://github.com/tdykstra','1/12/2021',0),
  ('Ivan', 'sfss', 'https://github.com/tdykstra','1/13/2021',0),
   ('BinBin', '3r434r', 'https://github.com/tdykstra','1/14/2021',0),
    ('LuBinBin', 'vsdffd', 'https://github.com/tdykstra','1/15/2021',0),
     ('Biden', 'jhkgjfj', 'https://github.com/tdykstra','1/16/2021',0)
