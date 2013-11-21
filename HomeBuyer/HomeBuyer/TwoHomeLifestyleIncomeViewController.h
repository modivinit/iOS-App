//
//  TwoHomeRentVsBuyViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TwoHomeLifestyleDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface TwoHomeLifestyleIncomeViewController : UIViewController
@property (nonatomic, strong) UINavigationItem* navItem;

@property (nonatomic, weak) id <TwoHomeLifestyleDelegate> mTwoHomeLifestyleDelegate;
@property (nonatomic, strong) IBOutlet UILabel* mRentalLifeStyleIncome;
@property (nonatomic, strong) IBOutlet UILabel* mHome1LifeStyleIncome;
@property (nonatomic, strong) IBOutlet UILabel* mHome2LifeStyleIncome;

@property (nonatomic, strong) IBOutlet UILabel* mHome1Nickname;
@property (nonatomic, strong) IBOutlet UILabel* mHome2Nickname;

@property (nonatomic, strong) IBOutlet UILabel* mHome1CashFlow;
@property (nonatomic, strong) IBOutlet UILabel* mHome2CashFlow;

@property (nonatomic, strong) IBOutlet UIImageView* mHome1TypeIcon;
@property (nonatomic, strong) IBOutlet UIImageView* mHome2TypeIcon;

@property (nonatomic, strong) IBOutlet UIView* mHome2CashView;

- (UIImage*)snapshotWithOpenGLViews;

@end
