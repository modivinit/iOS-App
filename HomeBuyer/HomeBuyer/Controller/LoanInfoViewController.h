//
//  LoanInfoViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"
#import "loan.h"
#import "APILoanInfoService.h"

@protocol LoanInfoViewDelegate <NSObject>
-(void) compareHomesButtonTappedFromLoanInfoView;
@end

@interface LoanInfoViewController : FormViewController <APILoanInfoServiceDelegate>

@property (nonatomic, strong) loan* mCorrespondingLoan;

@property (nonatomic, strong) IBOutlet UISegmentedControl* mPercentDollarValueChoice;
@property (nonatomic, strong) IBOutlet UITextField*        mDownPaymentField;
@property (nonatomic, strong) IBOutlet UITextField*        mInterestRateField;
@property (nonatomic, strong) IBOutlet UISegmentedControl* mLoanDurationField;

@property (nonatomic, strong) IBOutlet UIView*             mCompareHomesViewAsButton;

@property (nonatomic, weak) id <LoanInfoViewDelegate> mLoanInfoViewDelegate;
@end
