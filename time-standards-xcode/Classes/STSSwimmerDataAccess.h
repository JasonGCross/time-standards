//
//  STSSwimmerDataAccess.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import <Foundation/Foundation.h>

@class NSManagedObject;
@class NSManagedObjectContext;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;
@class NSFetchedResultsController;

@interface STSSwimmerDataAccess : NSObject 

@property (nonatomic, strong)           NSManagedObject             * currentSwimmer;
@property (nonatomic, strong, readonly) NSManagedObjectContext		* managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel		* managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSFetchedResultsController	* fetchedResultsController;

+ (STSSwimmerDataAccess *) sharedDataAccess;

- (NSManagedObject *)	getHomeScreenValues;
- (NSManagedObject *)	getHomeScreenSwimmer;
- (NSString *)			getHomeScreenTimeStandard;
- (NSURL *)				applicationDocumentsDirectory;
- (void)saveContext;

@end
