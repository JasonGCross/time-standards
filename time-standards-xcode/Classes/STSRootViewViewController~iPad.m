//
//  STSRootViewViewController~iPad.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/19/14.
//
//

#import "STSRootViewViewController~iPad.h"
#import "STSSwimmerDataAccess.h"



static UIImage * defaultImage = nil;

@interface STSRootViewViewController_iPad ()
@property (nonatomic, weak) IBOutlet UIToolbar * toolbar;
@property (nonatomic, weak) IBOutlet UILabel * timeStandardNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * swimmerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * swimmerAgeGroupLabel;
@property (nonatomic, weak) IBOutlet UILabel * swimmerGenderLabel;
@property (nonatomic, weak) IBOutlet UIImageView * photoImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarCenterView;
@property (nonatomic, strong) UIPopoverController * privatePopoverController;
@end

@implementation STSRootViewViewController_iPad

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Swim Time Standards";
    [self.toolBarCenterView setEnabled:NO];
    defaultImage = [UIImage imageNamed:@"headshot.png"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSwimmerPhotoChanged)
                                                 name:STSSwimmerPhotoChangedKey
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSwimmerNameChanged)
                                                 name:STSSwimmerNameChangedKey
                                               object: nil];
}

#pragma mark - private methods

- (void) displaySwimmerPhoto: (NSManagedObject *) _swimmer {
	if(_swimmer == nil) {
		return;
	}
	
    UIImage * photoImage = nil;
	NSManagedObject * photo = [_swimmer valueForKey:@"swimmerPhoto"];
	if (photo == nil) {
		photoImage = defaultImage;
	}
	else {
        photoImage = [photo valueForKey:@"photoImage"];
        if (photoImage == nil) {
            // reset to the default; don't have an empty image
            photoImage = defaultImage;
        }
    }
	
	self.photoImageView.image = photoImage;
}

- (void) handleSwimmerPhotoChanged; {
    NSManagedObject * currentSwimmer = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenSwimmer];
    
    [self displaySwimmerPhoto: currentSwimmer];
}

- (void) handleSwimmerNameChanged; {
    NSManagedObject * currentSwimmer = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenSwimmer];
    NSString * swimmerName = [currentSwimmer valueForKey:@"swimmerName"];
    [self.swimmerNameLabel setText:swimmerName];
}

- (void) handleHomeScreenValueChange {
    NSString * timeStandardName = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenTimeStandard];
    self.previousTimeStandard = timeStandardName;
    timeStandardName = ((nil == timeStandardName) || ([timeStandardName length] == 0)) ?
    @"select a Time Standard" : timeStandardName;
    [self.timeStandardNameLabel setText:timeStandardName];
    
    NSManagedObject * swimmer = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenSwimmer];
    NSString * swimmerAgeGroup = [swimmer valueForKey:@"swimmerAgeGroup"];
    self.previousAgeGroup = swimmerAgeGroup;
    swimmerAgeGroup = ((nil == swimmerAgeGroup) || ([swimmerAgeGroup length] < 1)) ?
    @"(re)select an age group" : swimmerAgeGroup;
    self.swimmerAgeGroupLabel.text = swimmerAgeGroup;
    
    NSString * swimmerGender = [swimmer valueForKey:@"swimmerGender"];
    self.previousGender = swimmerGender;
    swimmerGender = (swimmerGender == nil) ? @"select gender" : swimmerGender;
    self.swimmerGenderLabel.text = swimmerGender;
    
    [self handleSwimmerNameChanged];
    [self displaySwimmerPhoto: swimmer];
    
    if (self.privatePopoverController) {
        [self.privatePopoverController dismissPopoverAnimated:YES];
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
    NSMutableArray * items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    self.privatePopoverController = pc;
}

- (void) splitViewController:(UISplitViewController *)svc
      willShowViewController:(UIViewController *)aViewController
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    NSMutableArray * items = [[self.toolbar items] mutableCopy];
    [items removeObject:barButtonItem];
    [self.toolbar setItems:items animated:YES];
    self.privatePopoverController = nil;
}

#pragma mark - memory management

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


@end
