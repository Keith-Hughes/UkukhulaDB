CREATE VIEW [dbo].[vw_UniversityRequests] AS

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

GO
