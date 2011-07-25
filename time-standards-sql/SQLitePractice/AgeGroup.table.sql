CREATE TABLE AgeGroup
(
	 AgeGroupId INTEGER PRIMARY KEY
	,Name Varchar(32) NOT NULL
	,CONSTRAINT UQ_AgeGroup UNIQUE (Name)
);
GO


