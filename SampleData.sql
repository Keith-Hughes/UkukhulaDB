INSERT INTO
    [dbo].[ContactDetails] ([Email], [PhoneNumber])
VALUES
    ('jane.smith@yahoo.com', '0823456789'),
    ('michael.johnson@hotmail.com', '0645678901'),
    ('lerato.molefe@gmail.com', '0734567890'),
    ('alice.brown@gmail.com', '0812345678'),
    ('david.lee@yahoo.com', '0723456789'),
    ('sarah.jones@gmail.com', '0845678901'),
    ('brian.nguyen@hotmail.com', '0765432109'),
    ('nomfundo.ndlovu@gmail.com', '0834567890'),
    ('peter.smith@yahoo.com', '0790123456'),
    ('lisa.martin@hotmail.com', '0665432109');
GO

INSERT INTO
    [dbo].[University] ([Name], [ProvinceID])
VALUES
    ('University of Cape Town', 6),
    ('University of Pretoria', 2),
    ('Stellenbosch University', 6),
    ('University of the Witwatersrand', 2),
    ('Rhodes University', 8),
    ('University of Johannesburg', 2),
    ('University of KwaZulu-Natal', 4),
    ('North-West University', 5),
    ('University of the Free State', 7),
    ('Nelson Mandela University', 8),
    ('Cape Peninsula University of Technology', 6),
    ('Durban University of Technology', 4),
    ('University of Limpopo', 1),
    ('Tshwane University of Technology', 2),
    ('Walter Sisulu University', 8),
    ('Mangosuthu University of Technology', 4),
    ('Vaal University of Technology', 2),
    ('University of Venda', 1),
    ('Central University of Technology', 7);

GO


INSERT INTO
    [dbo].[User] ([FirstName], [LastName], [ContactID])
VALUES
    ('Jane', 'Smith', 1),
    ('Michael', 'Johnson', 2),
    ('Lerato', 'Molefe', 3),
    ('Alice', 'Brown', 4),
    ('David', 'Lee', 5),
    ('Thabo', 'Mkhize', 6),
    ('Nomvula', 'Zulu', 7),
    ('Sipho', 'Mbele', 8),
    ('Lindiwe', 'Ngwenya', 9),
    ('Bongani', 'Khumalo', 10);
GO

INSERT INTO [dbo].[UniversityUser] ([UniversityID], [UserID])
VALUES
    (1, 3),
    (2, 6),
    (3, 7),
    (4, 10);
GO

INSERT INTO [dbo].[UserRole] ([UserID], [RoleID])
VALUES
    (1, 3),
    (2, 1),
    (3, 2),
    (4, 3),
    (5, 1),
    (6, 2),
    (7, 3),
    (7, 2),
    (9, 3),
    (10, 2);
GO

INSERT INTO
    [dbo].[Student] (
        [IDNumber],
        [BirthDate],
        [GenderID],
        [UserID],
        [RaceID]
    )
VALUES
    ('8601011234082', '1986-01-01', 2, 2, 1),
    ('8702011234073','1987-02-01',2,3,3),
    ('8803011234064', '1988-03-01', 1, 4, 1),
    ('8904011234055','1989-04-01',2,5, 2),
    ('9005011234046', '1990-05-01', 1, 6, 3);
GO

INSERT INTO [dbo].[UniversityStudentInformation] ([UniversityID], [StudentID])
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (9, 5);
GO

INSERT INTO
    [dbo].[StudentFundRequest] (
        [Grade],
        [Amount],
        [StatusID],
        [Comment],
        [StudentID]
    )
VALUES
    (75, 150000, 2, '',1),
    (42, 180000, 3, 'Low GPA',2),
    (90, 200000, 1, '',3),
    (78, 160000, 1, '',4);
    
GO 

INSERT INTO [dbo].[BBDAllocation]([Budget], [DateCreated])
VALUES
    (100000000,'2023-03-01' ),
    (100000000,'2022-03-01' ),
    (100000000,'2021-03-01' ),
    (100000000,'2020-03-01' )
GO

INSERT INTO
    [dbo].[UniversityFundAllocation] ([Budget], [DateAllocated], [UniversityID], [BBDAllocationID])
