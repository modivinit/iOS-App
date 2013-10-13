//
//  kunanceUser.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/30/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userPFInfo.h"
#import "UsersHomesList.h"
#import "loan.h"
#import "homeInfo.h"
#import "UsersHomesList.h"

@interface kunanceUser : NSObject
@property (nonatomic, strong) FFUser* mLoggedInKunanceUser;
@property (nonatomic, strong) userPFInfo* mkunanceUserPFInfo;
@property (nonatomic, strong) UsersHomesList* mKunanceUserHomes;
@property (nonatomic, strong) loan* mKunanceUserLoan;
@property (nonatomic) kunanceUserProfileStatus mUserProfileStatus;
@property (nonatomic, copy) NSString*        mKunanceUserGUID;
@property (nonatomic, copy) NSString*        mUserPFInfoGUID;

+ (kunanceUser*) getInstance;
-(BOOL) isUserLoggedIn;
-(void) saveUserInfoAfterLoginSignUp:(FFUser*)newUser passowrd:(NSString*)pswd;
-(BOOL) getUserEmail:(NSString**)email andPassword:(NSString**)password;
-(BOOL) userAccountFoundOnDevice;

-(void) updateUserPFInfo:(userPFInfo*) newUserPFInfo;
-(void) addNewHomeInfo:(homeInfo*)newHomeInfo;
-(void) updateExistingHome:(homeInfo*)homeInfo;

-(void) updateLoanInfo:(loan*) aLoan;

-(void) logoutUser;

@end
