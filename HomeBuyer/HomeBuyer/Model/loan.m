//
//  loan.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "loan.h"

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

+(uint) getLoanDurationForIndex:(uint) index
{
    switch (index) {
        case loanDurationTenYears:
            return 10;
            break;

        case loanDurationFifteenYears:
            return 15;
            break;

        case loanDurationTwentyYears:
            return 20;
            break;

        case loanDurationThirtyYears:
            return 30;
            break;

        default:
            return 30;
    }
}

@end
