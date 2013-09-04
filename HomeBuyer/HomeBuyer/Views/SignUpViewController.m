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

@property (nonatomic, strong) IBOutlet UITextField* mFirstNameField;
@property (nonatomic, strong) IBOutlet UITextField* mLastNameField;
@property (nonatomic, strong) IBOutlet UITextField* mEmailField;
@property (nonatomic, strong) IBOutlet UITextField* mPasswordField;
@property (nonatomic, strong) IBOutlet UITextField* mRealtorCodeField;
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) UITextField* activeField;
-(IBAction) registerUser:(id)sender;
@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    
    self.mFirstNameField.delegate = self;
    self.mLastNameField.delegate = self;
    self.mEmailField.delegate = self;
    self.mPasswordField.delegate = self;
    self.mRealtorCodeField.delegate = self;
    
    self.mPasswordField.secureTextEntry = YES;
    self.mCreateAccountButton.enabled = NO;
    // Do any additional setup after loading the view from its nib.
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
    if([Utilities isUITextFieldEmpty:self.mFirstNameField] ||
       [Utilities isUITextFieldEmpty:self.mLastNameField] ||
       [Utilities isUITextFieldEmpty:self.mEmailField] ||
       [Utilities isUITextFieldEmpty:self.mPasswordField])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter all necessary fields"];
        return;
    }
    
    FatFractal *ff = [FatFractal main];
    FFUser *newUser = [[FFUser alloc] initWithFF:ff];
    newUser.firstName = self.mFirstNameField.text;
    newUser.lastName = self.mLastNameField.text;
    newUser.userName = self.mEmailField.text;
    __block NSString* email = newUser.email = self.mEmailField.text;
    __block NSString *password = self.mPasswordField.text;
    
    [ff registerUser:newUser
            password:password
          onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse)
    {
        FFUser *loggedInUser = (FFUser *)obj;
        if(loggedInUser)
        {
            [[kunanceUser getInstance] saveUserInfoAfterSignUp:password email:email];
            [Utilities showAlertWithTitle:@"Success" andMessage:@"Sign Up Successful"];
        }
        else
        {
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Sign Up failed"];
        }
        // if no error, your application is now in a logged-in state
    }];
}


///////Keyboard Animation Related

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
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
    CGPoint origin = self.activeField.frame.origin;
    origin.y -= self.scrollView.contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-(aRect.size.height));
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
