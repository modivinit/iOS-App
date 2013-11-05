//
//  DashOneHomeEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import "OneHomeLifestyleViewController.h"
#import "OneHomeTaxSavingsViewController.h"
#import "HomeInfoEntryViewController.h"
#import "OneHomePaymentViewController.h"

@interface DashOneHomeEnteredViewController : BasePageViewController
<OneHomeLifestyleViewDelegate, OneHomeTaxSavingsViewDelegate, OneHomePaymentViewDelegate>
@property (nonatomic, strong) HomeInfoEntryViewController* mHomeInfoViewController;

@property (nonatomic, strong) UIButton* mContactRealtorIconButton;
@property (nonatomic, strong) UIButton* mContactRealtorButton;

@property (nonatomic, strong) UIButton* mHelpButton;
@property (nonatomic, strong) UIButton* mAddHomeButton;

-(void) hideLeftView;
-(void)showLeftView;

@end
