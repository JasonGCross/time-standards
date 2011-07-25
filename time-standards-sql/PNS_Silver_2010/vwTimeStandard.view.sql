CREATE VIEW vwTimeStandard AS
SELECT DISTINCT
       e.EventId
     , e.Distance
     , k.StrokeID
     , e.StrokeName
     , s.StandardId
     , ts.Gender
     , s.Name AS StandardName
     , s.Name + ' ' + s.Date AS StandardFriendly
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
ORDER BY a.AgeGroupNumber
;