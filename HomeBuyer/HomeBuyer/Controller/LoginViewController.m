//
//  LoginViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/5/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

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
    NSString* titleText = [NSString stringWithFormat:@"Sign In"];
    self.navigationController.navigationBar.topItem.title = titleText;

    self.mFormFields = [[NSArray alloc] initWithObjects:self.mLoginEmail, self.mPassword, nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mLoginEmail.delegate = self;
    self.mPassword.delegate = self;
    
    self.mSignInFooterBUtton.enabled = NO;
    self.mLoginButton.enabled = NO;
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemDone target:self action:@selector(cancelScreen)];

    [self.mLoginEmail becomeFirstResponder];
    self.mLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self.mLoginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.mLoginButton addTarget:self action:@selector(loginUser) forControlEvents:UIControlEventTouchDown];
    self.mLoginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    self.mLoginButton.titleLabel.textColor = [UIColor whiteColor];
    self.mLoginButton.backgroundColor = [Utilities getKunanceBlueColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.mLoginButton];

    self.mLoginButtonColor = self.mLoginButton.backgroundColor;
    self.mSignInFooterBUtton.titleLabel.font = [UIFont fontWithName:@"cocon" size:14];
    self.mSignUpFooterButton.titleLabel.font = [UIFont fontWithName:@"cocon" size:14];
    

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
    NSString* email = self.mLoginEmail.text;
    NSString* password = self.mPassword.text;
    
    if(!email || !password)
        return;
    
    if(![Utilities isValidEmail:email])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter a valid email"];
        return;
    }
    
    self.view.userInteractionEnabled = NO;
    [self disableLoginButton];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Logging in";
    
    [kunanceUser getInstance].mKunanceUserDelegate = self;
    if(![[kunanceUser getInstance] loginWithEmail:email password:password])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Login Failed. Please try again."];
        self.mPassword.text = @"";
        self.view.userInteractionEnabled = YES;
        [self enableLoginButton];
    }
}

#pragma mark LoginSignupServiceDelegate
-(void) loginCompletedWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if(error)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Login Failed. Please try again."];
        self.mPassword.text = @"";
        self.view.userInteractionEnabled = YES;
        [self enableLoginButton];
    }
    else
    {
        if(self.mLoginDelegate && [self.mLoginDelegate respondsToSelector:@selector(loggedInUserSuccessfully)])
        {
            [self.mLoginDelegate loggedInUserSuccessfully];
        }

    }
}
#pragma end

#pragma mark action functions
//IBActions, action target methods, gesture targets
-(IBAction)forgotPassword:(id)sender
{
    
}

-(void) cancelScreen
{
    if(self.mLoginDelegate && [self.mLoginDelegate respondsToSelector:@selector(cancelLoginScreen)])
    {
        [self.mLoginDelegate cancelLoginScreen];
    }
}

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
#pragma end

#pragma mark - UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int futurePasswordLength = 0;
    int futureEmailLength = 0;
    
    if(textField == self.mPassword)
    {
        if([string isEqualToString:@""])
        {
            futurePasswordLength = self.mPassword.text.length -1;
        }
        else
        {
            futurePasswordLength = self.mPassword.text.length +1;
        }
        
        futureEmailLength = self.mLoginEmail.text.length;
    }
    else if(textField == self.mLoginEmail)
    {
        if([string isEqualToString:@""])
        {
            futureEmailLength = self.mLoginEmail.text.length -1;
        }
        else
        {
            futureEmailLength = self.mLoginEmail.text.length +1;
        }
        
        futurePasswordLength = self.mPassword.text.length;
    }

    if(futurePasswordLength >= 6 && futureEmailLength > 0)
    {
        [self enableLoginButton];
    }
    else
    {
        [self disableLoginButton];
    }
    
    return YES;
}

#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
