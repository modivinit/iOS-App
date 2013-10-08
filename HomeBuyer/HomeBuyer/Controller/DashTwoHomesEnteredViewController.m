//
//  DashTwoHomesEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashTwoHomesEnteredViewController.h"
#import "HelpDashboardViewController.h"

@interface DashTwoHomesEnteredViewController ()

@end

@implementation DashTwoHomesEnteredViewController

- (void)viewDidLoad
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];

    Home1VsHome2ViewController* viewController1 = [[Home1VsHome2ViewController alloc] init];
    viewController1.mHomes1VsHome2Delegate = self;
    [self.mPageViewControllers addObject:viewController1];
    
    HomesComparisionViewController* viewController2 = [[HomesComparisionViewController alloc] init];
    viewController2.mHomesComparisionDelegate = self;
    [self.mPageViewControllers addObject: viewController2];
    
    TwoHomeRentVsBuyViewController* viewController3 = [[TwoHomeRentVsBuyViewController alloc] init];
    viewController3.mTwoHomeRentVsBuyDelegate = self;
    [self.mPageViewControllers addObject:viewController3];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *revealImagePortrait = [UIImage imageNamed:@"MenuIcon.png"];
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImagePortrait
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView)];
    }
    
    UITapGestureRecognizer* helpTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(helpButtonTapped)];
    [self.mHelpImageAsButton addGestureRecognizer:helpTapGesture];

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

-(IBAction)dashButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayDashNotification object:nil];
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
