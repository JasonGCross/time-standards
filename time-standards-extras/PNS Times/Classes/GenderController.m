//
//  GenderController.m
//  PNS Times
//
//  Created by JASON CROSS on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GenderController.h"


@implementation GenderController

- (void) setSettingName:(NSString *) value {
	if ([[value lowercaseString] isEqualToString: @"gender"]) {
		settingName = @"Gender";
	}
}

- (void) setSettingValue:(NSString *) value {
	if ([[value lowercaseString] isEqualToString: @"male"]) {
		settingValue = @"male";
		gender = male;
	}
	else if ([[value lowercaseString] isEqualToString: @"female"]) {
		settingValue = @"female";
		gender = female;
	}
}

+ (GenderController *) genderControllerWithDefaults {
	GenderController * newObject =  [[GenderController alloc] initWithStyle:UITableViewStylePlain];
	if (newObject) {
		[newObject setSettingName: @"Gender"];
	}
	return newObject;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self setSettingName: @"Gender"];
	settingList = [[NSArray alloc] initWithObjects: @"male", @"female", nil];
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

