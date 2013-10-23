//
//  APIUserInfoService.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/17/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "APIUserInfoService.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation APIUserInfoService

-(PFObject*) getParseObjectForUserPFInfo:(userPFInfo*) userPfInfo
{
    if(!userPfInfo)
        return nil;
    
    PFObject* parseUserPFInfo = [PFObject objectWithClassName:@"UserProfile"];
    parseUserPFInfo[@"MaritalStatus"] = [NSNumber numberWithInt:userPfInfo.mMaritalStatus];
    parseUserPFInfo[@"AnnualGrossIncome"] = [NSNumber numberWithInt:userPfInfo.mGrossAnnualIncome];
    parseUserPFInfo[@"AnnualRetirementSavings"] = [NSNumber numberWithInt:userPfInfo.mAnnualRetirementSavingsContributions];
    
    if(userPfInfo.mFixedCostsInfoEntered)
    {
        parseUserPFInfo[@"MonthlyRent"] = [NSNumber numberWithInt:userPfInfo.mCurrentMonthlyRent];
        parseUserPFInfo[@"CarPayments"] = [NSNumber numberWithInt:userPfInfo.mCurrentCarPayment];
        parseUserPFInfo[@"OtherMonthlyExpenses"] = [NSNumber numberWithInt:userPfInfo.mOtherMonthlyExpenses];
    }
    
    return parseUserPFInfo;
}

-(userPFInfo*) getUserPFInfoFromParseObject:(PFObject*) paarseObj
{
    return nil;
}

-(BOOL) writeFixedCostsInfo:(UInt64)enteredMonthlyRent
          monthlyCarPaments:(UInt64)enteredCarPayments
            otherFixedCosts:(UInt64)enteredOtherCosts
{
    userPFInfo* currentPFInfo = [kunanceUser getInstance].mkunanceUserPFInfo;
    
    if(!currentPFInfo)
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
    
    if([kunanceUser getInstance].mkunanceUserPFInfo)
    {
        [self updateUserPfObj:currentPFInfo];
    }
    else
    {
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
        }
        else
        {
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
    PFObject* userProfile = nil; //[self getPFObjectForUserPFInfo:currentPFInfo];
    
    [userProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
       // handle error, response
        if(succeeded)
        {
            [[kunanceUser getInstance] updateUserPFInfo:(userPFInfo*)nil];
        }
        else
        {
            NSLog(@"Error creating User PF Info:");
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
            NSLog(@"readUserPFInfo: user annul gross = %llu", aUserPFInfp.mGrossAnnualIncome);
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
