//
//  HomeInfoDashViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/11/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeInfoDashViewController.h"
#import "HelpDashboardViewController.h"
#import "ContactRealtorViewController.h"
#import "DashLeftMenuViewController.h"

@interface HomeInfoDashViewController ()

@end

@implementation HomeInfoDashViewController

-(id) initWithHomeNumber:(NSNumber*) homeNumber
{
    self = [super init];
    
    if(self)
    {
        if(homeNumber)
            self.mHomeNumber = homeNumber;
    }
    
    return self;
}

-(void) addPages
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];
    
    HomePaymentsViewController* viewController1 = [[HomePaymentsViewController alloc] init];
    viewController1.mHomePaymentsDelegate = self;
    viewController1.mHomeNumber = self.mHomeNumber;
    [self.mPageViewControllers addObject:viewController1];
    
    HomeLifeStyleViewController* viewController2 = [[HomeLifeStyleViewController alloc] init];
    viewController2.mHomeLifeStyleDelegate = self;
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
    
    self.mCompareButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 470, 170, 40)];
    CGPoint buttonCenter = self.mCompareButton.center;
    self.mCompareButton.center = CGPointMake(self.view.center.x, buttonCenter.y);
    [self.mCompareButton setTitle:@"Compare" forState:UIControlStateNormal];
    self.mCompareButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    
    self.mCompareButton.titleLabel.textColor = [Utilities getKunanceBlueColor];
    
    [self.mCompareButton addTarget:self action:@selector(compareButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mCompareButton];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                  target:self
                                                  action:@selector(editHome)];
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

-(void) editHome
{
    HomeInfoEntryViewController* homeEntry = [[HomeInfoEntryViewController alloc]
                                              initAsHomeNumber:[self.mHomeNumber intValue]];
    [self.navigationController pushViewController:homeEntry animated:NO];
}

-(void) compareButtonTapped
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:Nil];
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
