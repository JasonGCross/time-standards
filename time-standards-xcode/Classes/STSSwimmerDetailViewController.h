//
//  SwimmerDetailViewController.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSAppDelegate;


@interface STSSwimmerDetailViewController : UIViewController <UITextFieldDelegate, 
UITableViewDelegate, UITableViewDataSource> 

@property (nonatomic, strong) IBOutlet UITextField * nameTextField;
@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UIImageView * imageView;

- (IBAction) backgroundTapped:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;

@end
