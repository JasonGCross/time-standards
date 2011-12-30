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
    UISplitViewController       * splitVC;
    NSManagedObject             * currentSwimmer;
	
@private
	TimeStandardDataAccess		* timeStandardDataAccess_;
    NSManagedObjectContext		* managedObjectContext_;
    NSManagedObjectModel		* managedObjectModel_;
    NSPersistentStoreCoordinator* persistentStoreCoordinator_;
	NSFetchedResultsController	* fetchedResultsController_;
}

@property (nonatomic, retain) IBOutlet	UIWindow					* window;
@property (nonatomic, retain) IBOutlet	UINavigationController		* navigationController;
@property (nonatomic, retain) IBOutlet  UISplitViewController       * splitVC;
@property (nonatomic, retain)           NSManagedObject             * currentSwimmer;
@property (nonatomic, retain, readonly) TimeStandardDataAccess		* timeStandardDataAccess;
@property (nonatomic, retain, readonly) NSManagedObjectContext		* managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel		* managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSFetchedResultsController	* fetchedResultsController;

- (NSManagedObject *)	getHomeScreenValues;
- (NSManagedObject *)	getHomeScreenSwimmer;
- (NSString *)			getHomeScreenTimeStandard;
- (NSURL *)				applicationDocumentsDirectory;
- (void)saveContext;

@end

