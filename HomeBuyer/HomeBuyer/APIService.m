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

-(BOOL) readUserExpensesInfo
{
    FatFractal* ff = [FatFractal main];
    __block userFixedExpensesInfo* aUserExpensesInfo = nil;
    
    NSString* userGUID = [kunanceUser getInstance].mKunanceUserGUID;
    
    if(!userGUID)
        return NO;
    
    NSString* queryURI  = [NSString stringWithFormat:@"/UserExpensesInfo/(createdBy eq '%@')", userGUID];
    NSLog(@"queryuri = %@", queryURI);
    
    [ff getObjFromUri:queryURI onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
         if(theObj)
         {
             aUserExpensesInfo = (userFixedExpensesInfo*) theObj;
             aUserExpensesInfo.mUserExpensesGUID = [[ff metaDataForObj:aUserExpensesInfo] guid];
             
             if(aUserExpensesInfo && aUserExpensesInfo.mUserExpensesGUID)
             {
                 [kunanceUser getInstance].mkunanceUserFixedExpenses = aUserExpensesInfo;
                 [kunanceUser getInstance].mUserProfileStatus = ProfileStatusUserExpensesInfoEntered;
                 
                 if(self.mAPIServiceDelegate && [self.mAPIServiceDelegate respondsToSelector:@selector(userExpensesInfoReadSuccessfully)])
                 {
                     [self.mAPIServiceDelegate userExpensesInfoReadSuccessfully];
                 }
             }
         }
     }];
    
    return YES;
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
