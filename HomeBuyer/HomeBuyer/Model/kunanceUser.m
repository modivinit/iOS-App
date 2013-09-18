//
//  kunanceUser.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/30/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kunanceUser.h"
#import "KeychainWrapper.h"

static kunanceUser *kunanceUserSingleton;

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
        self.mkunanceUserFixedExpenses = nil;
        self.mKunanceUserHomes = nil;
        self.mKunanceUserLoans = nil;
        self.mUserProfileStatus = ProfileStatusNoInfoEntered;
    }
    
    return self;
}

-(BOOL) isUserLoggedIn
{
    return ([[FatFractal main] loggedIn] && [kunanceUser getInstance].mLoggedInKunanceUser);
}

-(void) saveUserInfoAfterLoginSignUp:(FFUser*)newUser passowrd:(NSString*)pswd
{
    if(!newUser || !pswd)
        return;
    
    [KeychainWrapper createKeychainValue:pswd forIdentifier:@"pswd"];
    [KeychainWrapper createKeychainValue:newUser.email forIdentifier:@"email"];
    
    self.mLoggedInKunanceUser = newUser;
    
    FatFractal *ff = [FatFractal main];
    if(ff)
        self.mKunanceUserGUID = [[ff metaDataForObj:newUser] guid];
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

+ (kunanceUser*) getInstance
{
    return kunanceUserSingleton;
}
@end
