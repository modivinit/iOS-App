//
//  DashOneHomeEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashOneHomeEnteredViewController.h"
#import "HelpDashboardViewController.h"
#import "ContactRealtorViewController.h"

@interface DashOneHomeEnteredViewController ()

@end

@implementation DashOneHomeEnteredViewController

-(void) addPages
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];
    
    OneHomeLifestyleViewController* viewController1 = [[OneHomeLifestyleViewController alloc] init];
    viewController1.mOneHomeLifestyleViewDelegate = self;
    [self.mPageViewControllers addObject:viewController1];
    
    OneHomePaymentViewController* viewController2 = [[OneHomePaymentViewController alloc] init];
    viewController2.mOneHomePaymentViewDelegate = self;
    [self.mPageViewControllers addObject:viewController2];
    
    OneHomeTaxSavingsViewController* viewController3 = [[OneHomeTaxSavingsViewController alloc] init];
    viewController3.mOneHomeTaxSavingsDelegate = self;
    [self.mPageViewControllers addObject: viewController3];
}

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
    
//    self.mAddHomeButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 462, 87, 35)];
//    CGPoint buttonCenter = self.mAddHomeButton.center;
//    self.mAddHomeButton.center = CGPointMake(self.view.center.x, buttonCenter.y);
//    
//    [self.mAddHomeButton setImage:[UIImage imageNamed:@"addahome.png"] forState:UIControlStateNormal];
//    [self.mAddHomeButton addTarget:self action:@selector(addHomeInfo) forControlEvents:UIControlEventTouchUpInside];
//    [self.pageController.view addSubview:self.mAddHomeButton];
}

- (void)viewDidLoad
{
    [self addPages];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *revealImagePortrait = [UIImage imageNamed:@"MenuIcon.png"];
    
    if ([self.navigationController.revealController hasLeftViewController])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImagePortrait
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView)];
    }

    CGRect pageBound = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,
                                  self.view.bounds.size.width, self.view.bounds.size.height);
    self.pageController.view.frame = pageBound;
    self.pageController.view.backgroundColor = [UIColor clearColor];
    
    [self addButtons];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed 1-home dashboard" properties:Nil];
}

-(void) setNavTitle:(NSString *)title
{
    if(title)
        self.navigationItem.title = title;
}

-(void) helpButtonTapped
{
    HelpDashboardViewController* dashHelp = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:dashHelp animated:NO];
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
