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
    userPFInfo* userInfo = [kunanceUser getInstance].mkunanceUserPFInfo;
    if(userInfo)
    {
        if(userInfo.mCurrentMonthlyRent)
            self.mMonthlyRent.text = [NSString stringWithFormat:@"%d", userInfo.mCurrentMonthlyRent];
        if(userInfo.mCurrentCarPayment)
            self.mMonthlyCarPayments.text = [NSString stringWithFormat:@"%d", userInfo.mCurrentCarPayment];
        if(userInfo.mOtherMonthlyExpenses)
            self.mOtherMonthlyPayments.text = [NSString stringWithFormat:@"%d", userInfo.mOtherMonthlyExpenses];
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

#pragma mark APIUserInfoServiceDelegate
-(void) finishedWritingUserPFInfo
{
    if([kunanceUser getInstance].mkunanceUserPFInfo.mFixedCostsInfoEntered)
    {
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
    
    APIUserInfoService* service = [[APIUserInfoService alloc] init];
    if(service)
    {
        service.mAPIUserInfoServiceDelegate = self;
        if(![service writeFixedCostsInfo:[self.mMonthlyRent.text intValue]
                   monthlyCarPaments:[self.mMonthlyCarPayments.text intValue]
                     otherFixedCosts:[self.mOtherMonthlyPayments.text intValue]])
        {
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to update your information."];
        }
    }
}
@end
