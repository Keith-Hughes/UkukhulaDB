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