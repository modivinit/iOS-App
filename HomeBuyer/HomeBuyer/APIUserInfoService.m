//
//  APIUserInfoService.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/17/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "APIUserInfoService.h"
#import "AppDelegate.h"

@implementation APIUserInfoService

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
    FatFractal *ff = [AppDelegate ff];
    [ff updateObj:currentPFInfo onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        // handle error, response
        if(!err && obj)
        {
            [[kunanceUser getInstance] updateUserPFInfo:(userPFInfo*)obj];
            if([kunanceUser getInstance].mkunanceUserPFInfo.mFixedCostsInfoEntered)
            {
                NSLog(@"User profile status = ProfileStatusUserExpensesInfoEntered");
            }
        }
        else
        {
            [kunanceUser getInstance].mkunanceUserPFInfo.mFixedCostsInfoEntered = NO;
            NSLog(@"Error updating User PF Info %@", err);
        }
        
        if(self.mAPIUserInfoServiceDelegate && [self.mAPIUserInfoServiceDelegate respondsToSelector:@selector(finishedWritingUserPFInfo)])
        {
            [self.mAPIUserInfoServiceDelegate finishedWritingUserPFInfo];
        }

    }];
}

-(void) createUserPFObj:(userPFInfo*) currentPFInfo
{
    FatFractal *ff = [AppDelegate ff];
    [ff createObj:currentPFInfo atUri:@"/UserPFInfo" onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        // handle error, response
        if(obj)
        {
            [[kunanceUser getInstance] updateUserPFInfo:(userPFInfo*)obj];
        }
        else
        {
            NSLog(@"Error creating User PF Info: %@", err);
        }
        
        if(self.mAPIUserInfoServiceDelegate && [self.mAPIUserInfoServiceDelegate respondsToSelector:@selector(finishedWritingUserPFInfo)])
        {
            [self.mAPIUserInfoServiceDelegate finishedWritingUserPFInfo];
        }

    }];
}

-(BOOL) readUserPFInfo
{
    FatFractal *ff = [AppDelegate ff];
    __block userPFInfo* aUserPFInfp = nil;
 
    NSString* userGUID = [kunanceUser getInstance].mKunanceUserGUID;
    
    if(!userGUID)
        return NO;
    
    NSString* queryURI  = [NSString stringWithFormat:@"/UserPFInfo/(createdBy eq '%@')", userGUID];
    NSLog(@"queryuri = %@", queryURI);
    
    [ff getObjFromUri:queryURI onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if(theObj)
        {
            aUserPFInfp = (userPFInfo*) theObj;
            [kunanceUser getInstance].mUserPFInfoGUID = [[ff metaDataForObj:aUserPFInfp] guid];
            
            NSLog(@"readUserPFInfo: user annul gross = %llu", aUserPFInfp.mGrossAnnualIncome);
            if(aUserPFInfp && [kunanceUser getInstance].mUserPFInfoGUID)
            {
                [[kunanceUser getInstance] updateUserPFInfo:aUserPFInfp];
            }
        }
        
        if(self.mAPIUserInfoServiceDelegate && [self.mAPIUserInfoServiceDelegate respondsToSelector:@selector(finishedReadingUserPFInfo)])
        {
            [self.mAPIUserInfoServiceDelegate finishedReadingUserPFInfo];
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
        self.mAPIUserInfoServiceDelegate = nil;
    }
    
    return self;
}
@end
