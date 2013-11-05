//
//  ExpensesViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/16/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "FixedCostsViewController.h"
#import "kunanceUser.h"
#import "HelpProfileViewController.h"
#import <MBProgressHUD.h>

#define MAX_RENT_LENGTH 7
#define MAX_CAR_PAYMENTS_LENGTH 5
#define MAX_FIXED_COSTS_LENGTH  5

@interface FixedCostsViewController ()

@end

@implementation FixedCostsViewController

-(void) addGestureRecognizers
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void) initWithExisitingFixedCosts
{
    userProfileInfo* userInfo = [kunanceUser getInstance].mkunanceUserProfileInfo;
    kunanceUserProfileStatus status = [kunanceUser getInstance].mUserProfileStatus;
    
    if(!userInfo || status == ProfileStatusUndefined || status == ProfileStatusUserPersonalFinanceInfoEntered)
    {
        return;
    }
    
    if(userInfo && [userInfo isFixedCostsInfoEntered])
    {
        if([userInfo getMonthlyRentInfo])
            self.mMonthlyRent.text = [NSString stringWithFormat:@"%d", [userInfo getMonthlyRentInfo]];
        if([userInfo getCarPaymentsInfo])
            self.mMonthlyCarPayments.text = [NSString stringWithFormat:@"%d", [userInfo getCarPaymentsInfo]];
        if([userInfo getOtherFixedCostsInfo])
            self.mOtherMonthlyPayments.text = [NSString stringWithFormat:@"%d", [userInfo getOtherFixedCostsInfo]];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mFormScrollView setContentSize:CGSizeMake(320, 260)];
}

- (void)viewDidLoad
{
    NSString* titleText = [NSString stringWithFormat:@"Fixed Costs"];
    self.navigationController.navigationBar.topItem.title = titleText;

    
    self.mFormFields = [[NSArray alloc] initWithObjects:self.mMonthlyRent,
                self.mMonthlyCarPayments, self.mOtherMonthlyPayments, nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mMonthlyRent.maxLength = MAX_RENT_LENGTH;
    self.mMonthlyCarPayments.maxLength = MAX_CAR_PAYMENTS_LENGTH;
    self.mOtherMonthlyPayments.maxLength = MAX_FIXED_COSTS_LENGTH;
    
    [self addGestureRecognizers];
    [self.mFormScrollView setContentSize:CGSizeMake(320, 360)];
    [self.mFormScrollView setContentOffset:CGPointMake(0, 120)];
    [self initWithExisitingFixedCosts];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"View Fixed Costs Screen" properties:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark userProfileInfoDelegate
-(void) finishedWritingUserPFInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if([[kunanceUser getInstance].mkunanceUserProfileInfo isFixedCostsInfoEntered])
    {
        [[kunanceUser getInstance] updateStatusWithUserProfileInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
    }
    else
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sorry. Unable to connect to server"];
    }
}
#pragma end

#pragma mark Action Functions
//IBActions, target action, gesture targets
-(IBAction)aboutYouButtonTapped:(id)sender
{
    if(self.mFixedCostsControllerDelegate &&
       [self.mFixedCostsControllerDelegate respondsToSelector:@selector(aboutYouFromFixedCosts)])
       {
           [self.mFixedCostsControllerDelegate aboutYouFromFixedCosts];
       }
}

-(IBAction)helpButtonTapped:(id)sender
{
    HelpProfileViewController* hPV = [[HelpProfileViewController alloc] init];
    [self.navigationController pushViewController:hPV animated:NO];
}

-(IBAction)dashButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

-(IBAction)currentLifeStyleIncomeTapped:(id)sender
{
    if(self.mMonthlyRent.amount <= 0 || self.mMonthlyCarPayments.amount <= 0 ||
       self.mOtherMonthlyPayments.amount <= 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter all fields"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }

    userProfileInfo* userProfileInfo = [kunanceUser getInstance].mkunanceUserProfileInfo;
    if(userProfileInfo)
    {
        userProfileInfo.mUserProfileInfoDelegate =self;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Calculating";

        if(![userProfileInfo writeFixedCostsInfo:[self.mMonthlyRent.amount intValue]
                   monthlyCarPaments:[self.mMonthlyCarPayments.amount intValue]
                     otherFixedCosts:[self.mOtherMonthlyPayments.amount intValue]])
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to update your information."];
        }
    }
    else
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to update your information."];
    }
}
@end
