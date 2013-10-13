//
//  ExpensesViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/16/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIUserInfoService.h"
#import "FormViewController.h"
@interface FixedCostsViewController : FormViewController <APIUserInfoServiceDelegate>

@property (nonatomic, strong) IBOutlet UITextField* mMonthlyRent;
@property (nonatomic, strong) IBOutlet UITextField* mMonthlyCarPayments;
@property (nonatomic, strong) IBOutlet UITextField* mOtherMonthlyPayments;
@property (nonatomic) IBOutlet UIView*  mCurrentLifestyleIncomeViewAsButton;
@property (nonatomic, strong) IBOutlet UIImageView* mDashboardIcon;

@end
