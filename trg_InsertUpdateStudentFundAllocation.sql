CREATE TRIGGER trg_InsertUpdateStudentFundAllocation
ON dbo.StudentFundRequest
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.StudentFundAllocation (Amount, UniversityFundID, RequestID)
    SELECT TOP 1 INSERTED.Amount, dbo.UniversityFundAllocation.ID, INSERTED.ID
    FROM INSERTED
    JOIN dbo.UniversityStudentInformation ON INSERTED.StudentID = dbo.UniversityStudentInformation.StudentID
    JOIN dbo.UniversityFundAllocation ON dbo.UniversityStudentInformation.UniversityID = dbo.UniversityFundAllocation.UniversityID
    WHERE INSERTED.StatusID = 1 AND YEAR(INSERTED.CreatedDate) = YEAR(UniversityFundAllocation.DateAllocated);
END;
GO

CREATE TRIGGER trg_CheckBudgetAllocation
ON UniversityFundAllocation
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @BBDAllocationID INT, @Year INT, @TotalBudget MONEY, @AllocatedBudget MONEY;
    
    -- Get the inserted/updated BBDAllocationID and Year
    SELECT @BBDAllocationID = BBDAllocationID, @Year = YEAR(DateAllocated)
    FROM inserted;

    -- Calculate the total budget for the given BBDAllocationID and Year
    SELECT @TotalBudget = SUM(Budget)
    FROM UniversityFundAllocation
    WHERE BBDAllocationID = @BBDAllocationID
    AND YEAR(DateAllocated) = @Year;

    -- Get the allocated budget from BBDAllocation table
    SELECT @AllocatedBudget = Budget
    FROM BBDAllocation
    WHERE ID = @BBDAllocationID;

    -- Check if the total budget exceeds the allocated budget
    IF @TotalBudget > @AllocatedBudget
    BEGIN
        RAISERROR ('Total budget exceeds the allocated budget for the year.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

GO

CREATE TRIGGER trg_InsertStudentFundAllocation
ON [dbo].[StudentFundRequest]
AFTER UPDATE
AS
BEGIN
    IF UPDATE(StatusID)
    BEGIN
        INSERT INTO [dbo].[StudentFundAllocation] (Amount, UniversityFundID, RequestID)
        SELECT
            sfr.Amount,
            sfr.UniversityFundID,
            sfr.ID
        FROM
            inserted AS sfr
            INNER JOIN [dbo].[UniversityFundAllocation] AS ufa ON sfr.UniversityFundID = ufa.ID

        WHERE
            sfr.StatusID = 1
            AND NOT EXISTS (
                SELECT 1
                FROM [dbo].[StudentFundAllocation] AS sfa
                WHERE sfa.RequestID = sfr.ID
            );
    END
END;

GO

CREATE TRIGGER trg_UniversityFundAllocation_Insert
ON [dbo].[UniversityFundAllocation]
AFTER INSERT
AS
BEGIN
    DECLARE @AllocationYear INT
    SELECT @AllocationYear = YEAR([DateAllocated]) FROM inserted
    
    IF @AllocationYear = YEAR(GETDATE())
    BEGIN
        UPDATE u
        SET u.[Status] = 'ACTIVE'
        FROM [dbo].[University] u
        INNER JOIN inserted i ON u.ID = i.UniversityID;
    END
END;
GO



CREATE TRIGGER trg_CheckUniversityFundAllocation
ON [dbo].[StudentFundRequest]
AFTER INSERT, UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) > 0
    BEGIN
        DECLARE @UniversityFundID INT;
        DECLARE @TotalRequestedMoney MONEY;
        DECLARE @RemainingBudget MONEY;

        SELECT @UniversityFundID = i.UniversityFundID
        FROM inserted i;

        SELECT @TotalRequestedMoney = SUM(sr.Amount)
        FROM inserted sr
        WHERE sr.UniversityFundID = @UniversityFundID;

        SELECT @RemainingBudget = Budget - ISNULL((SELECT SUM(sr.Amount) 
                                                    FROM [dbo].[StudentFundRequest] sr
                                                    WHERE sr.UniversityFundID = @UniversityFundID
                                                      AND sr.StatusID = 1
                                                      AND sr.ID NOT IN (SELECT ID FROM deleted)
                                                  ), 0)
        FROM [dbo].[UniversityFundAllocation]
        WHERE ID = @UniversityFundID;

       
      
        IF @TotalRequestedMoney > @RemainingBudget
        BEGIN
            RAISERROR ('Insufficient funds in UniversityFundAllocation for UniversityFundID %d.', 16, 1, @UniversityFundID);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
     
    END;
END;