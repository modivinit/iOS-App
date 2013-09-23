//
//  userFixedExpensesInfo.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "userFixedExpensesInfo.h"

@implementation userFixedExpensesInfo

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mCurrentMonthlyRent = 0;
        self.mCurrentCarPayment = 0;
        self.mOtherExpenses = 0;
        self.mUserExpensesGUID = nil;
    }
    
    return self;
}
@end
