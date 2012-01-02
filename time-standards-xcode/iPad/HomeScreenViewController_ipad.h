//
//  HomeScreenViewController_ipad.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenViewController.h"

@interface HomeScreenViewController_ipad : HomeScreenViewController {
    UIToolbar * toolbar;
    UILabel * timeStandardNameLabel;
    UILabel * swimmerNameLabel;
    UILabel * swimmerGenderLabel;
    UILabel * swimmerAgeGroupLabel;
    UIImageView * photoImageView;
}

@property (nonatomic, retain) IBOutlet UIToolbar * toolbar;
@property (nonatomic, retain) IBOutlet UILabel * timeStandardNameLabel;
@property (nonatomic, retain) IBOutlet UILabel * swimmerNameLabel;
@property (nonatomic, retain) IBOutlet UILabel * swimmerGenderLabel;
@property (nonatomic, retain) IBOutlet UILabel * swimmerAgeGroupLabel;
@property (nonatomic, retain) IBOutlet UIImageView * photoImageView;

@end
