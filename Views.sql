CREATE VIEW [dbo].[vw_UniversityRequests] AS

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
GO

CREATE VIEW [dbo].[GetAllUsers] AS

SELECT [dbo].[University].[Name] , FirstName,LastName,PhoneNumber,Email,[dbo].[User].[Status] 

FROM [dbo].[User] 
INNER JOIN [dbo].[ContactDetails] ON [dbo].[ContactDetails].[ID] = [dbo].[User].[ContactID]
INNER JOIN [dbo].[UniversityUser] ON [dbo].[UniversityUser].[UserID] = [dbo].[User].[ID]
INNER JOIN [dbo].[University] ON [dbo].[UniversityUser].[UniversityID] = [dbo].[University].[ID]

GO

CREATE VIEW [dbo].[vw_getMoneySpent]
AS
SELECT SUM(UFA.Budget) AS MoneySpent
FROM [dbo].[UniversityFundAllocation] UFA
INNER JOIN [dbo].[BBDAllocation] BBD ON UFA.BBDAllocationID = BBD.ID
WHERE YEAR(UFA.DateAllocated) = YEAR(GETDATE()) 

