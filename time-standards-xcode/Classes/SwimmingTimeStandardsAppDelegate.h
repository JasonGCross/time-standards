//
//  SwimmingTimeStandardsAppDelegate.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class TimeStandardDataAccess;

@interface SwimmingTimeStandardsAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow					* window;
    UINavigationController		* navigationController;
    NSManagedObject             * currentSwimmer;
	
@private
	TimeStandardDataAccess		* timeStandardDataAccess_;
    NSManagedObjectContext		* managedObjectContext_;
    NSManagedObjectModel		* managedObjectModel_;
    NSPersistentStoreCoordinator* persistentStoreCoordinator_;
	NSFetchedResultsController	* fetchedResultsController_;
}

@property (nonatomic, strong) IBOutlet	UIWindow					* window;
@property (nonatomic, strong) IBOutlet	UINavigationController		* navigationController;
@property (nonatomic, strong)           NSManagedObject             * currentSwimmer;
@property (nonatomic, strong, readonly) TimeStandardDataAccess		* timeStandardDataAccess;
@property (nonatomic, strong, readonly) NSManagedObjectContext		* managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel		* managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSFetchedResultsController	* fetchedResultsController;

- (NSManagedObject *)	getHomeScreenValues;
- (NSManagedObject *)	getHomeScreenSwimmer;
- (NSString *)			getHomeScreenTimeStandard;
- (NSURL *)				applicationDocumentsDirectory;
- (void)saveContext;

@end

