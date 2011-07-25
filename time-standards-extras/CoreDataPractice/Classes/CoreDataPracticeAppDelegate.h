//
//  CoreDataPracticeAppDelegate.h
//  CoreDataPractice
//
//  Created by JASON CROSS on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataPracticeAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;   
	UINavigationController		* navigationController;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
	NSFetchedResultsController *fetchedResultsController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController		* navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSFetchedResultsController *fetchedResultsController;


- (NSManagedObject *) getHomeScreenValues;
- (NSManagedObject *) getHomeScreenObject: (NSString *)relationshipName 
							forEntityName: (NSString *)entityName 
						 withDefaultValue: (NSString *)defaultValue 
						    forDefaultKey: (NSString *)defaultKey;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end

