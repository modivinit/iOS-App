//
//  LoginSignupService.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/22/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LoginSignupService.h"
#import <Parse/Parse.h>

@implementation LoginSignupService
-(BOOL) signupWithName:(NSString*) name
              password:(NSString*) password
                 email:(NSString*) email
           realtorCode:(NSString*) code
{
    if(!password || !email)
    {
        return NO;
    }
    
    PFUser* user = [PFUser user];
    user.username = email;
    user.password = password;
    user.email = email;
    
    NSArray* names = [name componentsSeparatedByString:@" "];
    if(names && names.count > 0)
    {
        user[@"FirstName"] = names[0];
        if(names.count > 1)
            user[@"LastName"] = names[1];
    }
    
    if(code)
        user[@"RealtorCode"] = code;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(self.mLoginSignupServiceDelegate &&
           [self.mLoginSignupServiceDelegate respondsToSelector:@selector(signupCompletedWithError:)])
        {
            [self.mLoginSignupServiceDelegate signupCompletedWithError:error];
        }
    }];
     
    return YES;
}

@end
