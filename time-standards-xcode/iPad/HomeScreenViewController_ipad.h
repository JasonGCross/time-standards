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
    TimeStandardAndSwimmerController * __weak timeStandardAndSwimmerVC;
    UIPopoverController * popoverController;
}

@property (nonatomic, strong) IBOutlet UIToolbar * toolbar;
@property (nonatomic, strong) IBOutlet UILabel * timeStandardNameLabel;
@property (nonatomic, strong) IBOutlet UILabel * swimmerNameLabel;
@property (nonatomic, strong) IBOutlet UILabel * swimmerGenderLabel;
@property (nonatomic, strong) IBOutlet UILabel * swimmerAgeGroupLabel;
@property (nonatomic, strong) IBOutlet UIImageView * photoImageView;
@property (nonatomic, weak) IBOutlet TimeStandardAndSwimmerController * timeStandardAndSwimmerVC;
@property (nonatomic, strong) UIPopoverController * popoverController;

@end
