//
//  RootViewController.h
//  CoreDataPractice
//
//  Created by JASON CROSS on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwimmerController;
@class CoreDataPracticeAppDelegate; 


@interface RootViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource,
UIPickerViewDelegate, UIPickerViewDataSource>{
	NSArray			* controllers;
	UITableView     * tableView;
	UITableViewCell * nibLoadedStandardCell;
	UITableViewCell * nibLoadedSwimmerCell;
	SwimmerController * swimmerController;
	CoreDataPracticeAppDelegate * appDelegate;
}

@property (nonatomic, retain) NSArray		* controllers;
@property (nonatomic, retain) IBOutlet		UITableView		* tableView;
@property (nonatomic, retain) IBOutlet		UITableViewCell * nibLoadedStandardCell;
@property (nonatomic, retain) IBOutlet		UITableViewCell * nibLoadedSwimmerCell;

@end
