//
//  Dash2HomesEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/3/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TwoHomePaymentDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end


@interface TwoHomePaymentViewController : UIViewController
@property (nonatomic, strong) UINavigationItem* navItem;

@property (nonatomic, weak) id <TwoHomePaymentDelegate> mTwoHomePaymentDelegate;
@property (nonatomic, strong) IBOutlet UILabel* mHome1Payment;
@property (nonatomic, strong) IBOutlet UILabel* mHome2Payment;
@property (nonatomic, strong) IBOutlet UILabel* mRentalPayment;

@property (nonatomic, strong) IBOutlet UILabel* mHome1Nickname;
@property (nonatomic, strong) IBOutlet UILabel* mHome2Nickname;

@property (nonatomic, strong) IBOutlet UIImageView* mHome1TypeIcon;
@property (nonatomic, strong) IBOutlet UIImageView* mHome2TypeIcon;

@property (nonatomic, strong) IBOutlet UILabel* mHome1ComparePayment;
@property (nonatomic, strong) IBOutlet UILabel* mHome2ComparePayment;

- (UIImage*)snapshotWithOpenGLViews;
@end
