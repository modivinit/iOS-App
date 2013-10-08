//
//  DashOneHomeEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashOneHomeEnteredViewController.h"

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

}

-(void) setNavTitle:(NSString *)title
{
    if(title)
        self.navigationItem.title = title;
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
