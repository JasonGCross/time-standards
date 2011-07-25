//
//  TableViewCell_Switch.h
//  PNS Times
//
//  Created by JASON CROSS on 7/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewCell_Switch : UITableViewCell {
	UILabel			*switchLabel;
	UIImageView		*switchImage;
	UISwitch		*switchControl;
}

@property (nonatomic, retain) IBOutlet UILabel			*switchLabel;
@property (nonatomic, retain) IBOutlet UIImageView		*switchImage;
@property (nonatomic, retain) IBOutlet UISwitch			*switchControl;


- (IBAction) switchChanged: (UISwitch *) sender;

@end
