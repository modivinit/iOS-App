//
//  LoanInfoViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LoanInfoViewController.h"


@interface LoanInfoViewController ()

@end

@implementation LoanInfoViewController

- (id)initWithExisitingLoan:(loan*) aLoan
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        if(aLoan)
            self.mCorrespondingLoan = aLoan;
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
    loan* aLoan = [kunanceUser getInstance].mKunanceUserLoan;
    if(aLoan)
    {
        self.mPercentDollarValueChoice.selectedSegmentIndex = aLoan.mDownPaymentType;
        self.mDownPaymentField.text = [NSString  stringWithFormat:@"%.2f", aLoan.mDownPayment];
        
        self.mInterestRateField.text = [NSString stringWithFormat:@"%.2f", aLoan.mLoanInterestRate];
        
        self.mLoanDurationField.selectedSegmentIndex = [loan getIndexForLoanDuration:aLoan.mLoanDuration];
    }
}

- (void)viewDidLoad
{
    self.mFormFields = [[NSArray alloc] initWithObjects:self.mDownPaymentField, self.mInterestRateField, nil];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];
    
    UITapGestureRecognizer* compareHomesGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(compareHomeButtonTapped:)];
    [self.mCompareHomesViewAsButton addGestureRecognizer:compareHomesGesture];
    
    self.mPercentDollarValueChoice.selectedSegmentIndex = PERCENT_VALUE_DOWN_PAYMENT;
    
    [self.mPercentDollarValueChoice addTarget:self
                                       action:@selector(percentDollarChoiceChanged)
                             forControlEvents:UIControlEventValueChanged];
    
    self.mLoanDurationField.selectedSegmentIndex = DEFAULT_LOAN_DURATION_IN_YEARS;
    
    [self setupWithExisitingLoan];
}

#pragma mark actions. gestures
-(void) compareHomeButtonTapped:(UITapGestureRecognizer*) gesture
{
    if(!self.mDownPaymentField.text || !self.mInterestRateField.text)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter all the fields"];
        return;
    }
    
    loan* newLoanInfo = [[loan alloc] init];
    
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
    
    
    APILoanInfoService* loanInfoService = [[APILoanInfoService alloc] init];
    if(loanInfoService)
    {
        loanInfoService.mAPILoanInfoDelegate = self;
        if(![loanInfoService writeLoanInfo:newLoanInfo])
        {
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Sorry unable to update loan info"];
            return;
        }
    }

}

-(void) percentDollarChoiceChanged
{
    [self updateDownPaymentFields];
}
#pragma end

#pragma APILoanInfoDelegate
-(void) finishedWritingLoanInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayDashNotification object:nil];
}
#pragma end
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
