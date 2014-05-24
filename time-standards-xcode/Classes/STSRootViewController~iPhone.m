//
//  STSRootViewController~iPhone.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/19/14.
//
//

#import "STSRootViewController~iPhone.h"
#import "STSSwimmerHomeScreenTableViewCell.h"
#import "STSSwimmerHomeScreenTableViewCell+Binding.h"
#import "STSTimeStandardHomeScreenTableCell.h"
#import "STSTimeStandardHomeScreenTableCell+Binding.h"
#import "STSSwimmerDataAccess.h"


typedef NS_ENUM(NSUInteger, STSRootViewControlleriPhoneTableSections) {
    STSRootViewControlleriPhoneTableSectionTimeStandard  = 0,
    STSRootViewControlleriPhoneTableSectionSwimmer       = 1,
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
    [self.tableView registerNib:[STSTimeStandardHomeScreenTableCell nib] forCellReuseIdentifier:[STSTimeStandardHomeScreenTableCell cellIdentifier]];
    [self.tableView registerNib:[STSSwimmerHomeScreenTableViewCell nib] forCellReuseIdentifier:[STSSwimmerHomeScreenTableViewCell cellIdentifier]];
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
    
    UITableViewCell *cell = nil;
    
    // Configure the cell...
	NSUInteger section = [indexPath section];

    
	switch (section) {
		case STSRootViewControlleriPhoneTableSectionTimeStandard:
			// configure the cell.
        {
            cell = [STSTimeStandardHomeScreenTableCell cellForTableView:tableViewParam];
            [(STSTimeStandardHomeScreenTableCell*)cell bind];
        }

			break;
		case STSRootViewControlleriPhoneTableSectionSwimmer:
			// configure the cell.
        {
            NSManagedObject * currentSwimmer = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenSwimmer];
            cell = [STSSwimmerHomeScreenTableViewCell cellForTableView:tableViewParam];
            [(STSSwimmerHomeScreenTableViewCell *)cell bindToSwimmer:currentSwimmer];
        }
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
            [self performSegueWithIdentifier:kTimeStandardSegueIdentifier sender:self];
			break;
		case STSRootViewControlleriPhoneTableSectionSwimmer:
            [self performSegueWithIdentifier:kSwimmerListSegueIdentifier sender:self];
			break;
		default:
			break;
	}
}

#pragma mark - public methods

- (void) handleHomeScreenValueChange; {
    [super handleHomeScreenValueChange];
    [self.tableView reloadData];
}



@end
