USE master
GO

CREATE DATABASE UkukhulaDB
GO

USE UkukhulaDB
GO

CREATE TABLE [dbo].[Status](
	[ID] [int] PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[Type] [varchar](20) NOT NULL
)
GO
CREATE TABLE [dbo].[Departments](
    [DepartmentID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [Department] VARCHAR(80) NOT NULL

)

CREATE TABLE [dbo].[Provinces] (
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [ProvinceName] [varchar](13) NOT NULL
)
GO

CREATE TABLE [dbo].[Race] (
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [RaceName] [varchar](8) NOT NULL
)
GO

CREATE TABLE [dbo].[DocumentType] (
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [Type] [varchar](20) NOT NULL
)
GO

CREATE TABLE [dbo].[Role] (
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [RoleType] [varchar](20) NOT NULL
)
GO

CREATE TABLE [dbo].[ContactDetails](
	[ID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	[Email] [varchar](255) UNIQUE NOT NULL,
	[PhoneNumber] [varchar](13) UNIQUE NOT NULL,
)
GO

CREATE TABLE [dbo].[University](
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [Name] [varchar](120),
    [ProvinceID] [int] FOREIGN KEY REFERENCES [dbo].[Provinces](ID),
    [Status] [CHAR](8) DEFAULT 'INACTIVE'
)
GO


CREATE TABLE [dbo].[UniversityFundRequest](
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [UniversityID] [int] FOREIGN KEY REFERENCES [dbo].[University](ID),
    [DateCreated] [date] DEFAULT GETDATE(),
    [Amount] [money] NOT NULL,
    [StatusID] [int] FOREIGN KEY REFERENCES [dbo].[Status](ID),
    [Comment] [varchar](255)
)
GO

CREATE TABLE [dbo].[BBDAllocation](
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [Budget] [money] NOT NULL,
    [DateCreated] [date] DEFAULT GETDATE() ,
)
GO

CREATE TABLE [dbo].[UniversityFundAllocation](
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [Budget] [money],
    [DateAllocated] [date] DEFAULT GETDATE(),
    [UniversityID] [int] FOREIGN KEY REFERENCES [dbo].[University](ID),
    [BBDAllocationID] [int] FOREIGN KEY REFERENCES [dbo].[BBDAllocation](ID)
)
GO



CREATE TABLE [dbo].[User](
    [ID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
    [FirstName] [varchar](120) NOT NULL,
    [LastName] [varchar](120) NOT NULL,
    [Status] [CHAR](8) DEFAULT 'ACTIVE',
    [ContactID] [int] FOREIGN KEY REFERENCES [dbo].[ContactDetails](ID)
)
GO

CREATE TABLE [dbo].[UserRole](
    [UserID] [int] FOREIGN KEY REFERENCES [dbo].[User](ID),
    [RoleID] [int] FOREIGN KEY REFERENCES [dbo].[Role](ID)
)
GO

CREATE TABLE [dbo].[UniversityUser](
    [UniversityID] [int] FOREIGN KEY REFERENCES [dbo].[University](ID),
    [UserID] [int] FOREIGN KEY REFERENCES [dbo].[User](ID),
    [DepartmentID] [int] FOREIGN KEY REFERENCES [dbo].[Departments](DepartmentID) DEFAULT  1
)
GO

CREATE TABLE [dbo].[Gender](
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY,
    [GenderName] [varchar](8) NOT NULL,
)
GO

CREATE TABLE [dbo].[Student] (
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY,
    [IDNumber] [char](13) NOT NULL,
    [BirthDate] [date] NOT NULL,
    [Age] AS (CONVERT(tinyint, DATEDIFF(DAY, [BirthDate], GETDATE()) / 365.25)),
    [GenderID] [INT] FOREIGN KEY REFERENCES [dbo].[Gender](ID),
    [UserID] [int] FOREIGN KEY REFERENCES [dbo].[User](ID),
    [RaceID] [int] FOREIGN KEY REFERENCES [dbo].[Race](ID),
    [DepartmentID] [int] FOREIGN KEY REFERENCES [dbo].[Departments](DepartmentID) DEFAULT  1
)
GO

CREATE TABLE [dbo].[UniversityStudentInformation](
    [UniversityID] [int] FOREIGN KEY REFERENCES [dbo].[University](ID),
    [StudentID] [int] FOREIGN KEY REFERENCES [dbo].[Student](ID),
    [DateCreated] [date] DEFAULT GETDATE(),
)
GO

CREATE TABLE [dbo].[StudentFundRequest] (
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [Grade] [tinyint] NOT NULL,
    [Amount] [money] NOT NULL,
    [CreatedDate] [date] DEFAULT GETDATE(),
    [ModifiedDate] [date] DEFAULT GETDATE(),
    [StatusID] [int] FOREIGN KEY REFERENCES [dbo].[Status]  DEFAULT 3,
    [Comment] [varchar](255) NOT NULL,
    [StudentID] [int] FOREIGN KEY REFERENCES [dbo].[Student](ID),
    [UniversityFundID][int] FOREIGN KEY REFERENCES [dbo].[UniversityFundAllocation](ID),
    CONSTRAINT CHK_GradeGreaterThan80 CHECK (Grade > 80)
)
GO

CREATE TABLE [dbo].[Document](
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY,
    [Document] [varchar](250) NOT NULL,
    CV VARCHAR(250) ,
    IDDocument VARCHAR(250) ,
    Transcript VARCHAR(250) ,
    [RequestID] [int] FOREIGN KEY REFERENCES [dbo].[StudentFundRequest](ID),
)
GO

CREATE TABLE [dbo].[StudentFundAllocation](
    [ID] [int] IDENTITY(1, 1) PRIMARY KEY,
    [Amount] [money] NOT NULL,
    [DateCreated] [date] DEFAULT GETDATE(),
    [UniversityFundID] [int] FOREIGN KEY REFERENCES [dbo].[UniversityFundAllocation](ID),
    [RequestID] [int] FOREIGN KEY REFERENCES [dbo].[StudentFundRequest](ID),
)
GO

SELECT * FROM [dbo].[Status]
SELECT * FROM [dbo].[Departments]
SELECT * FROM [dbo].[Provinces]
SELECT * FROM [dbo].[Race]
SELECT * FROM [dbo].[DocumentType]
SELECT * FROM [dbo].[Role]
SELECT * FROM [dbo].[ContactDetails]
SELECT * FROM [dbo].[University]
SELECT * FROM [dbo].[UniversityFundRequest]
SELECT * FROM [dbo].[BBDAllocation]
SELECT * FROM [dbo].[UniversityFundAllocation]
SELECT * FROM [dbo].[User]
SELECT * FROM [dbo].[UserRole]
SELECT * FROM [dbo].[UniversityUser]
SELECT * FROM [dbo].[Gender]
SELECT * FROM [dbo].[Student]
SELECT * FROM [dbo].[UniversityStudentInformation]
SELECT * FROM [dbo].[StudentFundRequest]
SELECT * FROM [dbo].[Document]
SELECT * FROM [dbo].[StudentFundAllocation]
--insert into [dbo].[UniversityUser] (UniversityID,UserID)values (6,11)
--delete from [dbo].[User] where ID =18
--delete from [dbo].[ContactDetails] where ID =21
--delete from [dbo].[UserRole] where UserID =18

--INSERT INTO  [dbo].[UniversityFundAllocation]  (Budget, UniversityID,BBDAllocationID) VALUES(35000000,3,5) 
--delete from [dbo].[UniversityFundAllocation] where ID = 20
--drop table [dbo].[StudentFundRequest]
--drop table [dbo].[StudentFundAllocation]
--drop table [dbo].[Document]

--delete from  [dbo].[BBDAllocation] 
--DELETE  FROM [dbo].[User] where ID = 14
--insert into [dbo].[UniversityUser] (UniversityID,UserID) VALUES (6,14);
--DELETE FROM [dbo].[ContactDetails] WHERE Email = 'mxsibay022@student.wethinkcode.co.za'
--SELECT * FROM [dbo].[UniversityUser]
--INNER JOIN [dbo].[User] ON [dbo].[User].ID = [dbo].[UniversityUser].UserID
--INNER JOIN ContactDetails ON  ContactDetails.ID = [dbo].[User].ContactID
--INNER JOIN  [dbo].[University] ON [dbo].[UniversityUser].UniversityID = [dbo].[University].ID

--SELECT usr.ID, FirstName, LastName,ContactDetails.ID, PhoneNumber, Email FROM [dbo].[User] as usr INNER JOIN ContactDetails ON ContactDetails.Email='mxsibay022@student.wethinkcode.co.za' AND ContactDetails.ID = usr.ContactID