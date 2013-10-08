//
//  DashUserPFInfoViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashUserPFInfoViewController.h"
#import "HelpDashboardViewController.h"

@interface DashUserPFInfoViewController ()

@end

@implementation DashUserPFInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) addGestureRecognizers
{
    UITapGestureRecognizer* homeInfoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addHomeInfo)];
    [self.mAddAHomeViewAsButton addGestureRecognizer:homeInfoGesture];
    
    UITapGestureRecognizer* helpTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(helpButtonTapped)];
    [self.mHelpImageAsButton addGestureRecognizer:helpTapGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* titleText = [NSString stringWithFormat:@"Current Lifestyle Income"];
    self.navigationController.navigationBar.topItem.title = titleText;
    // Do any additional setup after loading the view from its nib.
    [self addGestureRecognizers];
}


#pragma mark actions, gestures
-(void) helpButtonTapped
{
    HelpDashboardViewController* dashHelp = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:dashHelp animated:NO];
}

-(IBAction)dashButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayDashNotification object:nil];
}

-(void) addHomeInfo
{
    self.mHomeInfoViewController = [[HomeInfoViewController alloc] initAsHomeNumber:FIRST_HOME];
    self.mHomeInfoViewController.mHomeInfoViewDelegate = self;
    [self.navigationController pushViewController:self.mHomeInfoViewController animated:NO];
}
#pragma end

#pragma HomeInfoViewDelegate
-(void) loanInfoButtonTapped
{
    self.mLoanInfoViewController = [[LoanInfoViewController alloc] init];
    self.mLoanInfoViewController.mLoanInfoViewDelegate = self;
    [self.navigationController pushViewController:self.mLoanInfoViewController animated:NO];
}
#pragma end


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
