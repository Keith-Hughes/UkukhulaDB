INSERT INTO
    [dbo].[Provinces] ([ProvinceName])
VALUES
    ('Limpopo'),
    ('Gauteng'),
    ('Mpumalanga'),
    ('KwaZulu-Natal'),
    ('North West'),
    ('Western Cape'),
    ('Free State'),
    ('Eastern Cape'),
    ('Northern Cape');


INSERT INTO
    [dbo].[Role] ([RoleType])
VALUES
    ('BBD Admin'),
    ('University Admin'),
    ('Student');
GO

INSERT INTO
    [dbo].[Race] ([RaceName])
VALUES
    ('Black'),
    ('Coloured'),
    ('Indian');
GO

INSERT INTO
    [dbo].[Status] ([Type])
VALUES
    ('Approved'),
    ('Rejected'),
    ('Review');
GO

INSERT INTO
    [dbo].[Gender] ([GenderName])
VALUES
    ('Male'),
    ('Female'),
    ('Other');
GO

INSERT INTO
    [dbo].[DocumentType] ([Type])
VALUES
    ('CV'),
    ('Transcript'),
    ('Motivation'),
    ('ID');
GO