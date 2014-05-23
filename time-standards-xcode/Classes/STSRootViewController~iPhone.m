//
//  STSRootViewController~iPhone.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/19/14.
//
//

#import "STSRootViewController~iPhone.h"

typedef NS_ENUM(NSUInteger, STSRootViewControlleriPhoneTableSections) {
    STSRootViewControlleriPhoneTableSectionTimeStandard = 0,
    STSRootViewControlleriPhoneTableSectionSwimmer = 1,
    STSRootViewControlleriPhoneTableSectionTotal
};

@interface STSRootViewController_iPhone () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation STSRootViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSUInteger value = STSRootViewControlleriPhoneTableSectionTotal;
    return value;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableViewParam cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellReuseIdentifier = @"detailViewCell";
    [tableViewParam registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    UITableViewCell *cell = [tableViewParam dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    // Configure the cell...
	NSUInteger section = [indexPath section];

    
	switch (section) {
		case STSRootViewControlleriPhoneTableSectionTimeStandard:
			// configure the cell.

			break;
		case STSRootViewControlleriPhoneTableSectionSwimmer:
			// configure the cell.

			break;
		default:
			break;
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableViewParam didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSUInteger section = [indexPath section];
	
	switch (section) {
		case STSRootViewControlleriPhoneTableSectionTimeStandard:

			break;
		case STSRootViewControlleriPhoneTableSectionSwimmer:

			break;
		default:
			break;
	}
}



@end
