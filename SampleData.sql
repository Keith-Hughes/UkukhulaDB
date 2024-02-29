INSERT INTO
    [dbo].[ContactDetails] ([Email], [PhoneNumber])
VALUES
    ('jane.smith@yahoo.com', '0823456789'),
    ('michael.johnson@hotmail.com', '0645678901'),
    ('mxolisi.gojolo@gmail.com', '0610277058'),
    ('fmvundlela@gmail.com', '0812345678'),
    ('boipelomorokolo2001@gmail.com', '0723456789'),
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
    ('Mxolisi', 'Sibaya', 3),
    ('Madimetja', 'Movundlela', 4),
    ('Boipelo', 'Morokolo', 5),
    ('Thabo', 'Mkhize', 6),
    ('Nomvula', 'Zulu', 7),
    ('Sipho', 'Mbele', 8),
    ('Lindiwe', 'Ngwenya', 9),
    ('Bongani', 'Khumalo', 10);
GO

INSERT INTO [dbo].[UniversityUser] ([UniversityID], [UserID],[DepartmentID])
VALUES
    (1, 3,3),
    (2, 6,1),
    (3, 7,1),
    (4, 10,2);
GO

INSERT INTO [dbo].[UserRole] ([UserID], [RoleID])
VALUES
    (1, 3),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1),
    (6, 2),
    (7, 3),
    (7, 2),
    (9, 3),
    (10, 2);
GO

INSERT INTO [dbo].[BBDAllocation]([Budget], [DateCreated])
VALUES
    (3000000,'2020-03-01' ),
    (3000000,'2021-03-01' ),
    (3000000,'2022-03-01' ),
    (3000000,'2023-03-01' ),
    (3000000,'2024-03-01' )


GO

INSERT INTO[dbo].[UniversityFundRequest](
        [UniversityID],
        [DateCreated],
        [Amount],
        [StatusID],
        [Comment]
    )
VALUES
    (3, '2021-03-01', 120000, 1,  'Approved'),
    (7,'2021-05-01',80000,2,'Rejected - Insufficient documentation' ),
    (12, '2021-08-01', 150000, 3, ''),
    (5, '2021-11-01', 100000, 1, 'Approved'),
    ( 18, '2022-02-01', 180000, 2, 'Rejected - Funding not available'
    ),
    (9, '2022-04-01', 90000, 3, ''),
    (14, '2022-06-01', 110000, 1, 'Approved'),
    (2,'2022-09-01',140000,2,'Rejected - Ineligible for funding'),
    (16, '2022-12-01', 160000, 3, ''),
    (10, '2023-01-01', 70000, 1, 'Approved'),
    (  1,'2023-03-01',120000,2,'Rejected - Incomplete application'),
    (8, '2023-05-01', 130000, 3,  ''),
    (13, '2023-08-01', 190000, 1, 'Approved'),
    (6,'2023-11-01',50000,2,'Rejected - Low academic performance'
    ),
    (17, '2006-02-01', 100000, 3, ''),
    (11, '2006-04-01', 80000, 1,  'Approved'),
    (4,'2021-06-01',150000,2,'Rejected - Duplicate application'
    ),
    (15, '2014-09-01', 160000, 3, ''),
    (19, '2014-12-01', 30000, 1,  'Approved'),
    ( 9, '2008-01-01', 110000, 2, 'Rejected - Insufficient documentation'),
    (7, '2005-03-01', 120000, 3, ''),
    (2, '2025-05-01', 70000, 1, 'Approved'),
    (14,'2005-08-01',130000,2,'Rejected - Ineligible for funding'),
    (5, '2005-11-01', 80000, 3,  ''),
    (18, '2026-02-01', 140000, 1,  'Approved'),
    ( 11, '2006-04-01', 160000, 2, 'Rejected - Low academic performance'),
    (16, '2016-06-01', 170000, 3, ''),
    (3, '2016-09-01', 120000, 1,  'Approved'),
    (12, '2011-12-01', 180000, 2, 'Rejected - Incomplete application'),
    (8, '2017-01-01', 90000, 3,  ''),
    (13, '2017-03-01', 110000, 1, 'Approved'),
    ( 6, '2020-05-01', 190000, 2, 'Rejected - Duplicate application'),
    (17, '2017-08-01', 100000, 3,  ''),
    (10, '2007-11-01', 120000, 1, 'Approved'),
    (1,'2020-02-01',140000,2,'Rejected - Insufficient documentation'),
    (15, '2018-04-01', 150000, 3, ''),
    (4, '2002-06-01', 80000, 1, 'Approved'),
    (19,'2018-09-01',90000,2,'Rejected - Ineligible for funding'),
    (9, '2018-12-01', 110000, 3, ''),
    (2, '2019-01-01', 120000, 1, 'Approved');
 
GO

INSERT INTO
    [dbo].[UniversityFundAllocation] ([Budget], [DateAllocated], [UniversityID], [BBDAllocationID])
VALUES
    (185000, '2020-04-01', 1,1),
    (220000, '2020-04-01', 2,1),
    (130000, '2020-04-01', 3,1),
    (195000, '2020-04-01', 4,1),
    (155000, '2020-04-01', 19,1),
    (225000, '2021-03-01', 7,2),
    (205000, '2021-03-01', 8,2),
    (175000, '2021-03-01', 15,2),
    (225000, '2021-03-01', 16,2),
    (205000, '2021-03-01', 17,2),
    (245000, '2021-03-01', 18,2),
    (155000, '2021-03-01', 19,2),
    (185000, '2022-03-01', 1,3),
    (175000, '2022-03-01', 6,3),
    (225000, '2022-03-01', 7,3),
    (205000, '2022-03-01', 8,3),
    (185000, '2022-03-01', 9,3),
    (235000, '2022-03-01', 10,3),
    (185000, '2023-03-01', 1,4),
    (175000, '2023-03-01', 6,4),
    (225000, '2023-03-01', 7,4),
    (205000, '2023-03-01', 8,4),
    (185000, '2023-03-01', 9,4),
    (235000, '2023-03-01', 10,4);
GO

INSERT INTO
    [dbo].[Student] (
        [IDNumber],
        [BirthDate],
        [GenderID],
        [UserID],
        [RaceID],
        [DepartmentID]
    )
VALUES
    ('8601011234082', '1986-01-01', 2, 2, 1,2),
    ('8702011234073','1987-02-01',2,3,3,1),
    ('8803011234064', '1988-03-01', 1, 4, 1,1),
    ('8904011234055','1989-04-01',2,5, 2,3),
    ('9005011234046', '1990-05-01', 1, 6, 3,1);
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
        [Comment],
        [StudentID],
        [UniversityFundID]
    )
VALUES
    (86, 2000, '',1,6),
    (81 ,180000, 'Low GPA',2,2),
    (85, 200000, '',3,3),
    (83, 160000, '',4,4),
    (86, 2000, '',1,6),
    (81 ,180000, 'Low GPA',2,2),
    (85, 200000, '',3,3),
    (83, 160000, '',4,4);
    
GO 

--UPDATE   [dbo].[StudentFundRequest]
--SET [StatusID]=1 WHERE ID =7



