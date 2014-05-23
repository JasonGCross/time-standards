//
//  STSSmartTableViewCell.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import <UIKit/UIKit.h>

@interface STSSmartTableViewCell : UITableViewCell
+(NSString*)cellIdentifier;
+(id)cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib;
+(id)cellForTableView:(UITableView*)tableView;
+(UINib*)nib;
@end
