//
//  DashOneHomeEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashOneHomeEnteredViewController.h"
#import "HelpDashboardViewController.h"

@interface DashOneHomeEnteredViewController ()

@end

@implementation DashOneHomeEnteredViewController

- (void)viewDidLoad
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];

    RentVsBuyDashViewController* viewController1 = [[RentVsBuyDashViewController alloc] init];
    viewController1.mRentVsBuyDashViewDelegate = self;
    [self.mPageViewControllers addObject:viewController1];
    
    OneHomeLifeStyleViewController* viewController2 = [[OneHomeLifeStyleViewController alloc] init];
    viewController2.mOneHomeLifeStyleDelegate = self;
    [self.mPageViewControllers addObject: viewController2];
    
    OneHomePaymentsViewController* viewController3 = [[OneHomePaymentsViewController alloc] init];
    viewController3.mOneHomePaymentsDelegate = self;
    [self.mPageViewControllers addObject:viewController3];
    
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
                                  self.view.bounds.size.width, self.view.bounds.size.height - 40);
    self.pageController.view.frame = pageBound;
    self.pageController.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer* helpTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(helpButtonTapped)];
    [self.mHelpImageAsButton addGestureRecognizer:helpTapGesture];
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