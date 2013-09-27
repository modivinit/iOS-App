//
//  APIService.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/17/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "APIService.h"

static APIService* apiServiceSingleton;

@implementation APIService

-(BOOL) writeFixedCostsInfo:(UInt64)enteredMonthlyRent
          monthlyCarPaments:(UInt64)enteredCarPayments
            otherFixedCosts:(UInt64)enteredOtherCosts
{
    userPFInfo* currentPFInfo = [kunanceUser getInstance].mkunanceUserPFInfo;
    
    if(!currentPFInfo || ![kunanceUser getInstance].mUserPFInfoGUID)
    {
        NSLog(@"We should not be here. Cannot write fixed costs without user PF info");
        return NO;
    }
    
    currentPFInfo.mCurrentMonthlyRent = enteredMonthlyRent;
    currentPFInfo.mCurrentCarPayment = enteredCarPayments;
    currentPFInfo.mOtherMonthlyExpenses = enteredOtherCosts;
    currentPFInfo.mFixedCostsInfoEntered = YES;
    
    [self updateUserPfObj:currentPFInfo];
    
    return YES;
}

-(BOOL) writeUserPFInfo:(UInt64)annualGross
       annualRetirement:(UInt64)annualRetirement
       numberOfChildren:(uint)numberOfChildren
          maritalStatus:(userMaritalStatus) status
{
    if(!annualGross)
        return NO;
    
    userPFInfo* currentPFInfo = [kunanceUser getInstance].mkunanceUserPFInfo;
    
    if(!currentPFInfo)
    {
        currentPFInfo = [[userPFInfo alloc] init];
    }
    
    currentPFInfo.mGrossAnnualIncome = annualGross;
    currentPFInfo.mAnnualRetirementSavingsContributions = annualRetirement;
    currentPFInfo.mNumberOfChildren = numberOfChildren;
    currentPFInfo.mMaritalStatus = status;
    
    if([kunanceUser getInstance].mkunanceUserPFInfo && [kunanceUser getInstance].mUserPFInfoGUID)
    {
        [self updateUserPfObj:currentPFInfo];
    }
    else
    {
        userPFInfo* currentPFInfo = [[userPFInfo alloc] init];
        [self createUserPFObj:currentPFInfo];
    }
    
    return YES;
}

-(void) updateUserPfObj:(userPFInfo*) currentPFInfo
{
    FatFractal *ff = [FatFractal main];
    [ff updateObj:currentPFInfo onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        // handle error, response
        if(obj)
        {
            [[kunanceUser getInstance] updateUserPFInfo:(userPFInfo*)obj];
        }
        else
        {
            NSLog(@"Error updating User PF Info %@", err);
        }
        
        if(self.mAPIServiceDelegate && [self.mAPIServiceDelegate respondsToSelector:@selector(finishedWritingUserPFInfo)])
        {
            [self.mAPIServiceDelegate finishedWritingUserPFInfo];
        }

    }];
}

-(void) createUserPFObj:(userPFInfo*) currentPFInfo
{
    FatFractal *ff = [FatFractal main];
    [ff createObj:currentPFInfo atUri:@"/UserPFInfo-test" onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        // handle error, response
        if(obj)
        {
            [[kunanceUser getInstance] updateUserPFInfo:(userPFInfo*)obj];
        }
        else
        {
            NSLog(@"Error creating User PF Info: %@", err);
        }
    }];
}

-(BOOL) readUserPFInfo
{
    FatFractal* ff = [FatFractal main];
    __block userPFInfo* aUserPFInfp = nil;
 
    NSString* userGUID = [kunanceUser getInstance].mKunanceUserGUID;
    
    if(!userGUID)
        return NO;
    
    NSString* queryURI  = [NSString stringWithFormat:@"/UserPFInfo-test/(createdBy eq '%@')", userGUID];
    NSLog(@"queryuri = %@", queryURI);
    
    [ff getObjFromUri:queryURI onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if(theObj)
        {
            aUserPFInfp = (userPFInfo*) theObj;
            [kunanceUser getInstance].mUserPFInfoGUID = [[ff metaDataForObj:aUserPFInfp] guid];
            
            if(aUserPFInfp && [kunanceUser getInstance].mUserPFInfoGUID)
            {
                [kunanceUser getInstance].mkunanceUserPFInfo = aUserPFInfp;
                
                if(aUserPFInfp.mFixedCostsInfoEntered)
                    [kunanceUser getInstance].mUserProfileStatus = ProfileStatusUserExpensesInfoEntered;
                else
                    [kunanceUser getInstance].mUserProfileStatus = ProfileStatusUserPersonalFinanceInfoEntered;
            }
        }
        
        if(self.mAPIServiceDelegate && [self.mAPIServiceDelegate respondsToSelector:@selector(finishedReadingUserPFInfo)])
        {
            [self.mAPIServiceDelegate finishedReadingUserPFInfo];
        }
    }];
    
    return YES;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        // Initialization
        self.mAPIServiceDelegate = nil;
    }
    
    return self;
}
@end
