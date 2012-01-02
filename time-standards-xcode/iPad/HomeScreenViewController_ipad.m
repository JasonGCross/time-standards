//
//  HomeScreenViewController_ipad.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenViewController_ipad.h"
#import "STSAppDelegate_ipad.h"
#import "TimeStandardAndSwimmerController.h"

@implementation HomeScreenViewController_ipad

@synthesize toolbar;
@synthesize timeStandardNameLabel;
@synthesize swimmerNameLabel;
@synthesize swimmerGenderLabel;
@synthesize swimmerAgeGroupLabel;
@synthesize photoImageView;
@synthesize timeStandardAndSwimmerVC;
@synthesize popoverController;

static UIImage * defaultImage = nil;

#pragma mark - View lifecycle

- (id) init {
    return [self initWithNibName:@"HomeScreenViewController_ipad" bundle:nil];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Swim Time Standards";
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleHomeScreenValueChange) 
                                                 name:STSHomeScreenValuesChangedKey
                                               object: nil];
    defaultImage = [UIImage imageNamed:@"headshot.png"];
}

#pragma mark - private methods

- (void) displaySwimmerPhoto: (NSManagedObject *) _swimmer {
	if(_swimmer == nil) {
		return;
	}
	
	NSManagedObject * photo = [_swimmer valueForKey:@"swimmerPhoto"];
	if (photo == nil) {
		return;
	}
	
	UIImage * photoImage = [photo valueForKey:@"photoImage"];
	if (photoImage == nil) {
		// reset to the default; don't have an empty image
        photoImage = defaultImage;
	}
	
	self.photoImageView.image = photoImage;
}

- (void) handleHomeScreenValueChange {
    NSString * timeStandardName = [appDelegate getHomeScreenTimeStandard];
    self.previousTimeStandard = timeStandardName;
    timeStandardName = ((nil == timeStandardName) || ([timeStandardName length] == 0)) ? 
        @"select a Time Standard" : timeStandardName;
    self.timeStandardNameLabel.text = timeStandardName;
    
    
    NSManagedObject * swimmer = [appDelegate getHomeScreenSwimmer];
    NSString * swimmerName = [swimmer valueForKey:@"swimmerName"];
    self.swimmerNameLabel.text = swimmerName;
    
    NSString * swimmerAgeGroup = [swimmer valueForKey:@"swimmerAgeGroup"];
    self.previousAgeGroup = swimmerAgeGroup;
    swimmerAgeGroup = ((nil == swimmerAgeGroup) || ([swimmerAgeGroup length] < 1)) ? 
        @"(re)select an age group" : swimmerAgeGroup;
    self.swimmerAgeGroupLabel.text = swimmerAgeGroup;
    
    NSString * swimmerGender = [swimmer valueForKey:@"swimmerGender"];
    self.previousGender = swimmerGender;
    swimmerGender = (swimmerGender == nil) ? @"select gender" : swimmerGender;
    self.swimmerGenderLabel.text = swimmerGender;
    
    [self displaySwimmerPhoto: swimmer];
    
    if (self.popoverController) {
        [self.popoverController dismissPopoverAnimated:YES];
    }
    
    // takes care of loading the picker and the time label
    [super handleHomeScreenValueChange];
}

#pragma mark - split view delegate

- (void) splitViewController:(UISplitViewController *)svc 
      willHideViewController:(UIViewController *)aViewController 
           withBarButtonItem:(UIBarButtonItem *)barButtonItem 
        forPopoverController:(UIPopoverController *)pc {
    barButtonItem.title = aViewController.title;
    [self.toolbar setItems:[NSArray arrayWithObject:barButtonItem] 
                  animated:YES];
    self.popoverController = pc;
}

- (void) splitViewController:(UISplitViewController *)svc 
      willShowViewController:(UIViewController *)aViewController 
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [self.toolbar setItems:[NSArray array] animated:YES];
    self.popoverController = nil;
}

#pragma mark - memory management

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.toolbar = nil;
    self.toolbar = nil;
    self.timeStandardNameLabel = nil;
    self.swimmerNameLabel = nil;
    self.swimmerGenderLabel = nil;
    self.swimmerAgeGroupLabel = nil;
    self.photoImageView = nil;
    self.timeStandardAndSwimmerVC = nil;
}

- (void) dealloc {
    [toolbar release];
    [timeStandardNameLabel release];
    [swimmerNameLabel release];
    [swimmerGenderLabel release];
    [swimmerAgeGroupLabel release];
    [photoImageView release];
    [popoverController release];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}


@end
