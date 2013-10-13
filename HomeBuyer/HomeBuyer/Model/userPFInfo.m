//
//  userPFInfo.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "userPFInfo.h"

@implementation userPFInfo
-(id) init
{
    self = [super init];
    if(self)
    {
        self.mMaritalStatus = StatusNotDefined;
        self.mGrossAnnualIncome = 0;
        self.mNumberOfChildren = 0;
        self.mAnnualRetirementSavingsContributions = 0;
        self.mCurrentMonthlyIncomeTax = 0;

        self.mFixedCostsInfoEntered = NO;
        self.mCurrentMonthlyRent = 0;
        self.mCurrentCarPayment = 0;
        self.mOtherMonthlyExpenses = 0;
    }
    
    return self;
}
@end
