//
//  userLoansInfo.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "usersLoansList.h"
#import "loan.h"

@implementation usersLoansList

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mUsersLoans = nil;
    }
    
    return self;
}
@end
