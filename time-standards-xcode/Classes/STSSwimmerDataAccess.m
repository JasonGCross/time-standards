//
//  STSSwimmerDataAccess.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSSwimmerDataAccess.h"

@interface STSSwimmerDataAccess ()
@property (nonatomic, strong, readwrite) NSManagedObjectContext		* managedObjectContext;
@property (nonatomic, strong, readwrite) NSManagedObjectModel		* managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic, strong, readwrite) NSFetchedResultsController	* fetchedResultsController;
@end



@implementation STSSwimmerDataAccess

#pragma mark - initialization

- (id) init {
    static BOOL alreadyInitialized = NO;
    if (alreadyInitialized) {
        return self;
    }
    alreadyInitialized = YES;
    
    self = [super init];
    if (nil != self) {
        
    }
    return self;
}

+ (STSSwimmerDataAccess *) sharedDataAccess; {
    static dispatch_once_t onceQueue;
    static STSSwimmerDataAccess* _sharedInstance;
    dispatch_once(&onceQueue, ^{ _sharedInstance = [[self alloc] init]; });
    return _sharedInstance;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSFetchedResultsController *) fetchedResultsController {
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}
	NSManagedObjectContext * context = [self managedObjectContext];
	NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
	
	// Configure the request's entity, and optionally its predicate.
	NSSortDescriptor *sortDescriptor = nil;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"swimmerName" ascending:YES];
	NSArray *sortDescriptors = nil;
	sortDescriptors = @[sortDescriptor];
	sortDescriptor = nil;
	[fetchRequest setSortDescriptors:sortDescriptors];
	sortDescriptors = nil;
	NSEntityDescription * entity = [NSEntityDescription entityForName:@"Swimmer"
											   inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:10];
	NSFetchedResultsController * controller = [[NSFetchedResultsController alloc]
											   initWithFetchRequest:fetchRequest
											   managedObjectContext:context
											   sectionNameKeyPath:nil
											   cacheName:@"Swimmer"];
	
	NSError * error = nil;
	BOOL success = [controller performFetch:&error];
	if(!success) {
		NSLog(@"Error fetching request %@", [error localizedDescription]);
	}
	_fetchedResultsController = controller;
	return _fetchedResultsController;
}

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
		homeScreenValue = objects[0];
	}
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
        }
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HomeScreenValues" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HomeScreenValues.sqlite"];
    NSDictionary * dict = @{NSMigratePersistentStoresAutomaticallyOption : [NSNumber numberWithBool:YES]};
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:dict
                                                           error:&error]) {
        NSLog(@"Unresolved error creating Persistent Store Coordinator: %@, %@", error, [error userInfo]);
        UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error loading Swim Time Standards data"
							  message:@"There was an error loading the swim times data. Please quit the application by pressing the Home button."
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
    }
    
    return _persistentStoreCoordinator;
}



@end
