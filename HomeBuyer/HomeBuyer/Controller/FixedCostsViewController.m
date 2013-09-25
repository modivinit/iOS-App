//
//  ExpensesViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/16/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "FixedCostsViewController.h"

@interface FixedCostsViewController ()

@end

@implementation FixedCostsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setupNavControl
{
    uint tags = 0;
    
    self.mKeyBoardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.mKeyBoardToolbar.barStyle = UIBarStyleDefault;
    self.mKeyBoardToolbar.items = [NSArray arrayWithObjects:
                                   [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                   [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                                   nil];
    
    [self.mKeyBoardToolbar sizeToFit];
    
    self.mMonthlyRent.tag = tags++;
    self.mMonthlyRent.delegate = self;
    self.mMonthlyRent.inputAccessoryView = self.mKeyBoardToolbar;
    
    self.mMonthlyCarPayments.tag = tags++;
    self.mMonthlyCarPayments.delegate = self;
    self.mMonthlyCarPayments.inputAccessoryView = self.mKeyBoardToolbar;
    
    self.mOtherMonthlyPayments.tag = tags++;
    self.mOtherMonthlyPayments.delegate = self;
    self.mOtherMonthlyPayments.inputAccessoryView = self.mKeyBoardToolbar;
}

-(void)doneWithNumberPad
{
    [self.mActiveField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavControl];
    
    [self.mFormScrollView setContentSize:CGSizeMake(320, 320)];

    UITapGestureRecognizer* currentLifestyleTappedGesture = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self
                                                         action:@selector(currentLifeStyleIncomeTapped)];
    [self.mCurrentLifestyleIncomeViewAsButton addGestureRecognizer:currentLifestyleTappedGesture];

}

-(void) viewDidAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
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

-(void) currentLifeStyleIncomeTapped
{
    if(!self.mMonthlyRent.text || !self.mMonthlyCarPayments.text || !self.mOtherMonthlyPayments.text)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                   message:@"Please enter all fields"
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [alert show];
        return;
    }
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.mMonthlyRent)
    {
        [self.mMonthlyCarPayments becomeFirstResponder];
    }
    else if (textField == self.mMonthlyCarPayments)
    {
        [self.mOtherMonthlyPayments becomeFirstResponder];
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
}

#pragma mark - Keyboard

-(void) deregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

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
    self.mFormScrollView.contentInset = contentInsets;
    self.mFormScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.mActiveField.frame.origin) ) {
        [self.mFormScrollView scrollRectToVisible:self.mActiveField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mFormScrollView.contentInset = contentInsets;
    self.mFormScrollView.scrollIndicatorInsets = contentInsets;
}

@end
