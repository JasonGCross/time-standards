SELECT DISTINCT
       EventId
     , Distance
     , StrokeName
     , Format
 FROM  vwTimeStandard 
WHERE
       StandardId = ?
  AND  Gender = ?
  AND  AgeGroupId = ? 
;