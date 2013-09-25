//
//  AboutYouViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/15/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "AboutYouViewController.h"
#import "userPFInfo.h"
#import "APIService.h"

@interface AboutYouViewController ()

@end

@implementation AboutYouViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.mSelectedMaritalStatus = StatusNotDefined;
    }
    return self;
}

-(void)dismissKeyboard
{
    [self.mActiveField resignFirstResponder];
}

-(void) selectMarried
{
    self.mMarriedImageAsButton.image = [UIImage imageNamed:@"couple-selected.png"];
    self.mSingleImageAsButton.image = [UIImage imageNamed:@"single.png"];
    
    self.mSelectedMaritalStatus = StatusMarried;
}

-(void) selectSingle
{
    self.mSingleImageAsButton.image = [UIImage imageNamed:@"single-selected.png"];
    self.mMarriedImageAsButton.image = [UIImage imageNamed:@"couple.png"];

    self.mSelectedMaritalStatus = StatusSingle;
}

-(void) setupGestureRecognizers
{
    UITapGestureRecognizer* marriedButtonTappedGesture = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(marriedButtonTapped)];
    [self.mMarriedImageAsButton addGestureRecognizer:marriedButtonTappedGesture];

    UITapGestureRecognizer* singleButtonTappedGesture = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self
                                                                 action:@selector(singleButtonTapped)];
    [self.mSingleImageAsButton addGestureRecognizer:singleButtonTappedGesture];
    
    UITapGestureRecognizer* userExpensesTappedGesture = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self
                                                         action:@selector(userExpensesButtonTapped)];
    [self.mUserExpensesViewAsButton addGestureRecognizer:userExpensesTappedGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
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

    
    self.mAnnualGrossIncomeField.tag = tags++;
    self.mAnnualGrossIncomeField.delegate = self;
    self.mAnnualGrossIncomeField.inputAccessoryView = self.mKeyBoardToolbar;
    
    self.mAnnualRetirementContributionField.tag = tags++;
    self.mAnnualRetirementContributionField.delegate = self;
    self.mAnnualRetirementContributionField.inputAccessoryView = self.mKeyBoardToolbar;
    
    self.mNumberOfChildrenControl.tag = tags++;
}

-(void)doneWithNumberPad
{
    [self.mActiveField resignFirstResponder];
}

-(void) initWithCurrentUserPFInfo
{
    userPFInfo* theUserPFInfo = [kunanceUser getInstance].mkunanceUserPFInfo;
    if(theUserPFInfo)
    {
        if(theUserPFInfo.mMaritalStatus == StatusMarried)
            [self selectMarried];
        
        else if(theUserPFInfo.mMaritalStatus == StatusSingle)
            [self selectSingle];
        
        if(theUserPFInfo.mGrossAnnualIncome)
            self.mAnnualGrossIncomeField.text =
            [NSString stringWithFormat:@"%llu", theUserPFInfo.mGrossAnnualIncome];
        
        if(theUserPFInfo.mAnnualRetirementSavingsContributions)
            self.mAnnualRetirementContributionField.text =
            [NSString stringWithFormat:@"%llu", theUserPFInfo.mAnnualRetirementSavingsContributions];
        
        self.mNumberOfChildrenControl.selectedSegmentIndex = theUserPFInfo.mNumberOfChildren;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];
    
    
    [self setupNavControl];
    
    [self setupGestureRecognizers];
    
    [self initWithCurrentUserPFInfo];
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


#pragma mark Actions
-(void) marriedButtonTapped
{
    [self selectMarried];
}

-(void) singleButtonTapped
{
    [self selectSingle];
}

-(void) userExpensesButtonTapped
{
    if(self.mSelectedMaritalStatus == StatusNotDefined)
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please pick a marital status"];
        return;
    }
    else if(!self.mAnnualGrossIncomeField.text || ![self.mAnnualGrossIncomeField.text intValue])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter Annual income"];
        return;
    }
    
    userPFInfo* currentPFInfo = nil;
    
    //upload it to the back
    currentPFInfo.mMaritalStatus = self.mSelectedMaritalStatus;
    currentPFInfo.mGrossAnnualIncome = [self.mAnnualGrossIncomeField.text intValue];
    currentPFInfo.mAnnualRetirementSavingsContributions = [self.mAnnualRetirementContributionField.text intValue];
    currentPFInfo.mNumberOfChildren = self.mNumberOfChildrenControl.selectedSegmentIndex;
    
    APIService* apiService = [[APIService alloc] init];
    if(apiService)
    {
        [apiService writeUserPFInfo:[self.mAnnualGrossIncomeField.text intValue]
                   annualRetirement:[self.mAnnualRetirementContributionField.text intValue]
                   numberOfChildren:self.mNumberOfChildrenControl.selectedSegmentIndex
                      maritalStatus:self.mSelectedMaritalStatus];
    }
    
    //let the dashcontroller know that this form is done
    if(self.mAboutYouControllerDelegate &&
       [self.mAboutYouControllerDelegate respondsToSelector:@selector(userExpensesButtonTapped)])
    {
        [self.mAboutYouControllerDelegate userExpensesButtonTapped];
    }
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.mAnnualGrossIncomeField)
    {
        [self.mAnnualRetirementContributionField becomeFirstResponder];
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
