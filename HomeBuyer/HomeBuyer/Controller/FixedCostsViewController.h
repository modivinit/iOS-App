//
//  ExpensesViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/16/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIService.h"
#import "FormViewController.h"

@protocol ExpensesControllerDelegate <NSObject>
-(void) currentLifeStyleIncomeButtonPressed;
@end

@interface FixedCostsViewController : FormViewController <APIServiceDelegate>

@property (nonatomic, strong) IBOutlet UITextField* mMonthlyRent;
@property (nonatomic, strong) IBOutlet UITextField* mMonthlyCarPayments;
@property (nonatomic, strong) IBOutlet UITextField* mOtherMonthlyPayments;
@property (nonatomic) IBOutlet UIView*  mCurrentLifestyleIncomeViewAsButton;


@property (nonatomic, weak) id <ExpensesControllerDelegate> mExpensesControllerDelegate;
@end
