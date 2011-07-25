CREATE TABLE Event
(
	  EventId INTEGER PRIMARY KEY 
	, Distance INTEGER
	, StrokeName CHAR(10) NOT NULL 
	, CONSTRAINT UQ_Event__Distance_StrokeName_Format UNIQUE ( Distance, StrokeName )
	, CONSTRAINT FK_Event_Stroke FOREIGN KEY ( StrokeName ) REFERENCES Stroke ( Name )
);
go
