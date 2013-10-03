//
//  APIHomeInfoService.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/1/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "APIHomeInfoService.h"

@implementation APIHomeInfoService

-(BOOL) createNewHomeInfo:(homeInfo*) aHomeInfo
{
    if(!aHomeInfo || !aHomeInfo.mIdentifiyingHomeFeature || !aHomeInfo.mHomeListPrice || !aHomeInfo.mHomeId)
        return NO;

    FatFractal *ff = [FatFractal main];
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
    
    return YES;
}

-(BOOL) readHomesInfo
{
    if(![kunanceUser getInstance].mLoggedInKunanceUser)
    {
        NSLog(@"Error: readHomesInfo: No associated user!");
        return NO;
    }
    
    FatFractal* ff = [FatFractal main];
    
    NSError *err;
    NSArray *userHomes = [ff grabBagGetAllForObj:[kunanceUser getInstance].mLoggedInKunanceUser grabBagName:@"homes" error:&err];
    if(!err && userHomes)
    {
        NSLog(@"Success, number of homes = %d", userHomes.count);
        for (homeInfo* aHome in userHomes)
        {
            [[kunanceUser getInstance] addNewHomeInfo:aHome];
        }
        
        return YES;
    }
    else
        return NO;
}

@end
