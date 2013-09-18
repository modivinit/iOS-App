//
//  AboutYouViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/15/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "AboutYouViewController.h"
#import "userPFInfo.h"

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
}

-(void)doneWithNumberPad{
    [self.mActiveField resignFirstResponder];
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
    self.mAnnualGrossIncomeField.inputAccessoryView = self.mKeyBoardToolbar;
    self.mAnnualGrossIncomeField.delegate = self;
    
    self.mAnnualRetirementContributionField.tag = tags++;
    self.mAnnualRetirementContributionField.inputAccessoryView = self.mKeyBoardToolbar;
    self.mAnnualRetirementContributionField.delegate = self;

    self.mNumberOfChildrenControl.tag = tags++;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self.mFormScrollView setContentSize:CGSizeMake(320, 260)];

    self.mAllFields = [[NSArray alloc] initWithObjects:self.mAnnualGrossIncomeField, self.mAnnualRetirementContributionField, self.mNumberOfChildrenControl,  nil];
    
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
    
    [self setupNavControl];
    
    [self setupGestureRecognizers];

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
    //Extract the form info into the UserPFInfo object of the current user
    
    userPFInfo* currentPFInfo = [[userPFInfo alloc] init];
    currentPFInfo.mMaritalStatus = self.mSelectedMaritalStatus;
    currentPFInfo.mGrossAnnualIncome = [self.mAnnualGrossIncomeField.text intValue];
    currentPFInfo.mAnnualRetirementSavingsContributions = [self.mAnnualRetirementContributionField.text intValue];
    
    currentPFInfo.mNumberOfChildren = self.mNumberOfChildrenControl.selectedSegmentIndex;
    
    //upload it to the back
    if([kunanceUser getInstance].mkunanceUserPFInfo)
        [self updateUserPfObj:currentPFInfo];
    else
        [self createUserPFObj:currentPFInfo];
    
    //let the dashcontroller know that this form is done
}

-(void) updateUserPfObj:(userPFInfo*) currentPFInfo
{
    FatFractal *ff = [FatFractal main];
    [ff updateObj:currentPFInfo onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        // handle error, response
        if(obj)
        {
            NSLog(@"updated USer PF Info: %@", (userPFInfo*)obj);
        }
        else
        {
            NSLog(@"Error Uploading User PF Info");
        }
    }];
}

-(void) createUserPFObj:(userPFInfo*) currentPFInfo
{
    FatFractal *ff = [FatFractal main];
    [ff createObj:currentPFInfo atUri:@"/UserPFInfo" onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        // handle error, response
        if(obj)
        {
            userPFInfo* createdPF = (userPFInfo*)obj;
            NSLog(@"created USer PF Info %@", createdPF);
            createdPF.mUserPFInfoGUID = [[ff metaDataForObj:createdPF] guid];
            [kunanceUser getInstance].mkunanceUserPFInfo = createdPF;
        }
        else
        {
            NSLog(@"Error Uploading User PF Info");
        }
    }];
}

#pragma mark - UITextField
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
    UIEdgeInsets tmpContainerContentInset = self.mFormScrollView.contentInset;
	
    tmpContainerContentInset.bottom = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [self.mFormScrollView setScrollIndicatorInsets:tmpContainerContentInset];
    
    NSTimeInterval tmpAnimationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:tmpAnimationDuration
                     animations:^{
                         [self.mFormScrollView setContentInset:tmpContainerContentInset];
                     }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mFormScrollView.contentInset = contentInsets;
    self.mFormScrollView.scrollIndicatorInsets = contentInsets;
}
@end