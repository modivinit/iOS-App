//
//  kunanceUser.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/30/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userPFInfo.h"
#import "userFixedExpensesInfo.h"
#import "UsersHomesList.h"
#import "usersLoansList.h"

@interface kunanceUser : NSObject
@property (nonatomic, strong) FFUser* mLoggedInKunanceUser;
@property (nonatomic, strong) userPFInfo* mkunanceUserPFInfo;
@property (nonatomic, strong) userFixedExpensesInfo* mkunanceUserFixedExpenses;
@property (nonatomic, strong) UsersHomesList* mKunanceUserHomes;
@property (nonatomic, strong) usersLoansList* mKunanceUserLoans;
@property (nonatomic) kunanceUserProfileStatus mUserProfileStatus;

+ (kunanceUser*) getInstance;
-(BOOL) isUserLoggedIn;
-(void) saveUserInfoAfterLoginSignUp:(FFUser*) newUser passowrd:(NSString*) pswd;
-(BOOL) getUserEmail:(NSString**)email andPassword:(NSString**)password;
-(BOOL) userAccountFoundOnDevice;
@end
