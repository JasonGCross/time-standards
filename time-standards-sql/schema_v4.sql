CREATE TABLE AgeGroup
(
	  AgeGroupId INTEGER PRIMARY KEY AUTOINCREMENT
	, AgeGroupNumber INTEGER 
	, Name Varchar(32) NOT NULL
	, CONSTRAINT UQ_AgeGroup_Name UNIQUE ( Name )
	, CONSTRAINT UQ_AgeGroup_AgeGroupNumber UNIQUE ( AgeGroupNumber )
);
CREATE TABLE Event
(
	  EventId INTEGER PRIMARY KEY 
	, Distance INTEGER
	, StrokeName CHAR(10) NOT NULL 
	, CONSTRAINT UQ_Event__Distance_StrokeName_Format UNIQUE ( Distance, StrokeName )
	, CONSTRAINT FK_Event_Stroke FOREIGN KEY ( StrokeName ) REFERENCES Stroke ( Name )
);
CREATE TABLE Format
(
       Name CHAR(3) NOT NULL PRIMARY KEY
     , Description VARCHAR(64) NULL
);
CREATE TABLE Standard
(
	  StandardId INTEGER PRIMARY KEY 
	, Name VARCHAR(64) NOT NULL
	, Date VARCHAR(32) NOT NULL
	, Description VARCHAR(256) NULL
	, CONSTRAINT UQ_Standard UNIQUE ( Name )
);
CREATE TABLE Stroke
(
       StrokeID INT NOT NULL PRIMARY KEY
     , Name CHAR(10) NOT NULL UNIQUE
     , Description VARCHAR(32) NULL
);
CREATE TABLE TimeStandard
(
	  StandardId INTEGER NOT NULL
	, EventId INTEGER NOT NULL
	, AgeGroupNumber INTEGER NOT NULL
	, Gender CHAR(1) NOT NULL
	, Format CHAR(3) NOT NULL
	, Time VARCHAR(32) NOT NULL
	, CONSTRAINT PK_TimeStandard PRIMARY KEY 
	(
		  StandardId 
		, EventId 
		, AgeGroupNumber 
		, Gender
		, Format
	)	
	, CONSTRAINT FK_TimeStandard_Event FOREIGN KEY ( EventId ) REFERENCES Event ( EventId )
	, CONSTRAINT FK_TimeStandard_StandardId FOREIGN KEY ( StandardId) REFERENCES Standard ( StandardId )
	, CONSTRAINT FK_TimeStandard_AgeGroupNumber FOREIGN KEY ( AgeGroupNumber ) REFERENCES AgeGroup ( AgeGroupNumber )
	, CONSTRAINT FK_TimeStandard_Format FOREIGN KEY ( Format ) REFERENCES Format ( Name )
	, CONSTRAINT CK_TimeStandard_Gender CHECK ( Gender IN ('M', 'F'))
);
CREATE VIEW vwTimeStandard AS
SELECT DISTINCT
       e.EventId
     , e.Distance
     , k.StrokeID
     , e.StrokeName
     , s.StandardId
     , ts.Gender
     , s.Name AS StandardName
     , s.Name || ' ' || s.Date AS StandardFriendly
     , s.Date AS StandardDate
     , a.AgeGroupId
     , a.Name AS AgeGroupName
     , a.AgeGroupNumber
     , f.Name AS Format
     , ts.Time
FROM TimeStandard AS ts
JOIN Event AS e 
  ON e.EventId = ts.EventId
JOIN Stroke k
  ON k.Name = e.StrokeName
JOIN Standard AS s
  ON s.StandardId = ts.StandardId
JOIN AgeGroup AS a
  ON a.AgeGroupNumber = ts.AgeGroupNumber 
JOIN Format AS f
  ON f.Name = ts.Format
ORDER BY a.AgeGroupNumber;
CREATE TABLE ReportTimeStandard
(
EventId INTEGER NOT NULL
, Distance INTEGER NULL
, StrokeID INTEGER NOT NULL
, StrokeName char(10) NOT NULL
, StandardId INTEGER NOT NULL
, Gender char(1) NOT NULL
, StandardName varchar(64) NOT NULL
, StandardFriendly varchar(97) NOT NULL
, StandardDate varchar(32) NOT NULL
, AgeGroupId INTEGER NOT NULL
, AgeGroupName varchar(32) NOT NULL
, AgeGroupNumber INTEGER NULL
, Format char(3) NOT NULL
, Time varchar(32) NOT NULL
, KeyID integer PRIMARY KEY AUTOINCREMENT
, CONSTRAINT UQ_ReportTimeStandard UNIQUE 
(
StandardFriendly
, Gender 
, AgeGroupName 
, Distance 
, StrokeName
, Format
)
);