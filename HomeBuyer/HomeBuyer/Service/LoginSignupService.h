//
//  LoginSignupService.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/22/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginSignupService.h"

@protocol LoginSignupServiceDelegate <NSObject>
@optional
-(void) signupCompletedWithError:(NSError*) error;
-(void) loginCompletedWithError:(NSError*) error;
@end

@interface LoginSignupService : NSObject

-(BOOL) signupWithName:(NSString*) name
              password:(NSString*) password
                 email:(NSString*) email
           realtorCode:(NSString*) code;

-(BOOL) loginWithEmail:(NSString*) email
              password:(NSString*) password;

@property (nonatomic, weak) id <LoginSignupServiceDelegate> mLoginSignupServiceDelegate;
@end
