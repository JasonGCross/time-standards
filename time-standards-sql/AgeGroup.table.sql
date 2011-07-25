CREATE TABLE AgeGroup
(
	  AgeGroupId INTEGER PRIMARY KEY AUTOINCREMENT
	, AgeGroupNumber INTEGER 
	, Name Varchar(32) NOT NULL
	, CONSTRAINT UQ_AgeGroup_Name UNIQUE ( Name )
	, CONSTRAINT UQ_AgeGroup_AgeGroupNumber UNIQUE ( AgeGroupNumber )
);
GO


