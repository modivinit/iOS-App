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
        [self updateUserPfObj:currentPFInfo];
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
    }];
}

-(void) createUserPFObj:(userPFInfo*) currentPFInfo
{
    FatFractal *ff = [FatFractal main];
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
    }];
}

-(BOOL) readUserPFInfo
{
    FatFractal* ff = [FatFractal main];
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
            aUserPFInfp.mUserPFInfoGUID = [[ff metaDataForObj:aUserPFInfp] guid];
            
            if(aUserPFInfp && aUserPFInfp.mUserPFInfoGUID)
            {
                [kunanceUser getInstance].mkunanceUserPFInfo = aUserPFInfp;
                [kunanceUser getInstance].mUserProfileStatus = ProfileStatusUserPersonalFinanceInfoEntered;
                
                if(self.mAPIServiceDelegate && [self.mAPIServiceDelegate respondsToSelector:@selector(userPFInfoReadSuccessfully)])
                {
                    [self.mAPIServiceDelegate userPFInfoReadSuccessfully];
                }
            }
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
