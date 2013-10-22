//
//  kunanceUser.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/30/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kunanceUser.h"
#import "KeychainWrapper.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

static kunanceUser *kunanceUserSingleton;

@interface kunanceUser()
@property (nonatomic, strong) PFUser* mPFUser;
@end

@implementation kunanceUser

+ (void) initialize
{
    if (self == [kunanceUser class]){
        kunanceUserSingleton = [[kunanceUser alloc] init];
    }
}

- (id) init
{
    NSAssert(kunanceUserSingleton == nil, @"Duplication initialization of singleton");
    self = [super init];
    if (self) {
        // Initialization
        self.mLoggedInKunanceUser = nil;
        self.mLoggedInKunanceUser = nil;
        self.mkunanceUserPFInfo = nil;
        self.mKunanceUserHomes = nil;
        self.mKunanceUserLoan = nil;
        self.mUserProfileStatus = ProfileStatusNoInfoEntered;
        NSLog(@"User profile status = ProfileStatusNoInfoEntered");

        self.mUserPFInfoGUID = nil;
    }
    
    return self;
}

-(void) updateUserPFInfo:(userPFInfo*) newUserPFInfo
{
    FatFractal *ff = [AppDelegate ff];
    self.mkunanceUserPFInfo = newUserPFInfo;
    
    NSLog(@"updateUserPFInfo: %llu", self.mkunanceUserPFInfo.mGrossAnnualIncome);
    
    if(newUserPFInfo)
        self.mUserPFInfoGUID = [[ff metaDataForObj:newUserPFInfo] guid];
    
    if(self.mUserProfileStatus == ProfileStatusNoInfoEntered && self.mkunanceUserPFInfo.mFixedCostsInfoEntered)
        self.mUserProfileStatus = ProfileStatusPersonalFinanceAndFixedCostsInfoEntered;
    else if(self.mUserProfileStatus == ProfileStatusNoInfoEntered)
        self.mUserProfileStatus = ProfileStatusUserPersonalFinanceInfoEntered;
    else if(self.mUserProfileStatus == ProfileStatusUserPersonalFinanceInfoEntered && self.mkunanceUserPFInfo.mFixedCostsInfoEntered)
        self.mUserProfileStatus = ProfileStatusPersonalFinanceAndFixedCostsInfoEntered;
}

-(NSString*) getFirstName
{
    NSLog(@"PFUser %@", [PFUser currentUser]);
    return [PFUser currentUser][@"FirstName"];
}

-(BOOL) isUserLoggedIn
{
    return ([[AppDelegate ff] loggedIn] &&
            [kunanceUser getInstance].mLoggedInKunanceUser);
}

-(void) saveUserInfoAfterLoginSignUp:(FFUser*)newUser passowrd:(NSString*)pswd
{
    if(!newUser || !pswd)
        return;
    
    [KeychainWrapper createKeychainValue:pswd forIdentifier:@"pswd"];
    [KeychainWrapper createKeychainValue:newUser.email forIdentifier:@"email"];
    
    self.mLoggedInKunanceUser = newUser;
    
    FatFractal *ff = [AppDelegate ff];
    if(ff)
        self.mKunanceUserGUID = [[ff metaDataForObj:newUser] guid];
}

-(void) logoutUser
{
    [KeychainWrapper deleteItemFromKeychainWithIdentifier:@"pswd"];
    [KeychainWrapper deleteItemFromKeychainWithIdentifier:@"email"];
    
    self.mLoggedInKunanceUser = nil;
    self.mLoggedInKunanceUser = nil;
    self.mkunanceUserPFInfo = nil;
    self.mKunanceUserHomes = nil;
    self.mKunanceUserLoan = nil;
    self.mUserProfileStatus = ProfileStatusNoInfoEntered;
    self.mUserPFInfoGUID = nil;
}

-(BOOL)userAccountFoundOnDevice
{
    NSData* theData = [KeychainWrapper searchKeychainCopyMatchingIdentifier:@"email"];
    if(!theData)
        return NO;
    
    NSString* emailStr = [[NSString alloc] initWithData:theData
                                              encoding:NSUTF8StringEncoding];
    if(emailStr)
        return YES;
    
    return NO;
}

