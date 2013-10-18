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
@property (nonatomic, strong) IBOutlet UIButton* mRegisterButton;

@property (nonatomic, strong) IBOutlet UITextField* mNameField;
@property (nonatomic, strong) IBOutlet UITextField* mEmailField;
@property (nonatomic, strong) IBOutlet UITextField* mPasswordField;
@property (nonatomic, strong) IBOutlet UITextField* mRealtorCodeField;
@property (nonatomic, strong) UIColor* mRegisterButtonEnabledColor;

@property (nonatomic, strong) UIToolbar *mKeyBoardToolbar;

@property (nonatomic, strong) UITextField* mActiveField;
-(IBAction) registerUser:(id)sender;
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
    
    UIButton* joinButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [joinButton setTitle:@"Join" forState:UIControlStateNormal];
    [joinButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchDown];
    joinButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    joinButton.titleLabel.textColor = [UIColor whiteColor];
    joinButton.backgroundColor = [Utilities getKunanceBlueColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:joinButton];
    
    self.mCreateAccountButton.enabled = NO;
    self.mRegisterButtonEnabledColor = self.mRegisterButton.backgroundColor;
    
    [self disableRegisterButton];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.hidesBackButton = YES;
    
    // Do any additional setup after loading the view from its nib.
}

-(void) cancelScreen
{
    if(self.mSignUpDelegate && [self.mSignUpDelegate respondsToSelector:@selector(cancelSignUpScreen)])
    {
        [self.mSignUpDelegate cancelSignUpScreen];
    }
}

-(void)dismissKeyboard{
    [self.mActiveField resignFirstResponder];
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
    
    FatFractal *ff = [AppDelegate ff];
    FFUser *newUser = [[FFUser alloc] initWithFF:ff];
    newUser.firstName = self.mNameField.text;
    newUser.userName = self.mEmailField.text;
    newUser.email = self.mEmailField.text;
    __block NSString *password = self.mPasswordField.text;
    
    self.mSignInButton.enabled = NO;
    self.view.userInteractionEnabled = NO;
    [ff registerUser:newUser
            password:password
          onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse)
    {
        FFUser *loggedInUser = (FFUser *)obj;
        if(loggedInUser)
        {
            [[kunanceUser getInstance] saveUserInfoAfterLoginSignUp:loggedInUser
                                                           passowrd:password];
            
            if(self.mSignUpDelegate &&
               [self.mSignUpDelegate respondsToSelector:@selector(userSignedUpSuccessfully)])
            {
                [self.mSignUpDelegate userSignedUpSuccessfully];
            }
        }
        else
        {
            self.mSignInButton.enabled = YES;
            self.view.userInteractionEnabled = YES;
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Sign Up failed"];
        }
        
        // if no error, your application is now in a logged-in state
    }];
}


///////Keyboard Animation Related

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.mPasswordField)
    {
        if(self.mPasswordField.text.length == 5 && self.mNameField.text.length > 0 &&
           self.mEmailField.text.length > 0)
        {
            [self enableRegisterButton];
        }
        else
        {
            [self disableRegisterButton];
        }
    }
    
    return YES;
}
@end
