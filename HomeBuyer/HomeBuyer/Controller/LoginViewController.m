//
//  LoginViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/5/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mLoginEmail.delegate = self;
    self.mPassword.delegate = self;
    
    self.mSignInFooterBUtton.enabled = NO;
    self.mLoginButton.enabled = NO;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.mLoginButtonColor = self.mLoginButton.backgroundColor;
    [self disableLoginButton];
    // Do any additional setup after loading the view from its nib.
}

-(void) disableLoginButton
{
    self.mLoginButton.enabled = NO;
    self.mLoginButton.backgroundColor = [UIColor grayColor];
}

-(void) enableLoginButton
{
    self.mLoginButton.enabled = YES;
    self.mLoginButton.backgroundColor = self.mLoginButtonColor;
}

-(void) loginUser
{
    __block NSString* email = self.mLoginEmail.text;
    __block NSString* password = self.mPassword.text;
    
    if(!email || !password)
        return;
    
    FatFractal *ff = [FatFractal main];
    [ff loginWithUserName:email andPassword:password
               onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse)
     {
         FFUser *loggedInUser = (FFUser *)obj;
         if(loggedInUser)
         {
             [[kunanceUser getInstance] saveUserInfoAfterLoginSignUp:loggedInUser
                                                            passowrd:password];
             
             if(self.mLoginDelegate && [self.mLoginDelegate respondsToSelector:@selector(loggedInUserSuccessfully)])
             {
                 [self.mLoginDelegate loggedInUserSuccessfully];
             }
         }
         else
         {
             [Utilities showAlertWithTitle:@"Error" andMessage:@"Login Failed"];
         }
         
     }];
}

#pragma mark action functions
//IBActions, action target methods, gesture targets
-(IBAction) loginButtonPressed:(id)sender
{
    [self loginUser];
}

-(IBAction) signupButtonPressedAction:(id)sender
{
    if(self.mLoginDelegate && [self.mLoginDelegate respondsToSelector:@selector(signupButtonPressed)])
    {
        [self.mLoginDelegate signupButtonPressed];
    }
}

-(void)dismissKeyboard
{
    [self.mActiveField resignFirstResponder];
    
    if(self.mLoginEmail.text && self.mPassword.text)
        [self enableLoginButton];
}
#pragma end

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.mLoginEmail)
    {
        [self.mPassword becomeFirstResponder];
    }
    
    [textField resignFirstResponder];
    
    if(self.mLoginEmail.text && self.mPassword.text)
        [self enableLoginButton];
        
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.mActiveField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.mActiveField = nil;
}
#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
