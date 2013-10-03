//
//  LeftMenuViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LeftMenuViewController.h"

#define SECTION_USER_NAME 0
#define SECTION_DASH 1
#define SECTION_REALTOR 2
#define SECTION_HOMES 3
#define SECTION_LOAN 4
#define SECTION_USER_PROFILE 5
#define SECTION_INFO 6

@interface LeftMenuViewController ()
@property (nonatomic, strong) UITableView* mMenuTableView;
@end

@implementation LeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Custom initialization
    self.mMenuTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                       style:UITableViewStyleGrouped];
    self.mMenuTableView.dataSource = self;
    self.mMenuTableView.delegate = self;
    self.mMenuTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mMenuTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* header = nil;
    switch ((int)section) {
        case SECTION_USER_NAME:
            break;
            
        case SECTION_DASH:
            break;

        case SECTION_REALTOR:
            break;

        case SECTION_HOMES:
            header = @"Homes";
            break;
            
        case SECTION_LOAN:
            header = @"Loan";
            break;
            
        case SECTION_USER_PROFILE:
            header = @"Profile";
            break;
            
        case SECTION_INFO:
            header = @"Info";
            break;
            
        default:
            break;
    }
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 0;
    switch (section)
    {
        case SECTION_USER_NAME:
            numOfRows = 1;
            break;
            
        case SECTION_DASH:
            numOfRows = 1;
            break;

        case SECTION_REALTOR:
            numOfRows = 1;
            break;

        case SECTION_HOMES:
            numOfRows = MAX_NUMBER_OF_HOMES_PER_USER;
            break;
            
        case SECTION_LOAN:
            numOfRows = 1;
            break;
            
        case SECTION_USER_PROFILE:
            numOfRows = 1;
            break;
            
        case SECTION_INFO:
            numOfRows = 2;
            break;
            
        default:
            break;
    }
    return numOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellReuseIdentifier = @"cellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    switch (indexPath.section)
    {
        case SECTION_USER_NAME:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[kunanceUser getInstance].mLoggedInKunanceUser.firstName];
            break;
            
        case SECTION_DASH:
            cell.textLabel.text = @"Dash";
            break;

        case SECTION_REALTOR:
            cell.textLabel.text = @"Realtor";
            break;

        case SECTION_HOMES:
            if(indexPath.row == 0)
                cell.textLabel.text = @"Home 1";
            else
                cell.textLabel.text = @"Home 2";
            break;
            
        case SECTION_LOAN:
            cell.textLabel.text = @"Loan Info";
            break;
            
        case SECTION_USER_PROFILE:
            if(indexPath.row == 0)
                cell.textLabel.text = @"About You";
            else
                cell.textLabel.text = @"Expenses";
            break;

        case SECTION_INFO:
            if(indexPath.row == 0)
                cell.textLabel.text = @"Help";
            else
                cell.textLabel.text = @"About Kunance";

            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void) cellForUserName:(UITableViewCell*) cell
{
    UILabel* label = [[UILabel alloc] initWithFrame:cell.bounds];
    [cell addSubview:label];
    label.text = [NSString stringWithFormat:@"%@",[kunanceUser getInstance].mLoggedInKunanceUser.firstName];
}
@end
