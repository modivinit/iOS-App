//
//  DashboardViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/6/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashboardViewController.h"
#import "PKRevealController.h"
#import "DashNoInfoEnteredView.h"
#import "DashUserPFInfoEnteredView.h"

@interface DashboardViewController ()
@property (nonatomic, strong) DashNoInfoEnteredView* mDashNoInfoEnteredView;
@property (nonatomic, strong) DashUserPFInfoEnteredView* mDashUserPFInfoEnteredView;
@end

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mDashBoardMasterView = [[UIView alloc] init];
        self.mDashNoInfoEnteredView = nil;
    }
    return self;
}

-(void) showNoInfoEnteredView
{
    self.mDashNoInfoEnteredView = [[[NSBundle mainBundle] loadNibNamed:@"DashNoInfoEnteredView"
                                                                 owner:self options:nil]
                                   objectAtIndex:0];
    
    [self.mDashBoardMasterView addSubview:self.mDashNoInfoEnteredView];
    
    UITapGestureRecognizer* tapAboutYou = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(aboutYouTapped)];
    
    [self.mDashNoInfoEnteredView.mCompositeAboutYouButton addGestureRecognizer:tapAboutYou];
    
    NSString* userName = (([kunanceUser getInstance].mLoggedInKunanceUser.firstName)?
                          [NSString stringWithFormat:@" %@!", [kunanceUser getInstance].mLoggedInKunanceUser.firstName] :
                          [NSString stringWithFormat:@"!"]);
    
    NSString* titleText = [NSString stringWithFormat:@"Welcome %@", userName];
    self.navigationController.navigationBar.topItem.title = titleText;
}

-(void) showUserPFInfoEnteredView
{
    self.mDashUserPFInfoEnteredView = [[[NSBundle mainBundle] loadNibNamed:@"DashUserPFInfoEnteredView"
                                                                     owner:self
                                                                   options:nil]
                                       objectAtIndex:0];
    [self.mDashNoInfoEnteredView removeFromSuperview];
    [self.mDashBoardMasterView addSubview:self.mDashUserPFInfoEnteredView];
}

-(void) pickViewBasedOnStatus
{
    switch ([kunanceUser getInstance].mUserProfileStatus) {
        case ProfileStatusNoInfoEntered:
        case ProfileStatusUserPersonalFinanceInfoEntered:
        {
            [self showNoInfoEnteredView];
        }
            break;
            
        case ProfileStatusUserExpensesInfoEntered:
        {
            [self showUserPFInfoEnteredView];
        }
            break;
            
        case ProfileStatusUser1HomeInfoEntered:
            break;
            
        case ProfileStatusUserMultipleHomesInfoEntered:
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *revealImagePortrait = [UIImage imageNamed:@"MenuIcon.png"];
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImagePortrait
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView:)];
    }
    
    NSLog(@"User status = %d", [kunanceUser getInstance].mUserProfileStatus);
    [self pickViewBasedOnStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)showLeftView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}

- (void)showRightView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.rightViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.rightViewController];
    }
}

-(void) aboutYouTapped
{
    AboutYouViewController* aboutYouController = [[AboutYouViewController alloc] init];
    aboutYouController.mAboutYouControllerDelegate = self;
    [self.navigationController pushViewController:aboutYouController animated:YES];
}


#pragma AboutYouControllerDelegate
-(void) userExpensesButtonTapped
{
    FixedCostsViewController* expensesController = [[FixedCostsViewController alloc] init];
    expensesController.mExpensesControllerDelegate = self;
    [self.navigationController pushViewController:expensesController animated:YES];
}
#pragma end

#pragma ExpensesControllerDelegate
-(void) currentLifeStyleIncomeButtonPressed
{
    [self pickViewBasedOnStatus];
    [self.navigationController popToViewController:self animated:YES];
}
#pragma end
@end
