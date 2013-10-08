//
//  DashTwoHomesEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import "PKRevealController.h"
#import "Home1VsHome2ViewController.h"
#import "HomesComparisionViewController.h"
#import "TwoHomeRentVsBuyViewController.h"

@interface DashTwoHomesEnteredViewController : BasePageViewController
<Homes1VsHome2Delegate, HomesComparisionDelegate, TwoHomeRentVsBuyDelegate>
@property (nonatomic, strong) IBOutlet UIButton* mDashImageAsButton;
@property (nonatomic, strong) IBOutlet UIImageView* mHelpImageAsButton;

-(IBAction)dashButtonTapped:(id)sender;

-(void) hideLeftView;
-(void)showLeftView;
@end