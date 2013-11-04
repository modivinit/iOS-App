//
//  DashTwoHomesEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import <PKRevealController/PKRevealController.h>
#import "TwoHomePaymentViewController.h"
#import "TwoHomeLifestyleIncomeViewController.h"
#import "TwoHomeTaxSavingsViewController.h"

@interface DashTwoHomesEnteredViewController : BasePageViewController
<TwoHomePaymentDelegate, TwoHomeLifestyleDelegate, TwoHomeTaxSavingsDelegate>
@property (nonatomic, strong) UIButton* mContactRealtorButton;
@property (nonatomic, strong) UIButton* mHelpButton;

-(void) hideLeftView;
-(void)showLeftView;
@end
