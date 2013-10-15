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
    
    RentVsBuyDashViewController* viewController1 = [[RentVsBuyDashViewController alloc] init];
    viewController1.mRentVsBuyDashViewDelegate = self;
    [self.mPageViewControllers addObject:viewController1];
    
    HomeTaxSavingsViewController* viewController2 = [[HomeTaxSavingsViewController alloc] init];
    viewController2.mHomeTaxSavingsDelegate = self;
    [self.mPageViewControllers addObject: viewController2];
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
    
    self.mAddHomeButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 462, 87, 35)];
    CGPoint buttonCenter = self.mAddHomeButton.center;
    self.mAddHomeButton.center = CGPointMake(self.view.center.x, buttonCenter.y);
    
    [self.mAddHomeButton setImage:[UIImage imageNamed:@"addahome.png"] forState:UIControlStateNormal];
    [self.mAddHomeButton addTarget:self action:@selector(addHomeInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mAddHomeButton];
}

- (void)viewDidLoad
{
    [self addPages];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *revealImagePortrait = [UIImage imageNamed:@"MenuIcon.png"];
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
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
}

-(void) setNavTitle:(NSString *)title
{
    if(title)
        self.navigationItem.title = title;
}

-(void) addHomeInfo
{
    uint currentCount = [[kunanceUser getInstance].mKunanceUserHomes getCurrentHomesCount];
    self.mHomeInfoViewController = [[HomeInfoEntryViewController alloc] initAsHomeNumber:currentCount];
    [self.navigationController pushViewController:self.mHomeInfoViewController animated:NO];
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
