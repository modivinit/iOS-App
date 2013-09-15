//
//  homeInfo.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "homeInfo.h"

@implementation homeInfo

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mHomeType = 0;
        self.mIdentifiyingHomeFeature = nil;
        self.mHOAFees = 0;
        self.mHomeAddress = nil;
        self.mHomeListPrice = 0;
        self.mIdentifiyingHomeFeature = nil;
        self.mMonthlyLoanPayment = 0;
    }
    
    return self;
}

@end
