//
//  LoanInfoViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LoanInfoViewController.h"
#import "HelpHomeViewController.h"
#import <MBProgressHUD.h>

@interface LoanInfoViewController ()

@end

@implementation LoanInfoViewController

-(id) initFromHomeInfoEntry:(NSNumber*) homeNumber
{
    self = [super init];
    if(self)
    {
        if(homeNumber)
            self.mHomeNumber = homeNumber;
        self.mIsFromHomeEntry = YES;
    }
    
    return self;
}

-(id) initFromMenu
{
    self = [super init];
    if(self)
    {
        self.mIsFromHomeEntry = NO;
    }
    
    return self;
}

-(void) updateDownPaymentFields
{
    if(self.mPercentDollarValueChoice.selectedSegmentIndex == PERCENT_VALUE_DOWN_PAYMENT)
    {
        self.mDownPaymentField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.mDownPaymentField.placeholder = @"% of the home list price";
    }
    else if(self.mPercentDollarValueChoice.selectedSegmentIndex == DOLLAR_VALUE_DOWN_PAYMENT)
    {
        self.mDownPaymentField.keyboardType = UIKeyboardTypeNumberPad;
        self.mDownPaymentField.placeholder = @"Fixed $ amount";
    }
}

-(void) setupWithExisitingLoan
{
    self.mCorrespondingLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    if(self.mCorrespondingLoan)
    {
        self.mPercentDollarValueChoice.selectedSegmentIndex = self.mCorrespondingLoan.mDownPaymentType;
        self.mDownPaymentField.text = [NSString  stringWithFormat:@"%.2f", self.mCorrespondingLoan.mDownPayment];
        
        self.mInterestRateField.text = [NSString stringWithFormat:@"%.2f", self.mCorrespondingLoan.mLoanInterestRate];
        
        self.mLoanDurationField.selectedSegmentIndex = [loan getIndexForLoanDuration:self.mCorrespondingLoan.mLoanDuration];
    }
}

-(void) setupButtons
{
    if(self.mIsFromHomeEntry)
    {
        self.mHomeInfoButton.enabled = YES;
        self.mHomeInfoButton.hidden = NO;
        self.mShowHomePaymentsButton.enabled = YES;
        self.mShowHomePaymentsButton.hidden = NO;
        self.mCompareHomesButton.enabled = NO;
        self.mCompareHomesButton.hidden = YES;
    }
    else
    {
        self.mHomeInfoButton.enabled = NO;
        self.mHomeInfoButton.hidden = YES;
        self.mShowHomePaymentsButton.enabled = NO;
        self.mShowHomePaymentsButton.hidden = YES;
        self.mCompareHomesButton.enabled = YES;
        self.mCompareHomesButton.hidden = NO;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];
}

- (void)viewDidLoad
{
    NSString* titleText = [NSString stringWithFormat:@"Home Loan Info"];
    self.navigationController.navigationBar.topItem.title = titleText;

    self.mFormFields = [[NSArray alloc] initWithObjects:self.mDownPaymentField, self.mInterestRateField, nil];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];
    [self.mFormScrollView setContentOffset:CGPointMake(0, 80)];

    self.mPercentDollarValueChoice.selectedSegmentIndex = PERCENT_VALUE_DOWN_PAYMENT;
    
    [self.mPercentDollarValueChoice addTarget:self
                                       action:@selector(percentDollarChoiceChanged)
                             forControlEvents:UIControlEventValueChanged];
    
    self.mLoanDurationField.selectedSegmentIndex = DEFAULT_LOAN_DURATION_IN_YEARS;
    
    [self setupWithExisitingLoan];
    [self setupButtons];
}

-(void) uploadLoanInfo
{
    if(!self.mDownPaymentField.text || !self.mInterestRateField.text)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter all the fields"];
        return;
    }
    
    loan* newLoanInfo = nil;
    
    if(self.mCorrespondingLoan)
        newLoanInfo = self.mCorrespondingLoan;
    else
        newLoanInfo = [[loan alloc] init];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setGroupingSeparator:@","];
    
    NSNumber *downPayment = [numberFormatter numberFromString:self.mDownPaymentField.text];
    if(downPayment)
        newLoanInfo.mDownPayment = [downPayment floatValue];
    
    if(self.mPercentDollarValueChoice.selectedSegmentIndex == PERCENT_VALUE_DOWN_PAYMENT && newLoanInfo.mDownPayment > 100)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"% value for downpayment cannot be > 100"];
        return;
    }
    
    newLoanInfo.mDownPaymentType = self.mPercentDollarValueChoice.selectedSegmentIndex;
    
    NSNumber *interestRate = [numberFormatter numberFromString:self.mInterestRateField.text];
    if(interestRate)
        newLoanInfo.mLoanInterestRate = [interestRate floatValue];
    if(newLoanInfo.mLoanInterestRate < 0 || newLoanInfo.mLoanInterestRate > MAX_POSSIBLE_INTEREST_RATE)
    {
        [Utilities showAlertWithTitle:@"Erro" andMessage:@"That does not appear to be a valid loan interest rate"];
        return;
    }
    
    newLoanInfo.mLoanDuration = [loan getLoanDurationForIndex:self.mLoanDurationField.selectedSegmentIndex];
    
    if(![kunanceUser getInstance].mKunanceUserLoans)
        [kunanceUser getInstance].mKunanceUserLoans = [[usersLoansList alloc] init];

    [kunanceUser getInstance].mKunanceUserLoans.mLoansListDelegate = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loggin in..";

    if(![[kunanceUser getInstance].mKunanceUserLoans writeLoanInfo:newLoanInfo])
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sorry unable to create loan info"];
        return;
    }
}

#pragma mark actions. gestures
-(IBAction)dashButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

-(IBAction)showHomePaymentButtonTapped:(id)sender
{
    [self uploadLoanInfo];
}

-(IBAction)compareHomeButtonTapped:(id)sender
{
    [self uploadLoanInfo];
}

-(void) percentDollarChoiceChanged
{
    [self updateDownPaymentFields];
}

-(IBAction)helpButtonTapped:(id)sender
{
    HelpHomeViewController* hPV = [[HelpHomeViewController alloc] init];
    [self.navigationController pushViewController:hPV animated:NO];
}

-(IBAction) homeInfoButtonTapped:(id)sender
{
    if(self.mLoanInfoViewDelegate && [self.mLoanInfoViewDelegate respondsToSelector:@selector(backToHomeInfo)])
    {
        [self.mLoanInfoViewDelegate backToHomeInfo];
    }
        
}
#pragma end

#pragma APILoanInfoDelegate
-(void) finishedWritingLoanInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [[kunanceUser getInstance] updateStatusWithLoanInfoStatus];
    if(self.mCompareHomesButton.enabled)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
    }
    else if(self.mShowHomePaymentsButton.enabled)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayHomeDashNotification object:self.mHomeNumber];
    }
}
#pragma end
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
