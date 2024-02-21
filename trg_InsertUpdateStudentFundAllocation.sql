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