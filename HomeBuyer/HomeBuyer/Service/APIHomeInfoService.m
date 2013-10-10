//
//  APIHomeInfoService.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/1/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "APIHomeInfoService.h"
#import "AppDelegate.h"

@implementation APIHomeInfoService

-(BOOL) createNewHomeInfo:(homeInfo*) aHomeInfo
{
    if(!aHomeInfo || !aHomeInfo.mIdentifiyingHomeFeature || !aHomeInfo.mHomeListPrice || !aHomeInfo.mHomeId)
        return NO;

    FatFractal *ff = [AppDelegate ff];
    [ff createObj:aHomeInfo atUri:@"/HomeInfo" onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        // handle error, response
        if(obj)
        {
            NSError* err;
            [ff grabBagAdd:obj to:[kunanceUser getInstance].mLoggedInKunanceUser grabBagName:@"homes" error:&err];
            if(err)
            {
                NSLog(@"Error adding home grabbag");
            }
            else
            {
                NSLog(@"Added home grabbag successfully");
                [[kunanceUser getInstance] addNewHomeInfo:(homeInfo*)obj];
            }
        }
        else
        {
            NSLog(@"Error creating Home Info: %@", err);
        }
        
        if(self.mAPIHomeInfoDelegate && [self.mAPIHomeInfoDelegate respondsToSelector:@selector(finishedWritingHomeInfo)])
        {
            [self.mAPIHomeInfoDelegate finishedWritingHomeInfo];
        }
        
    }];


    return YES;
}

-(BOOL) updateExistingHomeInfo:(homeInfo*) aHomeInfo
{
    if(!aHomeInfo || !aHomeInfo.mIdentifiyingHomeFeature || !aHomeInfo.mHomeListPrice)
        return NO;
    
    FatFractal *ff = [AppDelegate ff];
    NSLog(@"Updating homeinfo object at: %@", aHomeInfo);
    [ff updateObj:aHomeInfo onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse)
    {
        if(!err && obj)
        {
            [[kunanceUser getInstance] updateExistingHome:(homeInfo*)obj];
        }
    }];
    
    if(self.mAPIHomeInfoDelegate &&
       [self.mAPIHomeInfoDelegate respondsToSelector:@selector(finishedWritingHomeInfo)])
    {
        [self.mAPIHomeInfoDelegate finishedWritingHomeInfo];
    }

    return YES;
}

-(BOOL) readHomesInfo
{
    if(![kunanceUser getInstance].mLoggedInKunanceUser)
    {
        NSLog(@"Error: readHomesInfo: No associated user!");
        return NO;
    }
    
    FatFractal *ff = [AppDelegate ff];    
    NSString* userGUID = [kunanceUser getInstance].mKunanceUserGUID;
    
    if(!userGUID)
        return NO;
    
    NSString* queryURI  = [NSString stringWithFormat:@"/HomeInfo/(createdBy eq '%@')", userGUID];
    NSLog(@"queryuri = %@", queryURI);

    //[ff grabBagGetAllForObj:[kunanceUser getInstance].mLoggedInKunanceUser grabBagName:@"homes" error:&err];
    [ff getArrayFromUri:queryURI onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
     {
        if(!theErr && theObj)
        {
            NSArray* userHomes = theObj;
            NSLog(@"Success, number of homes = %d", userHomes.count);
            for (homeInfo* aHome in userHomes)
            {
                NSLog(@"aHome = %@ with %@", aHome, aHome.mIdentifiyingHomeFeature);
                [[kunanceUser getInstance] addNewHomeInfo:aHome];
                //FFMetaData* metaData = [[AppDelegate ff] metaDataForObj:aHome];
            }
            
            if(self.mAPIHomeInfoDelegate &&
               [self.mAPIHomeInfoDelegate respondsToSelector:@selector(finishedReadingHomeInfo)])
            {
                [self.mAPIHomeInfoDelegate finishedReadingHomeInfo];
            }

        }
     }];
    
    return YES;
}

@end
