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
        self.mLoanInterestRate = 0;
        self.mLoanDuration = 0;
    }
    
    return self;
}
@end
