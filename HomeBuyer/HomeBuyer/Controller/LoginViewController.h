//
//  LoginViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/5/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"

@protocol LoginDelegate <NSObject>
-(void) loggedInUserSuccessfully;
-(void) signupButtonPressed;
-(void) cancelLoginScreen;
@end

@interface LoginViewController : FormViewController<UITextFieldDelegate>
@property (nonatomic, weak) id <LoginDelegate> mLoginDelegate;

@property (nonatomic, strong) IBOutlet UITextField* mLoginEmail;
@property (nonatomic, strong) IBOutlet UITextField* mPassword;
@property (nonatomic, strong) IBOutlet UIButton*    mLoginButton;
@property (nonatomic, strong) IBOutlet UIButton*    mSignInFooterBUtton;
@property (nonatomic, strong) IBOutlet UIButton*    mSignUpFooterButton;

-(IBAction) loginButtonPressed:(id)sender;
-(IBAction) signupButtonPressedAction:(id)sender;

@property (nonatomic, strong) UIColor* mLoginButtonColor;
@end
