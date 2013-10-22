//
//  SignUpViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "SignUpViewController.h"
#import "kunanceUser.h"
#import "AppDelegate.h"

@interface SignUpViewController ()
@property (nonatomic, strong) IBOutlet UIButton* mCreateAccountButton;
@property (nonatomic, strong) IBOutlet UIButton* mSignInButton;
@property (nonatomic, strong) UIButton* mRegisterButton;

@property (nonatomic, strong) IBOutlet UITextField* mNameField;
@property (nonatomic, strong) IBOutlet UITextField* mEmailField;
@property (nonatomic, strong) IBOutlet UITextField* mPasswordField;
@property (nonatomic, strong) IBOutlet UITextField* mRealtorCodeField;
@property (nonatomic, strong) UIColor* mRegisterButtonEnabledColor;

@property (nonatomic, strong) UIToolbar *mKeyBoardToolbar;

@property (nonatomic, strong) UITextField* mActiveField;

@property (nonatomic, strong) UIActivityIndicatorView* mActIndicator;
-(IBAction) showSignInView :(id)sender;
@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    self.mFormFields = [[NSArray alloc] initWithObjects:self.mNameField, self.mEmailField, self.mPasswordField, self.mRealtorCodeField, nil];
    
    [super viewDidLoad];
    
    NSString* titleText = [NSString stringWithFormat:@"Create Account"];
    self.navigationController.navigationBar.topItem.title = titleText;

    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemDone target:self action:@selector(cancelScreen)];

    self.mSignInButton.titleLabel.font = [UIFont fontWithName:@"cocon" size:14];
    self.mCreateAccountButton.titleLabel.font = [UIFont fontWithName:@"cocon" size:14];
    
     self.mRegisterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.mRegisterButton setTitle:@"Join" forState:UIControlStateNormal];
    [self.mRegisterButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchDown];
    self.mRegisterButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    self.mRegisterButton.titleLabel.textColor = [UIColor whiteColor];
    self.mRegisterButton.backgroundColor = [Utilities getKunanceBlueColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.mRegisterButton];
    
    self.mCreateAccountButton.enabled = NO;
    self.mRegisterButtonEnabledColor = self.mRegisterButton.backgroundColor;
    
    [self.mNameField becomeFirstResponder];
    [self disableRegisterButton];
}

-(void) cancelScreen
{
    if(self.mSignUpDelegate && [self.mSignUpDelegate respondsToSelector:@selector(cancelSignUpScreen)])
    {
        [self.mSignUpDelegate cancelSignUpScreen];
    }
}

-(void) disableRegisterButton
{
    self.mRegisterButton.enabled = NO;
    self.mRegisterButton.backgroundColor = [UIColor grayColor];
}

-(void) enableRegisterButton
{
    self.mRegisterButton.enabled = YES;
    self.mRegisterButton.backgroundColor = self.mRegisterButtonEnabledColor;
}

-(void) viewWillDisappear:(BOOL)animated
{
    //[self deregisterForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) showSignInView :(id)sender
{
    if(self.mSignUpDelegate && [self.mSignUpDelegate respondsToSelector:@selector(loadSignInClicked)])
    {
        [self.mSignUpDelegate loadSignInClicked];
    }
}

-(void) registerUser:(id)sender
{
    if([Utilities isUITextFieldEmpty:self.mNameField] ||
       [Utilities isUITextFieldEmpty:self.mEmailField] ||
       [Utilities isUITextFieldEmpty:self.mPasswordField])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter all necessary fields"];
        return;
    }
    
    if(![Utilities isValidEmail:self.mEmailField.text])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter a valid email"];
        return;
    }
    
    self.mSignInButton.enabled = NO;
    self.view.userInteractionEnabled = NO;
    
    self.mActIndicator = [Utilities getAndStartBusyIndicator];
    [self.view addSubview:self.mActIndicator];
    
    LoginSignupService* signupService = [[LoginSignupService alloc] init];
    signupService.mLoginSignupServiceDelegate = self;
    
    if(![signupService signupWithName:self.mNameField.text
                             password:self.mPasswordField.text
                                email:self.mEmailField.text
                          realtorCode:self.mRealtorCodeField.text])
    {
        self.mSignInButton.enabled = YES;
        self.view.userInteractionEnabled = YES;
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sign Up failed"];
        
        [self.mActIndicator stopAnimating];
        [self.mActIndicator removeFromSuperview];
    }
}


#pragma LoginSignupServiceDelegate
-(void) signupCompletedWithError:(NSError *)error
{
    if(self.mActIndicator)
    {
        [self.mActIndicator stopAnimating];
        [self.mActIndicator removeFromSuperview];
    }

    if(error)
    {
        self.mSignInButton.enabled = YES;
        self.view.userInteractionEnabled = YES;
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sign Up failed"];
    }
    else
    {
        if(self.mSignUpDelegate &&
           [self.mSignUpDelegate respondsToSelector:@selector(userSignedUpSuccessfully)])
        {
            [self.mSignUpDelegate userSignedUpSuccessfully];
        }
    }
}
#pragma end

///////Keyboard Animation Related

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int futurePasswordLength = 0;
    int futureEmailLength = 0;
    int futureNameLength = 0;
    
    if(textField == self.mPasswordField)
    {
        if([string isEqualToString:@""])
        {
            futurePasswordLength = self.mPasswordField.text.length -1;
        }
        else
        {
            futurePasswordLength = self.mPasswordField.text.length +1;
        }
        
        futureEmailLength = self.mEmailField.text.length;
        futureNameLength = self.mNameField.text.length;
    }
    else if(textField == self.mNameField)
    {
        if([string isEqualToString:@""])
        {
            futureNameLength = self.mNameField.text.length -1;
        }
        else
        {
            futureNameLength = self.mNameField.text.length +1;
        }
        
        futureEmailLength = self.mEmailField.text.length;
        futurePasswordLength = self.mPasswordField.text.length;
    }
    else if(textField == self.mEmailField)
    {
        if([string isEqualToString:@""])
        {
            futureEmailLength = self.mEmailField.text.length -1;
        }
        else
        {
            futureEmailLength = self.mEmailField.text.length +1;
        }
        
        futurePasswordLength = self.mPasswordField.text.length;
        futureNameLength = self.mNameField.text.length;
    }
    else
    {
        futureEmailLength = self.mEmailField.text.length;
        futureNameLength = self.mNameField.text.length;
        futurePasswordLength = self.mPasswordField.text.length;
    }
    
    if(futurePasswordLength >= 6 && futureNameLength > 0 && futureEmailLength > 0)
    {
        [self enableRegisterButton];
    }
    else
    {
        [self disableRegisterButton];
    }
    
    return YES;
}
@end
