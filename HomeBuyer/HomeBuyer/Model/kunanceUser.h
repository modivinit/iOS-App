//
//  kunanceUser.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/30/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kunanceUser : NSObject
@property (nonatomic, strong) FFUser* mLoggedInKunanceUser;

+ (kunanceUser*) getInstance;
-(BOOL) isUserLoggedIn;
-(void) saveUserInfoAfterLoginSignUp:(FFUser*) newUser passowrd:(NSString*) pswd;
-(BOOL) getUserEmail:(NSString**)email andPassword:(NSString**)password;
-(BOOL) userAccountFoundOnDevice;
@end
