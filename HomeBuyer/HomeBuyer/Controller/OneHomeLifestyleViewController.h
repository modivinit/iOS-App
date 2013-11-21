//
//  Dash1HomeEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneHomeLifestyleViewDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface OneHomeLifestyleViewController : UIViewController

@property (nonatomic, weak) id <OneHomeLifestyleViewDelegate> mOneHomeLifestyleViewDelegate;
@property (nonatomic, strong) IBOutlet UILabel* mRentalLifeStyleIncome;
@property (nonatomic, strong) IBOutlet UILabel* mHomeLifeStyleIncome;

@property (nonatomic, strong) IBOutlet UILabel* mHomeNickName;
@property (nonatomic, strong) IBOutlet UIImageView* mHomeTypeIcon;
@property (nonatomic, strong) IBOutlet UILabel* mHome1CashFlow;
@property (nonatomic, strong) IBOutlet UIView* mCompareView;

- (UIImage*)snapshotWithOpenGLViews;
@end
