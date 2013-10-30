//
//  DashTwoHomesEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashTwoHomesEnteredViewController.h"
#import "HelpDashboardViewController.h"
#import "ContactRealtorViewController.h"


@interface DashTwoHomesEnteredViewController ()

@end

@implementation DashTwoHomesEnteredViewController

-(void) addButtons
{
    self.mContactRealtorButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 520, 30, 30)];
    [self.mContactRealtorButton setImage:[UIImage imageNamed:@"logo-svl.gif"] forState:UIControlStateNormal];
    [self.mContactRealtorButton addTarget:self action:@selector(contactRealtor) forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mContactRealtorButton];
    
    self.mHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 530, 20, 20)];
    [self.mHelpButton setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
    [self.mHelpButton addTarget:self action:@selector(helpButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mHelpButton];
}

-(void) addPages
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];
    
    TwoHomeLifestyleIncomeViewController* viewController3 = [[TwoHomeLifestyleIncomeViewController alloc] init];
    viewController3.mTwoHomeLifestyleDelegate = self;
    [self.mPageViewControllers addObject:viewController3];
    
    TwoHomePaymentViewController* viewController1 = [[TwoHomePaymentViewController alloc] init];
    viewController1.mTwoHomePaymentDelegate = self;
    [self.mPageViewControllers addObject:viewController1];
    
    TwoHomeTaxSavingsViewController* viewController4 = [[TwoHomeTaxSavingsViewController alloc] init];
    viewController4.mTwoHomeTaxSavingsDelegate = self;
    [self.mPageViewControllers addObject:viewController4];
}

- (void)viewDidLoad
{
    [self addPages];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *revealImagePortrait = [UIImage imageNamed:@"MenuIcon.png"];
    
    if ([self.navigationController.revealController hasLeftViewController])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImagePortrait
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView)];
    }
    
    [self addButtons];
}

-(void) helpButtonTapped
{
    HelpDashboardViewController* dashHelp = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:dashHelp animated:NO];
}

-(void) setNavTitle:(NSString *)title
{
    if(title)
        self.navigationItem.title = title;
}

-(void)contactRealtor
{
    ContactRealtorViewController* contactRealtor = [[ContactRealtorViewController alloc] init];
    [self.navigationController pushViewController:contactRealtor animated:NO];
}

-(void) hideLeftView
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController
         showViewController:self.navigationController.revealController.frontViewController];
    }
}

-(void)showLeftView
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController
         showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController
         showViewController:self.navigationController.revealController.leftViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
