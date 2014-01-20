//
//  HomeScreenViewController_iphone.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenViewController.h"

@interface HomeScreenViewController_iphone : HomeScreenViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray			* controllers;
    UITableView		* tableView;
    TimeStandardController				* timeStandardController;
	SwimmerController					* swimmerController;
}

@property (nonatomic, strong) NSArray		* controllers;
@property (nonatomic, strong) IBOutlet		UITableView		* tableView;

@end
