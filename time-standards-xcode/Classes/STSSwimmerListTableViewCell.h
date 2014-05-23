//
//  STSSwimmerListTableViewCell.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSSmartTableViewCell.h"

@interface STSSwimmerListTableViewCell : STSSmartTableViewCell
@property (weak, nonatomic) IBOutlet UILabel * swimmerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel * swimmerGenderLabel;
@property (weak, nonatomic) IBOutlet UILabel * swimmerAgeGroupLabel;
@property (weak, nonatomic) IBOutlet UIImageView * photoImageView;
@end
