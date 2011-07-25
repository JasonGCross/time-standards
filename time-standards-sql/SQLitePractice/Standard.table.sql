CREATE TABLE Standard
(
	  StandardId INTEGER PRIMARY KEY 
	, Name VARCHAR(64) NOT NULL
	, Date VARCHAR(32) NOT NULL
	, Description VARCHAR(256) NULL
	, CONSTRAINT UQ_Standard UNIQUE ( Name )
);
GO
