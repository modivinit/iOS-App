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
    /*self.mContactRealtorIconButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 480, 25, 25)];
    self.mContactRealtorButton = [[UIButton alloc] initWithFrame:CGRectMake(28, 472, 160, 44)];

    if([kunanceUser getInstance].mRealtor.mIsValid)
    {
        if([kunanceUser getInstance].mRealtor.mSmallLogo)
            [self.mContactRealtorIconButton setImage:[kunanceUser getInstance].mRealtor.mSmallLogo
                                            forState:UIControlStateNormal];
        
        if([kunanceUser getInstance].mRealtor.mFirstName)
        {
            [self.mContactRealtorButton setTitle:[NSString stringWithFormat:@"Contact %@", [kunanceUser getInstance].mRealtor.mFirstName]
                                        forState:UIControlStateNormal];
        }
        else
        {
            [self.mContactRealtorButton setTitle:@"Contact Realtor" forState:UIControlStateNormal];

        }
        
        self.mContactRealtorButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
        [self.mContactRealtorButton setTitleColor:[Utilities getKunanceBlueColor] forState:UIControlStateNormal] ;
        self.mContactRealtorButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self.mContactRealtorIconButton addTarget:self action:@selector(contactRealtor) forControlEvents:UIControlEventTouchUpInside];
        [self.pageController.view addSubview:self.mContactRealtorIconButton];
        
        [self.mContactRealtorButton addTarget:self action:@selector(contactRealtor) forControlEvents:UIControlEventTouchUpInside];
        [self.pageController.view addSubview:self.mContactRealtorButton];
        
    }*/
    
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
