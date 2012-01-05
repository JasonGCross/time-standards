//
//  SwimmingTimeStandardsAppDelegate.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SwimmingTimeStandardsAppDelegate.h"
#import "TimeStandardDataAccess.h"


@interface SwimmingTimeStandardsAppDelegate (STSAppDelegatePrivate) 
- (NSURL *)applicationDocumentsDirectory;
- (NSString *) getHomeScreenTimeStandard;
@end


@implementation SwimmingTimeStandardsAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize currentSwimmer;

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    [self.window makeKeyAndVisible];
    return YES;
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
	if (timeStandardDataAccess_ != nil) {
		[timeStandardDataAccess_ closeDataBase];
	}
}


#pragma mark - private methods
#pragma mark Time Standard Data Access

/**
 Returns the time standard data access object for the application.
 If the data access object doesn't already exist, it is created and hooked up to the data file.
 */
- (TimeStandardDataAccess *) timeStandardDataAccess; {
	if (timeStandardDataAccess_ != nil) {
		return timeStandardDataAccess_;
	}
	timeStandardDataAccess_  = [[TimeStandardDataAccess alloc] init];
	[timeStandardDataAccess_ openDataBase];
	return timeStandardDataAccess_;
}

#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - public methods

- (NSManagedObject *) getHomeScreenValues {
	NSManagedObject *homeScreenValue = nil;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"HomeScreenValues"
								   inManagedObjectContext:[self managedObjectContext]]];
	NSError *error = nil;
	NSArray *objects = [[self managedObjectContext] executeFetchRequest: request error:&error];

	if(error) {
		NSLog(@"Error fetching request %@", [error localizedDescription]);
	}
	if ([objects count] > 0) {
		homeScreenValue = [objects objectAtIndex:0];
	}
	[request release];
  return homeScreenValue;
}

- (NSManagedObject *) getHomeScreenSwimmer {
	NSManagedObject * swimmer = nil;
	NSManagedObject * homeScreenValue = [self getHomeScreenValues];
	
	if (homeScreenValue == nil) {
		homeScreenValue = [NSEntityDescription insertNewObjectForEntityForName:@"HomeScreenValues" 
														inManagedObjectContext:[self managedObjectContext]];
		swimmer = [NSEntityDescription insertNewObjectForEntityForName:@"Swimmer" 
												inManagedObjectContext:[self managedObjectContext]];
		[swimmer setValue:@"name this swimmer" forKey:@"swimmerName"];
		[homeScreenValue setValue:swimmer forKey:@"homeScreenSwimmer"];
	}
	else {
		swimmer = [homeScreenValue valueForKey:@"homeScreenSwimmer"];
	}
	
	NSError *error2;
	[[self managedObjectContext] save:&error2];
	return swimmer;
}

- (NSManagedObject *) currentSwimmer {
    NSManagedObject * swimmer = nil;
	NSManagedObject * homeScreenValue = [self getHomeScreenValues];
	
	if (homeScreenValue == nil) {
		homeScreenValue = [NSEntityDescription insertNewObjectForEntityForName:@"HomeScreenValues" 
														inManagedObjectContext:[self managedObjectContext]];
		swimmer = [NSEntityDescription insertNewObjectForEntityForName:@"Swimmer" 
												inManagedObjectContext:[self managedObjectContext]];
		[swimmer setValue:@"name this swimmer" forKey:@"swimmerName"];
		[homeScreenValue setValue:swimmer forKey:@"currentSwimmer"];
	}
	else {
		swimmer = [homeScreenValue valueForKey:@"currentSwimmer"];
	}
	
	NSError *error2;
	[[self managedObjectContext] save:&error2];
	return swimmer;

}

- (NSString *) getHomeScreenTimeStandard {
	NSString * timeStandardName = @"";
	NSManagedObject * homeScreenValue = [self getHomeScreenValues];

	if (homeScreenValue != nil) {
		timeStandardName = [homeScreenValue valueForKey:@"homeScreenStandardName"];
	}
	return timeStandardName;
}

- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error while attempting to save Core Data context: %@, %@", error, [error userInfo]);
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Error saving Swim Time Standards data"
								  message:@"There was an error saving the Swim Times app data. Please quit the application by pressing the Home button."
								  delegate:nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
        } 
    }
}    


#pragma mark Core Data stack

- (NSFetchedResultsController *) fetchedResultsController {
	if (fetchedResultsController_ != nil) {
		return fetchedResultsController_;
	}
	NSManagedObjectContext * context = [self managedObjectContext];
	NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
	
	// Configure the request's entity, and optionally its predicate.
	NSSortDescriptor *sortDescriptor = nil;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"swimmerName" ascending:YES];
	NSArray *sortDescriptors = nil;
	sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[sortDescriptor release], sortDescriptor = nil;
	[fetchRequest setSortDescriptors:sortDescriptors];
	[sortDescriptors release], sortDescriptors = nil;
	NSEntityDescription * entity = [NSEntityDescription entityForName:@"Swimmer" 
											   inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:10];
	NSFetchedResultsController * controller = [[NSFetchedResultsController alloc]
											   initWithFetchRequest:fetchRequest
											   managedObjectContext:context
											   sectionNameKeyPath:nil
											   cacheName:@"Swimmer"];
	[fetchRequest release];
	
	NSError * error = nil;
	BOOL success = [controller performFetch:&error];
	if(!success) {
		NSLog(@"Error fetching request %@", [error localizedDescription]);
	}
	fetchedResultsController_ = controller;
	return fetchedResultsController_;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HomeScreenValues" 
//                                              withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel_;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:STSPersistentStoreFileName];
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:YES], 
                              NSMigratePersistentStoresAutomaticallyOption, 
                              nil];
    
    NSError *error = nil;
    NSManagedObjectModel * managedObjectModel = [self managedObjectModel];
    if (nil == managedObjectModel) {
        NSLog(@"The managed object model is null");
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error loading Swim Time Standards data"
							  message:@"There was an error loading the swim times data. Please quit the application by pressing the Home button."
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
        exit(1);
    }
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType 
                                                   configuration:nil 
                                                             URL:storeURL 
                                                         options:options 
                                                           error:&error]) {
        NSLog(@"Unresolved error creating Persistent Store Coordinator: %@, %@", error, [error userInfo]);
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error loading Swim Time Standards data"
							  message:@"There was an error loading the swim times data. Please quit the application by pressing the Home button."
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
        exit(1);
    }    
    
    return persistentStoreCoordinator_;
}

#pragma mark - Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	[timeStandardDataAccess_ closeDataBase];
	[timeStandardDataAccess_ release], timeStandardDataAccess_ = nil;
	[fetchedResultsController_ release], fetchedResultsController_ = nil;
	[managedObjectContext_ release], managedObjectContext_ = nil;
    [managedObjectModel_ release], managedObjectModel_ = nil;
    [persistentStoreCoordinator_ release], persistentStoreCoordinator_ = nil;
}


- (void)dealloc {
	[timeStandardDataAccess_ release];
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
	[fetchedResultsController_ release];
    [window release];
	[navigationController release];
    [super dealloc];
}



@end

