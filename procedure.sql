USE [UkukhulaDB]
GO

/****** Object:  StoredProcedure [dbo].[CreateStudentFundRequestForNewStudent]    Script Date: 2024/02/19 19:52:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
    @UserId INT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @StudentID INT;
        DECLARE @StatusID INT;
        DECLARE @GenderID INT;
        DECLARE @RaceID INT;

        

        SELECT @GenderID = ID FROM dbo.Gender WHERE GenderName = @GenderName;

        SELECT @RaceID = ID FROM dbo.Race WHERE RaceName = @RaceName;

        INSERT INTO dbo.Student (IDNumber, GenderID, UserID, RaceID, BirthDate)
        VALUES (@IDNumber, @GenderID, @UserId, @RaceID, @BirthDate);
        SET @StudentID = SCOPE_IDENTITY();

        INSERT INTO dbo.UniversityStudentInformation (UniversityID, StudentID)
        VALUES (@UniversityID, @StudentID);

        INSERT INTO dbo.StudentFundRequest (Grade, Amount, StatusID, Comment, StudentID)
        VALUES (@Grade, @Amount, 3, '', @StudentID);

        COMMIT TRANSACTION;
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
            WHEN [Document].[ID] IS NOT NULL THEN 'Received'
            ELSE 'Pending Document'
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
    @UniversityID INT, 
    @Amount DECIMAL(18,2),
    @Comment NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert the new request into the UniversityFundRequest table
    INSERT INTO UniversityFundRequest (UniversityID, Amount, DateCreated, Comment, StatusID)
    VALUES (@UniversityID, @Amount, GETDATE(), @Comment, 3);

    -- Return the inserted data
    SELECT 
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
        University.ID = @UniversityID;
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