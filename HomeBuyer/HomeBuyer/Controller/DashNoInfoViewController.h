//
//  DashNoInfoViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutYouViewController.h"
#import "FixedCostsViewController.h"
#import "UIViewController+PKRevealController.h"
#import "PKRevealController.h"

@protocol DashNoInfoViewDelegate <NSObject>
-(void) showAndCalcCurrentLifeStyleIncome;
@end

@interface DashNoInfoViewController : UIViewController <AboutYouControllerDelegate, ExpensesControllerDelegate>
@property (nonatomic, strong) IBOutlet UIView* mCompositeAboutYouButton;
@property (nonatomic, strong) AboutYouViewController* mAboutYouViewController;
@property (nonatomic, strong) FixedCostsViewController* mFixedCostsViewController;

@property (nonatomic, weak) id <DashNoInfoViewDelegate> mDashNoInfoViewDelegate;
@end
