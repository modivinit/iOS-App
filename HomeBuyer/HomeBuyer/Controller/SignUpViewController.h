//
//  SignUpViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormNoScrollViewViewController.h"

@protocol SignUpDelegate <NSObject>
-(void) userSignedUpSuccessfully;
-(void) loadSignInClicked;
-(void) cancelSignUpScreen;
@end

@interface SignUpViewController : FormNoScrollViewViewController <UITextFieldDelegate, kunanceUserDelegate>
@property (nonatomic, weak) id <SignUpDelegate> mSignUpDelegate;
@end
