-- queries for SwimTimes.sqlite

--getTimeStandardNames
SELECT DISTINCT standardId, StandardFriendly from vwTimeStandard


--getAgeGroupNames
SELECT DISTINCT AgeGroupID, AgeGroupName          
FROM  vwTimeStandard
WHERE StandardName = 'PNS Silver'
GROUP BY AgeGroupName
ORDER BY AgeGroupId;
		
--	- (BOOL) timeStandard: (NSString *) timeStandardName 
--	  doesContainAgeGroup: (NSString *) ageGroupName {		
-- (returns true if the query retuns at least one row)	
SELECT DISTINCT AgeGroupID, AgeGroupName
FROM  vwTimeStandard 
WHERE StandardName = '2014 PNS Gold'
AND AgeGroupName = '10 & Under'
ORDER BY AgeGroupId;
		
--	- (NSArray *) getAllStrokeNamesForStandardName: (NSString *) standardName 
--										 andGender: (NSString *) gender
--								   andAgeGroupName: (NSString *) ageGroupName {
SELECT DISTINCT StrokeName         
FROM  vwTimeStandard
WHERE StandardName = '2014 PNS Gold'
AND  Gender = 'M'
AND  AgeGroupName = '10 & Under'
ORDER BY EventId;

-- distance
SELECT DISTINCT EventId, Distance, StandardId
FROM  vwTimeStandard
WHERE StandardName = '2014 PNS Gold'
AND Gender = 'F'
AND AgeGroupName = '10 & Under'
AND StrokeName = 'Free'
ORDER BY Distance;






						
--					- (NSArray *) getStrokeNamesForStandardName: (NSString *) standardName 
--													  andGender: (NSString *) gender 
--												andAgeGroupName: (NSString *) ageGroupName 
--													andDistance: (NSString *) distance 
--													  andFormat: (NSString *) format {
--

SELECT EventId ,StrokeName
FROM  ReportTimeStandard
WHERE StandardName = 'PNS Silver'
AND  Gender = 'M'
AND  AgeGroupName = '15 & Over'
AND  Distance = '100'
AND Format = 'SCY'
ORDER BY EventId

						
						
--					- (NSArray *) getDistancesForStandardName: (NSString *) standardName
--													andGender: (NSString *) gender
--											  andAgeGroupName: (NSString *) ageGroupName
--												andStrokeName: (NSString *) strokeName
--													andFormat: (NSString *) format {


SELECT DISTINCT EventId, Distance, KeyID
FROM  ReportTimeStandard
WHERE StandardName = 'PNS Silver'
AND Gender = 'M'
AND AgeGroupName = '15 & Over'
AND StrokeName = 'Free'
AND Format = 'SCY'
ORDER BY Distance;

				
				
--			- (NSArray *) getFormatForStandardName: (NSString *) standardName
--										 andGender: (NSString *) gender
--								   andAgeGroupName: (NSString *) ageGroupName
--									   andDistance: (NSString *) distance
--									 andStrokeName: (NSString *) strokeName {

SELECT EventId, Format
FROM  ReportTimeStandard
WHERE StandardName = 'PNS Silver'
AND Gender = 'M'
AND AgeGroupName = '13-14'
AND Distance = '100'
AND StrokeName = 'Free'
ORDER BY Format

SELECT DISTINCT EventId, Format
FROM  ReportTimeStandard
WHERE StandardName = 'PNS Silver'
AND Gender = 'M'
AND AgeGroupName = '13-14'
GROUP BY Format
ORDER BY Format DESC
				
--			- (NSString *) getTimeForStandardName:(NSString *) standardName
--										andGender: (NSString *) gender
--								  andAgeGroupName: (NSString *) ageGroupName
--									  andDistance: (NSString *) distance
--									andStrokeName: (NSString *) strokeName
--										andFormat: (NSString *) format {
NSString * query = [[NSString alloc] initWithFormat:
						@"SELECT DISTINCT EventId ,Time\n"
						"FROM  vwTimeStandard\n"
						"WHERE StandardName = '%@'\n"
						"AND  Gender = '%@'\n"
						"AND  AgeGroupName = '%@'\n"
						"AND  Distance = %@\n"
						@"AND StrokeName = '%@'\n"
						"AND  Format = '%@'\n"
						"GROUP BY StrokeName\n"
						"ORDER BY EventId\n"
						";", standardName, convertedGender, ageGroupName, distance, strokeName, format];

SELECT EventId ,Time, KeyId
FROM  ReportTimeStandard
WHERE StandardFriendly = 'Western Zone 2011'
AND Gender = 'M'
AND AgeGroupName = '11-12'
AND KeyId = 2056;


