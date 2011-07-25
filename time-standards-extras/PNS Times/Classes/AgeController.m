//
//  AgeCategoryController.m
//  PNS Times
//
//  Created by JASON CROSS on 7/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AgeController.h"
#import "TimeStandardDataAccess.h"
#import "PNS_TimesAppDelegate.h"

@implementation AgeController

@synthesize timeStandardName;

- (void) setSettingName:(NSString *) value {
	if ([[value lowercaseString] isEqualToString: @"age group"]) {
		settingName = @"Age Group";
	}
}

+ (AgeController *) ageControllerWithDefaults {
	AgeController * newObject =  [[AgeController alloc] initWithStyle:UITableViewStylePlain];
	if (newObject) {
		[newObject setSettingName: @"Age Group"];
	}
	return newObject;
}

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self setSettingName: @"Age Group"];

	if (timeStandardDataAccess != nil) {
		[timeStandardDataAccess openDataBase];
		settingList = [[timeStandardDataAccess getAgeGroupNames:timeStandardName] retain];
	}
	else {
		NSLog(@"Time Standard Data Access is nil. Cannot load view properly");
	}

	[super viewDidLoad];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end

