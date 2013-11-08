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
    self.mRentalButton = [[UIButton alloc] initWithFrame:CGRectMake(49, 360, 104, 30)];
    self.mRentalButton.backgroundColor = [UIColor clearColor];
    [self.mRentalButton addTarget:self
                          action:@selector(rentalButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mRentalButton];

    self.mHome1Button = [[UIButton alloc] initWithFrame:CGRectMake(49, 400, 104, 30)];
    self.mHome1Button.backgroundColor = [UIColor clearColor];
    [self.mHome1Button addTarget:self
                          action:@selector(home1ButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mHome1Button];

    self.mHome2Button = [[UIButton alloc] initWithFrame:CGRectMake(49, 447, 104, 30)];
    self.mHome2Button.backgroundColor = [UIColor clearColor];
    [self.mHome2Button addTarget:self
                          action:@selector(home2ButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mHome2Button];

    
    self.mHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(274, 520, 44, 44)];
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
    
    TwoHomeTaxSavingsViewController* viewController4 = [[TwoHomeTaxSavingsViewController alloc] init];
    viewController4.mTwoHomeTaxSavingsDelegate = self;
    [self.mPageViewControllers addObject:viewController4];
    
    TwoHomePaymentViewController* viewController1 = [[TwoHomePaymentViewController alloc] init];
    viewController1.mTwoHomePaymentDelegate = self;
    [self.mPageViewControllers addObject:viewController1];
    
    if([kunanceUser getInstance].mRealtor && [kunanceUser getInstance].mRealtor.mIsValid)
    {
        ContactRealtorViewController* contactRealtor = [[ContactRealtorViewController alloc] init];
        [self.mPageViewControllers addObject:contactRealtor];
    }

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
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed 2-home dashboard" properties:Nil];
}

-(void) rentalButtonTapped:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayUserDash object:Nil];
}

-(void) home1ButtonTapped:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHomeButtonTappedFromDash
                                                        object:[NSNumber numberWithInt:FIRST_HOME]];
}

-(void) home2ButtonTapped:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHomeButtonTappedFromDash
                                                        object:[NSNumber numberWithInt:SECOND_HOME]];
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
