--USE [UkukhulaDB]
--GO

/****** Object:  StoredProcedure [dbo].[CreateStudentFundRequestForNewStudent]    Script Date: 2024/02/19 19:52:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION dbo.fn_GetTotalBudgetForYear(@BBDAllocationID INT, @Year INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @TotalBudget MONEY;

    SELECT @TotalBudget = SUM(Budget)
    FROM UniversityFundAllocation
    WHERE BBDAllocationID = @BBDAllocationID
    AND YEAR(DateAllocated) = @Year;

    RETURN @TotalBudget;
END;
GO

CREATE PROCEDURE [dbo].[CreateStudentFundRequestForNewStudent]
(
    @IDNumber CHAR(13),
    @GenderName VARCHAR(8),
    @RaceName VARCHAR(8),
    @UniversityID INT,
    @BirthDate DATE,
    @Grade TINYINT,
    @Amount MONEY,
    @UserId INT,
    @UniversityFundID INT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @StudentID INT;
        DECLARE @StatusID INT;
        DECLARE @GenderID INT;
        DECLARE @RaceID INT;
        DECLARE @RequestID INT;

        

        SELECT @GenderID = ID FROM dbo.Gender WHERE GenderName = @GenderName;

        SELECT @RaceID = ID FROM dbo.Race WHERE RaceName = @RaceName;

        INSERT INTO dbo.Student (IDNumber, GenderID, UserID, RaceID, BirthDate)
        VALUES (@IDNumber, @GenderID, @UserId, @RaceID, @BirthDate);
        SET @StudentID = SCOPE_IDENTITY();

        INSERT INTO dbo.UniversityStudentInformation (UniversityID, StudentID)
        VALUES (@UniversityID, @StudentID);

        INSERT INTO dbo.StudentFundRequest (Grade, Amount, StatusID, Comment, StudentID,UniversityFundID)
        VALUES (@Grade, @Amount, 3, '', @StudentID,@UniversityFundID);
        SET @RequestID = SCOPE_IDENTITY();

        INSERT INTO dbo.Document (RequestID)
        VALUES (@RequestID); 

        COMMIT TRANSACTION;
        RETURN @RequestID
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
		RETURN 'ERROR FROM PROCEDURE ' + ERROR_MESSAGE();
    END CATCH;
END

GO

CREATE PROCEDURE [dbo].[GetStudentFundRequests]
AS
BEGIN
    SELECT
        [StudentFundRequest].[ID],
        [User].[FirstName],
        [User].[LastName],
        [University].[Name] AS UniversityName,
        [Student].[IDNumber],
        [Student].[BirthDate],
        [Student].[Age],
        [Gender].[GenderName],
        [ContactDetails].[Email],
        [ContactDetails].[PhoneNumber],
        [Race].[RaceName],
        [StudentFundRequest].[Grade],
        [StudentFundRequest].[Amount],
        [StudentFundRequest].[CreatedDate] AS RequestCreatedDate,
        [Status].[Type] AS FundRequestStatus,
        [StudentFundRequest].[Comment],
        CASE
            WHEN [Document].[CV] IS NULL OR UPPER([Document].[CV]) = '0x00000000'
             OR [Document].[Transcript] IS NULL OR UPPER([Document].[Transcript]) = '0x00000000'
             OR [Document].[IDDocument] IS NULL OR UPPER([Document].[IDDocument]) = '0x00000000'
            THEN 'Pending Document'
            ELSE 'Received'
        END AS DocumentStatus
    FROM
        [dbo].[StudentFundRequest]
    INNER JOIN [dbo].[Student] ON [StudentFundRequest].[StudentID] = [Student].[ID]
    INNER JOIN [dbo].[User] ON [Student].[UserID] = [User].[ID]
    INNER JOIN [dbo].[ContactDetails] ON [User].[ContactID] = [ContactDetails].[ID]
    INNER JOIN [dbo].[Gender] ON [Student].[GenderID] = [Gender].[ID]
    INNER JOIN [dbo].[Race] ON [Student].[RaceID] = [Race].[ID]
    INNER JOIN [dbo].[UniversityStudentInformation] ON [StudentFundRequest].[StudentID] = [UniversityStudentInformation].[StudentID]
    INNER JOIN [dbo].[University] ON [UniversityStudentInformation].[UniversityID] = [University].[ID]
    INNER JOIN [dbo].[Status] ON [StudentFundRequest].[StatusID] = [Status].[ID]
    LEFT JOIN [dbo].[Document] ON [StudentFundRequest].[ID] = [Document].[RequestID];
END;

GO


CREATE PROCEDURE [dbo].[usp_NewUniversityFundRequest] 
    @UniversityName VARCHAR (100), 
    @Amount MONEY,
    @FirstName VARCHAR (100),
    @Lastname VARCHAR (100),
    @ContactNumber VARCHAR (100),
    @Email VARCHAR (100),
	@Province VARCHAR (50)
   
AS
BEGIN
    SET NOCOUNT ON;
	
	DECLARE @ContactID INT
	DECLARE @UserID INT
	DECLARE @UniversityID INT

	INSERT INTO [dbo].[ContactDetails](Email,PhoneNumber) VALUES (@Email,@ContactNumber);

	SET @ContactID= SCOPE_IDENTITY();
	
	INSERT INTO [dbo].[User](FirstName,LastName,[Status],ContactID) VALUES (@FirstName,@Lastname,'INACTIVE',@ContactID);

	SET @UserID = SCOPE_IDENTITY();
	INSERT INTO [dbo].[UserRole](UserID,RoleID) VALUES (@UserID,2);

	INSERT INTO [dbo].[University]
	SELECT @UniversityID = ID FROM [dbo].[University] WHERE [Name] = @UniversityName 
    -- Insert the new request into the UniversityFundRequest table
    INSERT INTO UniversityFundRequest (UniversityID, DateCreated, Amount, StatusID, Comment)
    VALUES (@UniversityID, GETDATE(),@Amount, 3,'');
	DECLARE @RequestID INT;
	SET @RequestID = SCOPE_IDENTITY();
    -- Return the inserted data
 --   SELECT 
	--@RequestID AS RequestID,
 --       University.[Name] AS University, 
 --       Provinces.ProvinceName AS Province, 
 --       UniversityFundRequest.Amount,
 --       [dbo].[Status].[Type] AS [Status],
 --       UniversityFundRequest.DateCreated,
 --       UniversityFundRequest.Comment
 --   FROM 
 --       University 
 --   INNER JOIN 
 --       UniversityFundRequest ON University.ID = UniversityFundRequest.UniversityID
 --   INNER JOIN 
 --       Provinces ON University.ProvinceID = Provinces.ID
 --   INNER JOIN 
 --       [dbo].[Status] ON UniversityFundRequest.StatusID = [dbo].[Status].ID
 --   WHERE 
 --       University.ID = @UniversityID;
END;

GO



CREATE PROCEDURE [dbo].[usp_UpdateUniversityFundRequest] 
	@RequestID INT,  
	@StatusID INT
    AS
    BEGIN
    SET NOCOUNT ON;

		UPDATE UniversityFundRequest
		SET StatusID = @StatusID
		WHERE ID = @RequestID;

		SELECT 
			UniversityFundRequest.[ID] AS RequestID,
			University.[Name] AS University, 
			Provinces.ProvinceName AS Province, 
			UniversityFundRequest.Amount,
			[dbo].[Status].[Type] AS [Status],
			UniversityFundRequest.DateCreated,
			UniversityFundRequest.Comment
		FROM 
			University 
		INNER JOIN 
			UniversityFundRequest ON University.ID = UniversityFundRequest.UniversityID
		INNER JOIN 
			Provinces ON University.ProvinceID = Provinces.ID
		INNER JOIN 
			[dbo].[Status] ON UniversityFundRequest.StatusID = [dbo].[Status].ID
		WHERE 
			UniversityFundRequest.ID = @RequestID;
	END;
GO


CREATE PROCEDURE [dbo].[GetStudentFundRequestsByUniversity]
@UniversitID INT
AS
BEGIN
    SELECT
        [StudentFundRequest].[ID],
        [User].[FirstName],
        [User].[LastName],
        [University].[Name] AS UniversityName,
        [Student].[IDNumber],
        [Student].[BirthDate],
        [Student].[Age],
        [Gender].[GenderName],
        [ContactDetails].[Email],
        [ContactDetails].[PhoneNumber],
        [Race].[RaceName],
        [StudentFundRequest].[Grade],
        [StudentFundRequest].[Amount],
        [StudentFundRequest].[CreatedDate] AS RequestCreatedDate,
        [Status].[Type] AS FundRequestStatus,
        [StudentFundRequest].[Comment],
        CASE
            WHEN [Document].[CV] IS NULL OR UPPER([Document].[CV]) = '0x00000000'
             OR [Document].[Transcript] IS NULL OR UPPER([Document].[Transcript]) = '0x00000000'
             OR [Document].[IDDocument] IS NULL OR UPPER([Document].[IDDocument]) = '0x00000000'
        THEN 'Pending Document'
        ELSE 'Received'
        END AS DocumentStatus
    FROM
        [dbo].[StudentFundRequest]
    INNER JOIN [dbo].[Student] ON [StudentFundRequest].[StudentID] = [Student].[ID]
    INNER JOIN [dbo].[User] ON [Student].[UserID] = [User].[ID]
    INNER JOIN [dbo].[ContactDetails] ON [User].[ContactID] = [ContactDetails].[ID]
    INNER JOIN [dbo].[Gender] ON [Student].[GenderID] = [Gender].[ID]
    INNER JOIN [dbo].[Race] ON [Student].[RaceID] = [Race].[ID]
    INNER JOIN [dbo].[UniversityStudentInformation] ON [StudentFundRequest].[StudentID] = [UniversityStudentInformation].[StudentID]
    INNER JOIN [dbo].[University] ON [UniversityStudentInformation].[UniversityID] = [University].[ID]
    INNER JOIN [dbo].[Status] ON [StudentFundRequest].[StatusID] = [Status].[ID]
    LEFT JOIN [dbo].[Document] ON [StudentFundRequest].[ID] = [Document].[RequestID]
	WHERE [University].[ID] = @UniversitID
END;

GO


CREATE PROCEDURE [dbo].[allocateAUniversity]
@RequestID int,
@Amount money
AS
BEGIN
DECLARE @UniversityID int
DECLARE @BBDAllocationID int

SELECT  @UniversityID =   UniversityID FROM [dbo].[UniversityFundRequest]  WHERE ID = @RequestID
SELECT  @BBDAllocationID =   ID FROM [dbo].[BBDAllocation] WHERE YEAR(DateCreated) = Year(GETDATE())
UPDATE [dbo].[UniversityFundRequest]
SET Amount = @Amount WHERE ID = @RequestID
UPDATE [dbo].[UniversityFundRequest]
SET StatusID = 1 WHERE ID = @RequestID


INSERT INTO [dbo].[UniversityFundAllocation](Budget,UniversityID,BBDAllocationID) VALUES (@Amount,@UniversityID,@BBDAllocationID)
END
GO

--EXEC [dbo].[allocateAUniversity] 54, 120000

CREATE PROCEDURE [dbo].[ResetAllocations]
AS
BEGIN
 DELETE FROM [dbo].[StudentFundAllocation]
    WHERE YEAR(DateCreated) = YEAR(GETDATE())


    DELETE FROM [dbo].[StudentFundRequest]
    WHERE YEAR(CreatedDate) = YEAR(GETDATE())

    DELETE FROM [dbo].[UniversityFundAllocation]
    FROM [dbo].[UniversityFundAllocation]
    LEFT JOIN [dbo].[StudentFundRequest] ON [dbo].[UniversityFundAllocation].[ID] = [dbo].[StudentFundRequest].[UniversityFundID]
    WHERE YEAR([dbo].[UniversityFundAllocation].DateAllocated) = YEAR(GETDATE())

END
GO


EXEC [dbo].[ResetAllocations]
