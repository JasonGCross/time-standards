//
//  HomeScreenViewController_ipad.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenViewController.h"

@class TimeStandardAndSwimmerController;

@interface HomeScreenViewController_ipad : HomeScreenViewController <UISplitViewControllerDelegate> {
    UIToolbar * toolbar;
    UILabel * timeStandardNameLabel;
    UILabel * swimmerNameLabel;
    UILabel * swimmerGenderLabel;
    UILabel * swimmerAgeGroupLabel;
    UIImageView * photoImageView;
    TimeStandardAndSwimmerController * timeStandardAndSwimmerVC;
    UIPopoverController * popoverController;
}

@property (nonatomic, retain) IBOutlet UIToolbar * toolbar;
@property (nonatomic, retain) IBOutlet UILabel * timeStandardNameLabel;
@property (nonatomic, retain) IBOutlet UILabel * swimmerNameLabel;
@property (nonatomic, retain) IBOutlet UILabel * swimmerGenderLabel;
@property (nonatomic, retain) IBOutlet UILabel * swimmerAgeGroupLabel;
@property (nonatomic, retain) IBOutlet UIImageView * photoImageView;
@property (nonatomic, assign) IBOutlet TimeStandardAndSwimmerController * timeStandardAndSwimmerVC;
@property (nonatomic, retain) UIPopoverController * popoverController;

@end
