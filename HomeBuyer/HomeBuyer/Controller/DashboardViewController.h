//
//  DashboardViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/6/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+PKRevealController.h"
#import "AboutYouViewController.h"
#import "ExpensesViewController.h"

@interface DashboardViewController : UIViewController<AboutYouControllerDelegate, ExpensesControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView* mDashBoardMasterView;

@end
