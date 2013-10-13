//
//  DashOneHomeEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import "RentVsBuyDashViewController.h"
#import "HomeTaxSavingsViewController.h"
#import "HomeInfoEntryViewController.h"

@interface DashOneHomeEnteredViewController : BasePageViewController
<RentVsBuyDashViewDelegate,HomeInfoEntryViewDelegate, HomeTaxSavingsViewDelegate>
@property (nonatomic, strong) HomeInfoEntryViewController* mHomeInfoViewController;

@property (nonatomic, strong) UIButton* mContactRealtorButton;
@property (nonatomic, strong) UIButton* mHelpButton;
@property (nonatomic, strong) UIButton* mAddHomeButton;

-(void) hideLeftView;
-(void)showLeftView;

@end
