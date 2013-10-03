//
//  DashUserPFInfoViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoViewController.h"
#import "LoanInfoViewController.h"

@protocol DashUserPFInfoDelegate <NSObject>
-(void) showAndCalculateRentVsBuy;
@end

@interface DashUserPFInfoViewController : UIViewController <HomeInfoViewDelegate, LoanInfoViewDelegate>
@property (nonatomic, strong) IBOutlet UIView* mAddAHomeViewAsButton;
@property (nonatomic, strong) HomeInfoViewController* mHomeInfoViewController;
@property (nonatomic, strong) LoanInfoViewController* mLoanInfoViewController;

@property (nonatomic,weak) id <DashUserPFInfoDelegate> mDashUserPFInfoDelegate;
@end
