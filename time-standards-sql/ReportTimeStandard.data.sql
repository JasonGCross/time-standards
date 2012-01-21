DELETE FROM ReportTimeStandard;

INSERT INTO ReportTimeStandard
(
       EventId 
     , Distance
     , StrokeID
     , StrokeName
     , StandardId
     , Gender 
     , StandardName
     , StandardFriendly 
     , StandardDate 
     , AgeGroupId 
     , AgeGroupName 
     , AgeGroupNumber
     , Format 
     , Time 
)
SELECT * FROM vwTimeStandard;

