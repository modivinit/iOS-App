//
//  LeftMenuViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LeftMenuViewController.h"

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

-(void) viewWillAppear:(BOOL)animated
{
    [self.mMenuTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Custom initialization
    CGRect rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+20, self.view.bounds.size.width, self.view.bounds.size.height);
    self.mMenuTableView = [[UITableView alloc] initWithFrame:rect
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
    if(self.mLeftMenuDelegate && [self.mLeftMenuDelegate respondsToSelector:@selector(showFrontViewForSection:andRow:)])
    {
        [self.mLeftMenuDelegate showFrontViewForSection:indexPath.section andRow:indexPath.row];
    }
}

#pragma mark UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width-60, 30.0)];
    header.backgroundColor = [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:(0.9)];

    UILabel *textLabel = [[UILabel alloc] initWithFrame:header.frame];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    [header addSubview:textLabel];
    
    switch ((int)section) {
        case SECTION_USER_NAME_DASH_REALTOR:
            textLabel.text = [[NSString stringWithFormat:@"%@",[kunanceUser getInstance].mLoggedInKunanceUser.firstName] uppercaseString];
            textLabel.textAlignment = NSTextAlignmentCenter;
            break;
            
        case SECTION_HOMES:
            textLabel.text = @"HOMES";
            break;
            
        case SECTION_LOAN:
            textLabel.text = @"LOAN";
            break;
            
        case SECTION_USER_PROFILE:
            textLabel.text = @"PROFILE";
            break;
            
        case SECTION_INFO:
            textLabel.text = @"";
            break;
            
        default:
            break;
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if(section == SECTION_INFO)
//        return 10.0;
//    else
        return 1.0;
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
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
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 0;
    switch (section)
    {
        case SECTION_USER_NAME_DASH_REALTOR:
            numOfRows = 2;
            break;
            
        case SECTION_HOMES:
            numOfRows = MAX_NUMBER_OF_HOMES_PER_USER;
            break;
            
        case SECTION_LOAN:
            numOfRows = 1;
            break;
            
        case SECTION_USER_PROFILE:
            numOfRows = 2;
            break;
            
        case SECTION_INFO:
            numOfRows = 3;
            break;
            
        default:
            break;
    }
    return numOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellReuseIdentifier = @"cellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    CGRect rect = cell.frame;
    
    UIImageView* cellImage = [[UIImageView alloc]
                              initWithFrame:CGRectMake(rect.origin.x+10 , rect.origin.y, 25, 25)];
    cellImage.center = CGPointMake(cellImage.center.x, cell.center.y);

    UILabel* cellText = [[UILabel alloc]
                         initWithFrame:CGRectMake(cellImage.bounds.origin.x+cellImage.bounds.size.width+20 ,
                                                  rect.origin.y, rect.size.width-110, rect.size.height)];
    
    cellText.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    
    [cell addSubview:cellText];
    [cell addSubview:cellImage];
    
    switch (indexPath.section)
    {
        case SECTION_USER_NAME_DASH_REALTOR:
            if(indexPath.row == ROW_DASHBOARD)
            {
                cellText.text = @"Dashboard";
                cellImage.image = [UIImage imageNamed:@"dashboard-help-menu.png"];
            }
            else if(indexPath.row == ROW_REALTOR)
            {
                cellText.text = @"Contact Realtor";
                cellImage.image = [UIImage imageNamed:@"menu-contact-realtor.png"];
            }
            break;
            
        case SECTION_HOMES:
        {
            uint count = 0;
            homeInfo* home = nil;
           
            if([kunanceUser getInstance].mKunanceUserHomes)
            {
                count = [[kunanceUser getInstance].mKunanceUserHomes getCurrentHomesCount];
                home = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:indexPath.row];
            }
            homeType type = homeTypeNotDefined;
           
            if(home)
                type = home.mHomeType;
            
            if(indexPath.row == ROW_FIRST_HOME)
            {
                if(count == 0)
                {
                    cellImage.image = [UIImage imageNamed:@"menu-add-home.png"];
                }
                else if(count >= 1)
                {
                    if(type == homeTypeCondominium)
                        cellImage.image = [UIImage imageNamed:@"menu-home-condo.png"];
                    else if(type == homeTypeSingleFamily)
                        cellImage.image = [UIImage imageNamed:@"menu-home-sfh.png"];
                }
                
            }
            else if(indexPath.row == ROW_SECOND_HOME)
            {
                if(count ==0)
                {
                    cellImage.image = [UIImage imageNamed:@"menu-add-home.png"];
                }
                else if(count == 1)
                {
                    cellImage.image = [UIImage imageNamed:@"menu-add-home.png"];
                }
                else if(count == 2)
                {
                    if(type == homeTypeCondominium)
                        cellImage.image = [UIImage imageNamed:@"menu-home-condo.png"];
                    else if(type == homeTypeSingleFamily)
                        cellImage.image = [UIImage imageNamed:@"menu-home-sfh.png"];
                }
            }
            
            if(home && home.mIdentifiyingHomeFeature)
                cellText.text = home.mIdentifiyingHomeFeature;
            else
                cellText.text = [NSString stringWithFormat:@"Add a Home"];

        }
            break;
            
        case SECTION_LOAN:
            if(indexPath.row == ROW_LOAN_INFO)
            {
                cellText.text = @"Loan Info";
                cellImage.image = [UIImage imageNamed:@"menu-loan-info.png"];
            }
            break;
            
        case SECTION_USER_PROFILE:
        {
            userPFInfo* user = [kunanceUser getInstance].mkunanceUserPFInfo;
            
            if(indexPath.row == ROW_YOUR_PROFILE)
            {
                cellText.text = @"Your Profile";
                if(!user)
                {
                    cellImage.image = [UIImage imageNamed:@"menu-create-profile.png"];
                }
                else if(user.mMaritalStatus == StatusSingle)
                {
                    cellImage.image = [UIImage imageNamed:@"menu-profile-single.png"];
                }
                else if (user.mMaritalStatus == StatusMarried)
                {
                    cellImage.image = [UIImage imageNamed:@"menu-profile-couple.png"];
                }
            }
            else if(indexPath.row == ROW_FIXED_COSTS)
            {
                cellText.text = @"Fixed Costs";
                cellImage.image = [UIImage imageNamed:@"menu-fixedcosts.png"];
            }
        }
            break;

        case SECTION_INFO:
            if(indexPath.row == ROW_HELP_CENTER)
            {
                cellText.text = @"Help Center";
                cellImage.image = [UIImage imageNamed:@"menu-help.png"];
            }
            else if(indexPath.row == ROW_TERMS_AND_POLICIES)
            {
                cellText.text = @"Terms & Policies";
                cellImage.image = [UIImage imageNamed:@"menu-terms-and-policies.png"];
            }
            else if(indexPath.row == ROW_LOGOUT)
            {
                cellText.text = @"Logout";
                cellImage.image = [UIImage imageNamed:@"menu-logout.png"];
            }

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
