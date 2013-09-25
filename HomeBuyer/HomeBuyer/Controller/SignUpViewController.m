//
//  SignUpViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "SignUpViewController.h"
#import "kunanceUser.h"

@interface SignUpViewController ()
@property (nonatomic, strong) IBOutlet UIButton* mCreateAccountButton;
@property (nonatomic, strong) IBOutlet UIButton* mSignInButton;
@property (nonatomic, strong) IBOutlet UIButton* mRegisterButton;

@property (nonatomic, strong) IBOutlet UITextField* mNameField;
@property (nonatomic, strong) IBOutlet UITextField* mEmailField;
@property (nonatomic, strong) IBOutlet UITextField* mPasswordField;
@property (nonatomic, strong) IBOutlet UITextField* mRealtorCodeField;
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, strong) UIColor* mRegisterButtonEnabledColor;

@property (nonatomic, strong) UIToolbar *mKeyBoardToolbar;

@property (nonatomic, strong) UITextField* mActiveField;
-(IBAction) registerUser:(id)sender;
-(IBAction) showSignInView :(id)sender;
@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    
    self.mKeyBoardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.mKeyBoardToolbar.barStyle = UIBarStyleDefault;
    self.mKeyBoardToolbar.items = [NSArray arrayWithObjects:
                                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                               [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                                                nil];
    [self.mKeyBoardToolbar sizeToFit];
    
    self.mNameField.delegate = self;
    self.mNameField.inputAccessoryView = self.mKeyBoardToolbar;
    
    self.mEmailField.delegate = self;
    self.mEmailField.inputAccessoryView = self.mKeyBoardToolbar;
    
    self.mPasswordField.delegate = self;
    self.mPasswordField.inputAccessoryView = self.mKeyBoardToolbar;
    self.mPasswordField.secureTextEntry = YES;

    self.mRealtorCodeField.delegate = self;
    self.mRealtorCodeField.inputAccessoryView = self.mKeyBoardToolbar;
    
    self.mCreateAccountButton.enabled = NO;
    self.mRegisterButtonEnabledColor = self.mRegisterButton.backgroundColor;
    
    [self disableRegisterButton];
    // Do any additional setup after loading the view from its nib.
}

-(void)doneWithNumberPad{
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
    [self deregisterForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    FatFractal *ff = [FatFractal main];
    FFUser *newUser = [[FFUser alloc] initWithFF:ff];
    newUser.firstName = self.mNameField.text;
    newUser.userName = self.mEmailField.text;
    newUser.email = self.mEmailField.text;
    __block NSString *password = self.mPasswordField.text;
    
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
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Sign Up failed"];
        }
        // if no error, your application is now in a logged-in state
    }];
}


///////Keyboard Animation Related

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.mNameField)
    {
        [self.mEmailField becomeFirstResponder];
    }
    else if (textField == self.mEmailField)
    {
        [self.mPasswordField becomeFirstResponder];
    }
    else if(textField == self.mPasswordField)
    {
        [self.mRealtorCodeField becomeFirstResponder];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.mActiveField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.mActiveField = nil;
    
    if(![Utilities isUITextFieldEmpty:self.mNameField] &&
    ![Utilities isUITextFieldEmpty:self.mEmailField] &&
    ![Utilities isUITextFieldEmpty:self.mPasswordField])
    {
        [self enableRegisterButton];
    }
}

-(void) deregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];  }

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = self.mActiveField.frame.origin;
    origin.y -= self.scrollView.contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.mActiveField.frame.origin.y-(aRect.size.height));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
@end
