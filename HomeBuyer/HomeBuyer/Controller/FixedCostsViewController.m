//
//  ExpensesViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/16/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "FixedCostsViewController.h"
#import "kunanceUser.h"

@interface FixedCostsViewController ()

@end

@implementation FixedCostsViewController

-(void) addGestureRecognizers
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    UITapGestureRecognizer* currentLifestyleTappedGesture = [[UITapGestureRecognizer alloc]
                                                             initWithTarget:self
                                                             action:@selector(currentLifeStyleIncomeTapped)];
    [self.mCurrentLifestyleIncomeViewAsButton addGestureRecognizer:currentLifestyleTappedGesture];
}

- (void)viewDidLoad
{
    self.mFormFields = [[NSArray alloc] initWithObjects:self.mMonthlyRent,
                self.mMonthlyCarPayments, self.mOtherMonthlyPayments, nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addGestureRecognizers];
    
    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark APIServiceDelegate
-(void) finishedWritingUserPFInfo
{
    if([kunanceUser getInstance].mkunanceUserPFInfo.mFixedCostsInfoEntered)
    {
        if(self.mExpensesControllerDelegate &&
           [self.mExpensesControllerDelegate respondsToSelector:@selector(currentLifeStyleIncomeButtonPressed)])
        {
            [self.mExpensesControllerDelegate currentLifeStyleIncomeButtonPressed];
        }
    }
    else
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sorry. Unable to connect to server"];
    }
}
#pragma end

#pragma mark Action Functions
//IBActions, target action, gesture targets
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
    
    APIService* service = [[APIService alloc] init];
    if(service)
    {
//        service.mAPIServiceDelegate = self;
//        [service writeFixedCostsInfo:[self.mMonthlyRent.text intValue]
//                   monthlyCarPaments:[self.mMonthlyCarPayments.text intValue]
//                     otherFixedCosts:[self.mOtherMonthlyPayments.text intValue]];
    }
    
    [self.mExpensesControllerDelegate currentLifeStyleIncomeButtonPressed];

}
@end
