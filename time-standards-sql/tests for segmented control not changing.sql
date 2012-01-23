SELECT DISTINCT EventId, Distance, KeyId
FROM  ReportTimeStandard
WHERE StandardFriendly = 'PNS Gold 2010-2011'
AND Gender = 'M'
AND AgeGroupName = '11-12'
AND StrokeName = 'Free'
AND Format = 'SCY'
ORDER BY Distance;

/*
2|50|2008
3|100|2022
4|200|2036
6|500|2054
8|1000|2064
10|1650|2072
*/

SELECT EventId ,Time
FROM  ReportTimeStandard
WHERE keyId = 2008
ORDER BY EventId;

/*
2|33.59
*/


SELECT DISTINCT EventId, Distance, KeyId
FROM  ReportTimeStandard
WHERE StandardFriendly = 'PNS Gold 2010-2011'
AND Gender = 'M'
AND AgeGroupName = '11-12'
AND StrokeName = 'Free'
AND Format = 'LCM'
ORDER BY Distance;

/*
2|50|2007
3|100|2021
4|200|2035
5|400|2046
8|1000|2063
9|1500|2068
*/

SELECT EventId ,Time
FROM  ReportTimeStandard
WHERE keyId = 2007
ORDER BY EventId;

/*
2|38.29
*/