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
    }
    return self;
}

-(BOOL) isLoggedInUser
{
    return ([[FatFractal main] loggedIn] && [kunanceUser getInstance].mLoggedInKunanceUser);
}

-(void) saveUserInfoAfterSignUp:(NSString*) passwrod email:(NSString*) email
{
    [KeychainWrapper createKeychainValue:passwrod forIdentifier:@"pswd"];
    [KeychainWrapper createKeychainValue:email forIdentifier:@"email"];
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

-(void) saveUserInfoAfterLogin:(FFUser*) newUser
{
    
}

+ (kunanceUser*) getInstance
{
    return kunanceUserSingleton;
}
@end