VALUES
    (1850000, '2022-03-01', 1,1),
    (2200000, '2022-03-01', 2,1),
    (1350000, '2022-03-01', 3,1),
    (1950000, '2022-03-01', 4,1),
    (2650000, '2022-03-01', 5,1),
    (1750000, '2022-03-01', 6,1),
    (2250000, '2022-03-01', 7,1),
    (2050000, '2022-03-01', 8,1),
    (1850000, '2022-03-01', 9,1),
    (2350000, '2022-03-01', 10,1),
    (1450000, '2022-03-01', 11,1),
    (2550000, '2022-03-01', 12,1),
    (2150000, '2022-03-01', 13,1),
    (1950000, '2022-03-01', 14,1),
    (1750000, '2022-03-01', 15,1),
    (2250000, '2022-03-01', 16,1),
    (2050000, '2022-03-01', 17,1),
    (2450000, '2022-03-01', 18,1),
    (1550000, '2022-03-01', 19,1),
    (1850000, '2021-03-01', 1,2),
    (2200000, '2021-03-01', 2,2),
    (1350000, '2021-03-01', 3,2),
    (1950000, '2021-03-01', 4,2),
    (2650000, '2021-03-01', 5,2),
    (1750000, '2021-03-01', 6,2),
    (2250000, '2021-03-01', 7,2),
    (2050000, '2021-03-01', 8,2),
    (1850000, '2021-03-01', 9,2),
    (2350000, '2021-03-01', 10,2),
    (1450000, '2021-03-01', 11,2),
    (2550000, '2021-03-01', 12,2),
    (2150000, '2021-03-01', 13,2),
    (1950000, '2021-03-01', 14,2),
    (1750000, '2021-03-01', 15,2),
    (2250000, '2021-03-01', 16,2),
    (2050000, '2021-03-01', 17,2),
    (2450000, '2021-03-01', 18,2),
    (1550000, '2021-03-01', 19,2),
    (1850000, '2020-03-01', 1,3),
    (2200000, '2020-03-01', 2,3),
    (1350000, '2020-03-01', 3,3),
    (1950000, '2020-03-01', 4,3),
    (2650000, '2020-03-01', 5,3),
    (1750000, '2020-03-01', 6,3),
    (2250000, '2020-03-01', 7,3),
    (2050000, '2020-03-01', 8,3),
    (1850000, '2020-03-01', 9,3),
    (2350000, '2020-03-01', 10,3);
GO

INSERT INTO[dbo].[UniversityFundRequest](
        [UniversityID],
        [DateCreated],
        [Amount],
        [StatusID],
        [Comment]
    )
VALUES
    (3, '2021-03-01', 1200000, 1,  'Approved'),
    (7,'2021-05-01',800000,2,'Rejected - Insufficient documentation' ),
    (12, '2021-08-01', 1500000, 3, ''),
    (5, '2021-11-01', 1000000, 1, 'Approved'),
    ( 18, '2022-02-01', 1800000, 2, 'Rejected - Funding not available'
    ),
    (9, '2022-04-01', 900000, 3, ''),
    (14, '2022-06-01', 1100000, 1, 'Approved'),
    (2,'2022-09-01',1400000,2,'Rejected - Ineligible for funding'),
    (16, '2022-12-01', 1600000, 3, ''),
    (10, '2023-01-01', 700000, 1, 'Approved'),
    (  1,'2023-03-01',1200000,2,'Rejected - Incomplete application'),
    (8, '2023-05-01', 1300000, 3,  ''),
    (13, '2023-08-01', 1900000, 1, 'Approved'),
    (6,'2023-11-01',500000,2,'Rejected - Low academic performance'
    ),
    (17, '2006-02-01', 1000000, 3, ''),
    (11, '2006-04-01', 800000, 1,  'Approved'),
    (4,'2021-06-01',1500000,2,'Rejected - Duplicate application'
    ),
    (15, '2014-09-01', 1600000, 3, ''),
    (19, '2014-12-01', 300000, 1,  'Approved'),
    ( 9, '2008-01-01', 1100000, 2, 'Rejected - Insufficient documentation'),
    (7, '2005-03-01', 1200000, 3, ''),
    (2, '2025-05-01', 700000, 1, 'Approved'),
    (14,'2005-08-01',1300000,2,'Rejected - Ineligible for funding'),
    (5, '2005-11-01', 800000, 3,  ''),
    (18, '2026-02-01', 1400000, 1,  'Approved'),
    ( 11, '2006-04-01', 1600000, 2, 'Rejected - Low academic performance'),
    (16, '2016-06-01', 1700000, 3, ''),
    (3, '2016-09-01', 1200000, 1,  'Approved'),
    (12, '2011-12-01', 1800000, 2, 'Rejected - Incomplete application'),
    (8, '2017-01-01', 900000, 3,  ''),
    (13, '2017-03-01', 1100000, 1, 'Approved'),
    ( 6, '2020-05-01', 1900000, 2, 'Rejected - Duplicate application'),
    (17, '2017-08-01', 1000000, 3,  ''),
    (10, '2007-11-01', 1200000, 1, 'Approved'),
    (1,'2020-02-01',1400000,2,'Rejected - Insufficient documentation'),
    (15, '2018-04-01', 1500000, 3, ''),
    (4, '2002-06-01', 800000, 1, 'Approved'),
    (19,'2018-09-01',900000,2,'Rejected - Ineligible for funding'),
    (9, '2018-12-01', 1100000, 3, ''),
    (2, '2019-01-01', 1200000, 1, 'Approved');
 
GO