//
//  LoginViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/5/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

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

//    self.mFormFields = [[NSArray alloc] initWithObjects:self.mLoginEmail, self.mPassword, nil];
    
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
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemDone target:self action:@selector(cancelScreen)];

    self.mLoginButtonColor = self.mLoginButton.backgroundColor;
    self.mSignInFooterBUtton.titleLabel.font = [UIFont fontWithName:@"cocon" size:14];
    self.mSignUpFooterButton.titleLabel.font = [UIFont fontWithName:@"cocon" size:14];
    

    [self disableLoginButton];
    
//    self.navigationController.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.hidesBackButton = YES;

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
    
    [self dismissKeyboard];
    
    self.view.userInteractionEnabled = NO;
    [self disableLoginButton];
    
    FatFractal *ff = [AppDelegate ff];
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
             [Utilities showAlertWithTitle:@"Error" andMessage:@"Login Failed. Please try again."];
             self.view.userInteractionEnabled = YES;
             [self enableLoginButton];
         }
         
     }];
}

#pragma mark action functions
//IBActions, action target methods, gesture targets
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

-(void)dismissKeyboard
{
    //[self.mActiveField resignFirstResponder];
}
#pragma end

#pragma mark - UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //if(textField == self.mPassword)
    {
        NSLog(@"Password lenght: %d, email length: %d", self.mPassword.text.length, self.mLoginEmail.text.length);
        if(self.mPassword.text.length >= 5 && self.mLoginEmail.text.length > 0)
        {
            [self enableLoginButton];
        }
        else
        {
            [self disableLoginButton];
        }
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
