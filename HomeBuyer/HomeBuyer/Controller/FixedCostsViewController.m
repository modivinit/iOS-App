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
    
    [self addGestureRecognizers];
    [self.mFormScrollView setContentSize:CGSizeMake(320, 260)];
    [self.mFormScrollView setContentOffset:CGPointMake(0, 80)];
    [self initWithExisitingFixedCosts];
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
    if(!self.mMonthlyRent.text || !self.mMonthlyCarPayments.text || !self.mOtherMonthlyPayments.text ||
       !self.mMonthlyRent.text.length || !self.mMonthlyCarPayments.text.length || !self.mOtherMonthlyPayments.text.length)
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
        hud.labelText = @"Uploading";

        if(![userProfileInfo writeFixedCostsInfo:[self.mMonthlyRent.text intValue]
                   monthlyCarPaments:[self.mMonthlyCarPayments.text intValue]
                     otherFixedCosts:[self.mOtherMonthlyPayments.text intValue]])
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
