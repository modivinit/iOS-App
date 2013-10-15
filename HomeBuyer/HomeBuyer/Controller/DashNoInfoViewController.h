//
//  DashNoInfoViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutYouViewController.h"
#import "UIViewController+PKRevealController.h"
#import "DashLeftMenuViewController.h"


@interface DashNoInfoViewController : DashLeftMenuViewController //<AboutYouControllerDelegate>
@property (nonatomic, strong) IBOutlet UIView* mCompositeAboutYouButton;
@property (nonatomic, strong) AboutYouViewController* mAboutYouViewController;
@end
