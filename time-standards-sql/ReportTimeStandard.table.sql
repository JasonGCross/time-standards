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

