//
//  TableViewCell_Switch.m
//  PNS Times
//
//  Created by JASON CROSS on 7/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TableViewCell_Switch.h"


@implementation TableViewCell_Switch

@synthesize switchLabel, switchImage, switchControl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction) switchChanged: (UISwitch *) sender {
	NSString * switchState = @"on";
	if (sender.isOn) {
		switchState = @"on";
	}
	else {
		switchState = @"off";
	}

	NSLog(@"The selected switch index is: %@", switchState);
}


- (void)dealloc {
    [super dealloc];
}


@end
