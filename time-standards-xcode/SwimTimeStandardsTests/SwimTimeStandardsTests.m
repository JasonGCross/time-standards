//
//  SwimTimeStandardsTests.m
//  SwimTimeStandardsTests
//
//  Created by Jason Cross on 4/17/14.
//
//

#import <XCTest/XCTest.h>
#import "STSTimeStandardDataAccess.h"

@interface SwimTimeStandardsTests : XCTestCase

@end

@implementation SwimTimeStandardsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDataAccessTimeStandardNames {
    STSTimeStandardDataAccess * tsda = [STSTimeStandardDataAccess sharedDataAccess];
    NSArray * standardNames = [tsda getAllTimeStandardNames];
    XCTAssertNotNil(standardNames, @"");
    XCTAssertFalse([standardNames count] == 0, @"");
    NSString * name = [standardNames firstObject];
    XCTAssertFalse([name length] == 0, @"");
}

- (void) testAgeGroupNames {
    STSTimeStandardDataAccess * tsda = [STSTimeStandardDataAccess sharedDataAccess];
    
    NSArray * standardNames = [tsda getAllTimeStandardNames];
    XCTAssertNotNil(standardNames, @"");
    XCTAssertFalse([standardNames count] == 0, @"");
    NSString * standardName = [standardNames firstObject];
    
    NSArray * standardAgeGroups = [tsda getAllAgeGroupNames:standardName];
    XCTAssertNotNil(standardAgeGroups, @"");
    XCTAssertFalse([standardAgeGroups count] == 0, @"");
    NSString * ageGroupName = [standardAgeGroups firstObject];
    XCTAssertFalse([ageGroupName length] == 0, @"");
}

- (void) testTimeStandardContainsAgeGroup {
    STSTimeStandardDataAccess * tsda = [STSTimeStandardDataAccess sharedDataAccess];
    NSArray * standardNames = [tsda getAllTimeStandardNames];
    NSString * standardName = [standardNames firstObject];
    NSArray * standardAgeGroups = [tsda getAllAgeGroupNames:standardName];
    NSString * ageGroupName = [standardAgeGroups firstObject];
    
    BOOL timeStandardContainsAgeGroup = [tsda timeStandard:standardName
                                       doesContainAgeGroup:ageGroupName];
    XCTAssertTrue(timeStandardContainsAgeGroup, @"");
}

- (void) testAllStrokeNamesForStandardName {
    STSTimeStandardDataAccess * tsda = [STSTimeStandardDataAccess sharedDataAccess];
    NSArray * standardNames = [tsda getAllTimeStandardNames];
    NSString * standardName = [standardNames firstObject];
    NSArray * standardAgeGroups = [tsda getAllAgeGroupNames:standardName];
    NSString * ageGroupName = [standardAgeGroups firstObject];
    
    NSArray * strokes = [tsda getAllStrokeNamesForStandardName:standardName
                                                     andGender:nil
                                               andAgeGroupName:ageGroupName];
    XCTAssertNotNil(strokes, @"");
    XCTAssertFalse([strokes count] == 0, @"");
    
}

- (void) testDistanceForStandardName {
    STSTimeStandardDataAccess * tsda = [STSTimeStandardDataAccess sharedDataAccess];
    NSArray * standardNames = [tsda getAllTimeStandardNames];
    NSString * standardName = [standardNames firstObject];
    NSArray * standardAgeGroups = [tsda getAllAgeGroupNames:standardName];
    NSString * ageGroupName = [standardAgeGroups firstObject];
    NSArray * strokes = [tsda getAllStrokeNamesForStandardName:standardName andGender:nil andAgeGroupName:ageGroupName];
    NSString * stroke = [strokes firstObject];
    
    NSDictionary * dict = [[NSDictionary alloc] init];
    NSArray * distances = [tsda getDistancesForStandardName:standardName
                                                  andGender:@"female"
                                            andAgeGroupName:ageGroupName
                                              andStrokeName:stroke
                                                  andFormat:nil putKeysIntoDictionary:&dict];
    
    XCTAssertNotNil(distances, @"");
    XCTAssertNotNil(dict, @"");
    XCTAssertFalse([distances count] == 0, @"");
    NSString * distance = [distances firstObject];
    XCTAssertFalse([distance length] == 0, @"");
}

@end
