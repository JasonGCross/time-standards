CREATE TABLE Format
(
       Name CHAR(3) NOT NULL PRIMARY KEY
     , Description VARCHAR(64) NULL
);
GO

INSERT INTO Format (Name, Description)
SELECT 'LCM', 'Long Course Meters'
UNION ALL SELECT 'SCM', 'Short Course Meters'
UNION ALL SELECT 'SCY', 'Short Course Yards';
GO
