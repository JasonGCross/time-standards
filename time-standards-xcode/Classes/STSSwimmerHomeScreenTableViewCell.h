//
//  STSSwimmerTableViewCell.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSSmartTableViewCell.h"

@interface STSSwimmerHomeScreenTableViewCell : STSSmartTableViewCell
@property (nonatomic, weak) IBOutlet UILabel * swimmerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * swimmerDescriptionLabel;

@end
