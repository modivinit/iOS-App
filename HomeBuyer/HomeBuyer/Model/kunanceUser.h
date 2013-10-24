//
//  kunanceUser.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/30/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userProfileInfo.h"
#import "UsersHomesList.h"
#import "usersLoansList.h"
#import "homeInfo.h"
#import "UsersHomesList.h"
#import <Parse/Parse.h>

@interface kunanceUser : NSObject
@property (nonatomic, strong) userProfileInfo* mkunanceUserProfileInfo;
@property (nonatomic, strong) UsersHomesList* mKunanceUserHomes;
@property (nonatomic, strong) usersLoansList* mKunanceUserLoans;
@property (nonatomic) kunanceUserProfileStatus mUserProfileStatus;
@property (nonatomic, strong, readonly) PFUser* mLoggedInKunanceUser;

+ (kunanceUser*) getInstance;
-(BOOL) isUserLoggedIn;
-(BOOL) userAccountFoundOnDevice;
-(BOOL) loginSavedUser;

-(void) updateStatusWithUserProfileInfo;
-(void) updateStatusWithHomeInfoStatus;

-(void) updateStatusWithLoanInfoStatus;

-(void) logoutUser;
-(NSString*) getUserID;
-(NSString*) getFirstName;
@end
