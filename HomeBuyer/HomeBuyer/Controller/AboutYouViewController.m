//
//  AboutYouViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/15/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "AboutYouViewController.h"
#import "userPFInfo.h"
#import "kunanceUser.h"
#import "HelpProfileViewController.h"

@interface AboutYouViewController ()

@end

@implementation AboutYouViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.mSelectedMaritalStatus = StatusNotDefined;
        self.mFixedCostsController = nil;
    }
    
    return self;
}

-(void) selectMarried
{
    self.mMarriedImageAsButton.image = [UIImage imageNamed:@"couple-selected.png"];
    self.mSingleImageAsButton.image = [UIImage imageNamed:@"single.png"];
    
    self.mSelectedMaritalStatus = StatusMarried;
}

-(void) selectSingle
{
    self.mSingleImageAsButton.image = [UIImage imageNamed:@"single-selected.png"];
    self.mMarriedImageAsButton.image = [UIImage imageNamed:@"couple.png"];

    self.mSelectedMaritalStatus = StatusSingle;
}

-(void) setupGestureRecognizers
{
    UITapGestureRecognizer* marriedButtonTappedGesture = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(marriedButtonTapped)];
    [self.mMarriedImageAsButton addGestureRecognizer:marriedButtonTappedGesture];

    UITapGestureRecognizer* singleButtonTappedGesture = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self
                                                                 action:@selector(singleButtonTapped)];
    [self.mSingleImageAsButton addGestureRecognizer:singleButtonTappedGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void) initWithCurrentUserPFInfo
{
    userPFInfo* theUserPFInfo = [kunanceUser getInstance].mkunanceUserPFInfo;
    if(theUserPFInfo)
    {
        NSLog(@"initWithCurrentUserPFInfo: user annul gross = %llu", theUserPFInfo.mGrossAnnualIncome);

        if(theUserPFInfo.mMaritalStatus == StatusMarried)
            [self selectMarried];
        
        else if(theUserPFInfo.mMaritalStatus == StatusSingle)
            [self selectSingle];
        
        if(theUserPFInfo.mGrossAnnualIncome)
            self.mAnnualGrossIncomeField.text =
            [NSString stringWithFormat:@"%llu", theUserPFInfo.mGrossAnnualIncome];
        
        if(theUserPFInfo.mAnnualRetirementSavingsContributions)
            self.mAnnualRetirementContributionField.text =
            [NSString stringWithFormat:@"%llu", theUserPFInfo.mAnnualRetirementSavingsContributions];
        
        self.mNumberOfChildrenControl.selectedSegmentIndex = theUserPFInfo.mNumberOfChildren;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];
}

- (void)viewDidLoad
{
    self.mFormFields = [[NSArray alloc] initWithObjects:self.mAnnualGrossIncomeField,
                        self.mAnnualRetirementContributionField, nil];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];
    [self.mFormScrollView setContentOffset:CGPointMake(0, 80)];
    [self setupGestureRecognizers];
    [self initWithCurrentUserPFInfo];
    
    self.navigationItem.title = @"Profile";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark action functions
//IBActions, action target methods, gesture targets

-(IBAction)helpButtonTapped:(id)sender
{
    HelpProfileViewController* hPV = [[HelpProfileViewController alloc] init];
    [self.navigationController pushViewController:hPV animated:NO];
}

-(IBAction)dashButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

-(void) marriedButtonTapped
{
    [self selectMarried];
}

-(void) singleButtonTapped
{
    [self selectSingle];
}

-(IBAction)fixedCostsButtonTapped:(id)sender
{
    if(self.mSelectedMaritalStatus == StatusNotDefined)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please pick a marital status"];
        return;
    }
    else if(!self.mAnnualGrossIncomeField.text ||
            !self.mAnnualGrossIncomeField.text.length ||
            ![self.mAnnualGrossIncomeField.text intValue])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter Annual income"];
        return;
    }
    
    APIUserInfoService* apiUserInfoService = [[APIUserInfoService alloc] init];
    if(apiUserInfoService)
    {
        apiUserInfoService.mAPIUserInfoServiceDelegate = self;
        if(![apiUserInfoService writeUserPFInfo:[self.mAnnualGrossIncomeField.text intValue]
                   annualRetirement:[self.mAnnualRetirementContributionField.text intValue]
                   numberOfChildren:self.mNumberOfChildrenControl.selectedSegmentIndex
                      maritalStatus:self.mSelectedMaritalStatus])
        {
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to update your fixed costs info"];
        }
    }
}

#pragma mark APIUserInfoServiceDelegate
-(void) finishedWritingUserPFInfo
{
    if([kunanceUser getInstance].mkunanceUserPFInfo)
    {
        NSLog(@"finishedWritingUserPFInfo: user annul gross = %llu",
              [kunanceUser getInstance].mkunanceUserPFInfo.mGrossAnnualIncome);
        if(!self.mFixedCostsController)
            self.mFixedCostsController = [[FixedCostsViewController alloc] init];
        self.mFixedCostsController.mFixedCostsControllerDelegate = self;
        [self.navigationController pushViewController:self.mFixedCostsController animated:NO];
        
    }
    else
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sorry, unable to update you info"];
    }
}
#pragma end

#pragma mark FixedCostsControllerDelegate
-(void) aboutYouFromFixedCosts
{
    if(self.mFixedCostsController)
        [self.navigationController popViewControllerAnimated:NO];
}
#pragma end
@end
