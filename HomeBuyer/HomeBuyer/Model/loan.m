//
//  loan.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "loan.h"

static NSString* const kLoanDownPaymentKey = @"DownPaymentKey";
static NSString* const kDownPaymentTypeKey = @"DownPaymentTypeKey";
static NSString* const kLoanInterestKey = @"LoanInterestKey";
static NSString* const kLoanDurationKey = @"LoanDurationKey";

@implementation loan
-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mDownPayment = 0;
        self.mDownPaymentType = PERCENT_VALUE_DOWN_PAYMENT;
        self.mLoanInterestRate = 0;
        self.mLoanDuration = 0;
    }
    
    return self;
}

-(id) initWithDictionary:(NSDictionary*) dict
{
    self = [super init];
    
    if(self)
    {
        if(!dict)
            return self;
        
        self.mDownPayment = [dict[kLoanDownPaymentKey] floatValue];
        self.mDownPaymentType = [dict[kDownPaymentTypeKey] integerValue];
        self.mLoanInterestRate = [dict[kLoanInterestKey] floatValue];
        self.mLoanDuration = [dict[kLoanDurationKey] integerValue];
    }
    
    return self;

}

-(NSDictionary*) getDictionaryObjectWithLoan
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    dict[kLoanDownPaymentKey] = [NSNumber numberWithFloat:self.mDownPayment];
    dict[kDownPaymentTypeKey] = [NSNumber numberWithInt:self.mDownPaymentType];
    dict[kLoanDurationKey] = [NSNumber numberWithInt:self.mLoanDuration];
    dict[kLoanInterestKey] = [NSNumber numberWithFloat:self.mLoanInterestRate];
    
    return dict;
}

+(uint) getLoanDurationForIndex:(uint) index
{
    switch (index) {
        case loanDurationTenYears:
            return LOAN_DURATION_10_YEARS;
            break;

        case loanDurationFifteenYears:
            return LOAN_DURATION_15_YEARS;
            break;

        case loanDurationTwentyYears:
            return LOAN_DURATION_20_YEARS;
            break;

        case loanDurationThirtyYears:
            return LOAN_DURATION_30_YEARS;
            break;

        default:
            return LOAN_DURATION_30_YEARS;
    }
}

+(uint) getIndexForLoanDuration:(uint) loanDuration
{
    switch (loanDuration) {
        case LOAN_DURATION_10_YEARS:
            return loanDurationTenYears;
            
        case LOAN_DURATION_15_YEARS:
            return loanDurationFifteenYears;
            
        case LOAN_DURATION_20_YEARS:
            return loanDurationTwentyYears;
            
        case LOAN_DURATION_30_YEARS:
            return loanDurationThirtyYears;
            
        default:
            return loanDurationThirtyYears;
    }
}
@end
