//
//  APILoanInfoService.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "APILoanInfoService.h"

@implementation APILoanInfoService

-(BOOL) writeLoanInfo:(loan*) aLoanInfo
{
    if(!aLoanInfo || !aLoanInfo.mDownPayment || !aLoanInfo.mLoanInterestRate)
        return NO;
    loan* exisitingLoan = [kunanceUser getInstance].mKunanceUserLoan;
    if(exisitingLoan)
    {
        return [self updateLoanInfo:aLoanInfo];
    }
    else
    {
        return [self createLoanInfo:aLoanInfo];
    }
    
    return YES;
}

-(BOOL) updateLoanInfo:(loan*) aLoan
{
    if(!aLoan)
        return NO;
    
    FatFractal *ff = [FatFractal main];
    [ff createObj:aLoan atUri:@"/loanInfo" onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        // handle error, response
        [self updateUserCacheWithLoan:(loan*)obj error:err];
    }];
    
    return YES;
}

-(BOOL) createLoanInfo:(loan*) aLoan
{
    if(!aLoan)
        return NO;
    
    FatFractal *ff = [FatFractal main];
    [ff createObj:aLoan atUri:@"/loanInfo" onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        // handle error, response
        
        [self updateUserCacheWithLoan:(loan*)obj error:err];
        if(err)
        {
            NSLog(@"Error adding loan grabbag");
        }
        else
        {
            NSLog(@"Added loan grabbag successfully");
        }

    }];

    return YES;
}

-(void) updateUserCacheWithLoan:(loan*)theLoan error:(NSError*) err
{
    if(!err && theLoan)
    {
        if(![kunanceUser getInstance].mKunanceUserLoan)
        {
            FatFractal *ff = [FatFractal main];
            [ff grabBagAdd:theLoan to:[kunanceUser getInstance].mLoggedInKunanceUser grabBagName:@"loans" error:&err];
        }

        [[kunanceUser getInstance] updateLoanInfo:theLoan];
    }
    else
    {
        NSLog(@"Error creating loan Info: %@", err);
    }
    
    if(self.mAPILoanInfoDelegate && [self.mAPILoanInfoDelegate respondsToSelector:@selector(finishedWritingLoanInfo)])
    {
        [self.mAPILoanInfoDelegate finishedWritingLoanInfo];
    }
}

-(BOOL) readLoanInfo
{
    if(![kunanceUser getInstance].mLoggedInKunanceUser)
    {
        NSLog(@"Error: readHomesInfo: No associated user!");
        return NO;
    }
    
    FatFractal* ff = [FatFractal main];
    
    NSError *err;
    NSArray *userLoans = [ff grabBagGetAllForObj:[kunanceUser getInstance].mLoggedInKunanceUser grabBagName:@"loans" error:&err];
    if(!err && userLoans)
    {
        NSLog(@"Success, number of loans = %d", userLoans.count);
        for (loan* aLoan in userLoans)
        {
            [[kunanceUser getInstance] updateLoanInfo:aLoan];
        }
        
        return YES;
    }
    else
        return NO;
}

@end