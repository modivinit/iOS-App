//
//  OneHomePaymentViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoEntryViewController.h"

@protocol OneHomePaymentViewDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end


@interface OneHomePaymentViewController : UIViewController
@property (nonatomic, weak) id <OneHomePaymentViewDelegate> mOneHomePaymentViewDelegate;
@property (nonatomic, strong) IBOutlet UILabel* mHomePaymentLabel;
@property (nonatomic, strong) IBOutlet UILabel* mRentalPaymentLabel;

@property (nonatomic, strong) IBOutlet UILabel* mHomeNickName;
@property (nonatomic, strong) IBOutlet UIImageView* mHomeTypeIcon;

@property (nonatomic, strong) IBOutlet UILabel* mHome1ComparePayment;

@property (nonatomic, strong) HomeInfoEntryViewController* mHomeInfoViewController;

@property (nonatomic) IBOutlet UIButton* mAddAHomeButton;
-(IBAction)addAHomeTapped:(id)sender;

- (UIImage*)snapshotWithOpenGLViews;
@end