-(BOOL) getUserEmail:(NSString**)email andPassword:(NSString**)password
{
    if(!email || !password)
        return NO;
    
    NSData* emailData = [KeychainWrapper searchKeychainCopyMatchingIdentifier:@"email"];
    if(!emailData)
        return NO;
    
    NSString* emailStr = [[NSString alloc] initWithData:emailData
                                               encoding:NSUTF8StringEncoding];
    NSString* pswdStr = nil;
    if(emailStr)
    {
        NSData* pswdData = [KeychainWrapper searchKeychainCopyMatchingIdentifier:@"pswd"];

        if(!pswdData)
            return NO;
        
        pswdStr = [[NSString alloc] initWithData:pswdData
                                        encoding:NSUTF8StringEncoding];
    }
    
    if(emailStr && pswdStr)
    {
        *email = [emailStr copy];
        *password = [pswdStr copy];
        
        return YES;
    }
    
    return NO;

}

-(void) addNewHomeInfo:(homeInfo*)newHomeInfo
{
    if(!newHomeInfo)
        return;
    
    uint currentHomeCount = [self.mKunanceUserHomes getCurrentHomesCount];
    
    if([self.mKunanceUserHomes getCurrentHomesCount] == MAX_NUMBER_OF_HOMES_PER_USER)
    {
        NSLog(@"Error: Number of user homes maxed out at %d", currentHomeCount);
        return;
    }
    
    if(!self.mKunanceUserHomes)
    {
        self.mKunanceUserHomes = [[UsersHomesList alloc] init];
    }
    
    [self.mKunanceUserHomes addNewHome:newHomeInfo];
    
    if([self.mKunanceUserHomes getCurrentHomesCount] == 1)
    {
        self.mUserProfileStatus = ProfileStatusUser1HomeInfoEntered;
        NSLog(@"User profile status = ProfileStatusUser1HomeInfoEntered");
    }
    else if( ([self.mKunanceUserHomes getCurrentHomesCount] == 2) &&
            (self.mUserProfileStatus == ProfileStatusUser1HomeAndLoanInfoEntered))
    {
        self.mUserProfileStatus = ProfileStatusUserTwoHomesAndLoanInfoEntered;
        NSLog(@"User profile status = ProfileStatusUserTwoHomesAndLoanInfoEntered");
    }
    else if( ([self.mKunanceUserHomes getCurrentHomesCount] == 2) &&
            (self.mUserProfileStatus == ProfileStatusUser1HomeInfoEntered))
    {
        self.mUserProfileStatus = ProfileStatusUser2HomesButNoLoanEntered;
        NSLog(@"Intermidiate User profile status = ProfileStatusUser2HomesButNoLoanEntered");
    }

}

-(void) updateExistingHome:(homeInfo*)homeInfo
{
    if(!homeInfo)
        return;
    
    if(homeInfo.mHomeId >= [self.mKunanceUserHomes getCurrentHomesCount])
        return;
    
    [self.mKunanceUserHomes updateHomeInfo:homeInfo];
}

-(void) updateLoanInfo:(loan*) aLoan
{
    if(!aLoan)
        return;
    if(self.mKunanceUserLoan)
    {
        NSLog(@"Overwriting current loan info");
    }
    
    self.mKunanceUserLoan = aLoan;
    if([self.mKunanceUserHomes getCurrentHomesCount] == 1)
    {
        self.mUserProfileStatus = ProfileStatusUser1HomeAndLoanInfoEntered;
                NSLog(@"User profile status = ProfileStatusUser1HomeAndLoanInfoEntered");
    }
    else if ((self.mUserProfileStatus == ProfileStatusUserTwoHomesAndLoanInfoEntered) &&
             ([self.mKunanceUserHomes getCurrentHomesCount] == 2))
    {
        self.mUserProfileStatus = ProfileStatusUserTwoHomesAndLoanInfoEntered;
                NSLog(@"User profile status = ProfileStatusUserTwoHomesAndLoanInfoEntered");
    }
    else if ((self.mUserProfileStatus == ProfileStatusUser2HomesButNoLoanEntered) &&
             ([self.mKunanceUserHomes getCurrentHomesCount] == 2))
    {
        self.mUserProfileStatus = ProfileStatusUserTwoHomesAndLoanInfoEntered;
        NSLog(@"User profile status = ProfileStatusUserTwoHomesAndLoanInfoEntered");
    }
}

+ (kunanceUser*) getInstance
{
    return kunanceUserSingleton;
}
@end
