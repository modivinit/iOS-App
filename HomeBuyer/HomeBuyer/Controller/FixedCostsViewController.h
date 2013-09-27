//
//  ExpensesViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/16/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIService.h"

@protocol ExpensesControllerDelegate <NSObject>
-(void) currentLifeStyleIncomeButtonPressed;
@end

@interface FixedCostsViewController : UIViewController<UITextFieldDelegate, APIServiceDelegate>

@property (nonatomic, strong) IBOutlet UITextField* mMonthlyRent;
@property (nonatomic, strong) IBOutlet UITextField* mMonthlyCarPayments;
@property (nonatomic, strong) IBOutlet UITextField* mOtherMonthlyPayments;
@property (nonatomic, strong) IBOutlet UIScrollView* mFormScrollView;
@property (nonatomic) IBOutlet UIView*  mCurrentLifestyleIncomeViewAsButton;


@property (nonatomic, strong) UIToolbar *mKeyBoardToolbar;
@property (nonatomic, strong) UIView*    mActiveField;


@property (nonatomic, weak) id <ExpensesControllerDelegate> mExpensesControllerDelegate;
@end
