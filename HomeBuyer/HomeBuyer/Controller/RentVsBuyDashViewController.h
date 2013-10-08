//
//  Dash1HomeEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoViewController.h"
#import "DashLeftMenuViewController.h"

@protocol RentVsBuyDashViewDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface RentVsBuyDashViewController : UIViewController<HomeInfoViewDelegate>
@property (nonatomic, strong) IBOutlet UIView* mAddAHomeButtonAsView;
@property (nonatomic, strong) HomeInfoViewController* mHomeInfoViewController;

@property (nonatomic, weak) id <RentVsBuyDashViewDelegate> mRentVsBuyDashViewDelegate;
@end
