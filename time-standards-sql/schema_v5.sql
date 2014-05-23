CREATE TABLE AgeGroup
(
	 AgeGroupId INTEGER PRIMARY KEY
	,Name Varchar(32) NOT NULL
	,CONSTRAINT UQ_AgeGroup UNIQUE (Name)
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
       Name CHAR(10) NOT NULL PRIMARY KEY
     , Description VARCHAR(32) NULL
);
CREATE TABLE Swimmer
(
	  Name VARCHAR(100) PRIMARY KEY
	, Gender CHAR(1) CHECK ( Gender IN ( 'M', 'F' ) )
	, AgeGroupId INTEGER REFERENCES AgeGroup ( AgeGroupId )	
);
CREATE TABLE TimeStandard
(
	  StandardId INTEGER NOT NULL
	, EventId INTEGER NOT NULL
	, AgeGroupId INTEGER NOT NULL
	, Gender CHAR(1) NOT NULL
	, Format CHAR(3) NOT NULL
	, Time VARCHAR(32) NULL
	, CONSTRAINT PK_TimeStandard PRIMARY KEY 
	(
		  StandardId 
		, EventId 
		, AgeGroupId
		, Gender
		, Format
	)	
	, CONSTRAINT FK_TimeStandard_Event FOREIGN KEY ( EventId ) REFERENCES Event ( EventId )
	, CONSTRAINT FK_TimeStandard_StandardId FOREIGN KEY ( StandardId) REFERENCES Standard ( StandardId )
	, CONSTRAINT FK_TimeStandard_AgeGroupId FOREIGN KEY ( AgeGroupId ) REFERENCES AgeGroup ( AgeGroupId )
	, CONSTRAINT FK_TimeStandard_Format FOREIGN KEY ( Format ) REFERENCES Format ( Name )
	, CONSTRAINT CK_TimeStandard_Gender CHECK ( Gender IN ('M', 'F'))
);
CREATE TABLE foo (x char(1) check (x IN (1,2)));
CREATE VIEW vwTimeStandard AS
SELECT DISTINCT
       e.EventId
     , e.Distance
     , e.StrokeName
     , s.StandardId
     , ts.Gender
     , s.Name AS StandardName
     , s.Date AS StandardDate
     , a.AgeGroupId
     , a.Name AS AgeGroupName
     , f.Name AS Format
     , ts.Time
FROM TimeStandard AS ts
JOIN Event AS e 
  ON e.EventId = ts.EventId
JOIN Standard AS s
  ON s.StandardId = ts.StandardId
JOIN AgeGroup AS a
  ON a.AgeGroupId = ts.AgeGroupId
JOIN Format AS f
  ON f.Name = ts.Format;