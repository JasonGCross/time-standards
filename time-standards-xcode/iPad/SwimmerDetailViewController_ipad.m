//
//  SwimmerDetailViewController_ipad.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwimmerDetailViewController_ipad.h"
#import "SwimmerPhotoViewController_ipad.h"
#import "SwimmingTimeStandardsAppDelegate.h"

@implementation SwimmerDetailViewController_ipad

@synthesize popoverController;

#pragma mark - view lifecycle



- (void) viewWillDisappear:(BOOL)animated {
    // save whatever was in the text field. Don't make the user remove focus 
    // from the text field before dismissing the popover.
    [self textFieldDoneEditing:nil];
    [super viewWillDisappear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

#pragma mark - ImagePicker view

- (IBAction) imageViewTapped:(id)sender {
    // first, remember to save any un-saved changes from editing the swimmer's name
	[_swimmer setValue: nameTextField.text forKey: @"swimmerName"];
	[_appDelegate saveContext];
	
	// Navigation logic may go here. Create and push another view controller.
	SwimmerPhotoViewController_ipad *swimmerPhotoViewController = [[[SwimmerPhotoViewController_ipad alloc] 
                                                                    initWithNibName:@"SwimmerPhotoViewController"
                                                                    bundle:nil] autorelease];
    // we don't want it to take up the whole screen; that's way too big
    [swimmerPhotoViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [_appDelegate setCurrentSwimmer:_swimmer];
	
    // Pass the selected object to the new view controller.
    self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:swimmerPhotoViewController] autorelease];
    [self.popoverController presentPopoverFromRect:self.view.bounds
                             inView:self.view 
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];
}

#pragma mark - memory management

- (void) dealloc {
    [popoverController release];
    
    [super dealloc];
}

@end
