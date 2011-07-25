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
GO