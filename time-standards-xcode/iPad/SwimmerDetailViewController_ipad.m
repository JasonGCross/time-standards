//
//  SwimmerDetailViewController_ipad.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwimmerDetailViewController_ipad.h"

@implementation SwimmerDetailViewController_ipad

// save whatever was in the text field

- (void) viewWillDisappear:(BOOL)animated {
    [self textFieldDoneEditing:nil];
    [super viewWillDisappear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

@end
