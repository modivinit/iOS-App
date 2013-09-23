//
//  AboutYouViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/15/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userPFInfo.h"

@protocol AboutYouControllerDelegate <NSObject>
-(void) userExpensesButtonTapped;
@end

@interface AboutYouViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) UISegmentedControl *mNavControl;
@property (nonatomic, strong) UIToolbar *mKeyBoardToolbar;
@property (nonatomic, strong) UIView*    mActiveField;
@property (nonatomic, strong) IBOutlet UIScrollView* mFormScrollView;

@property (nonatomic) userMaritalStatus      mSelectedMaritalStatus;

@property (nonatomic, strong)  NSArray*      mAllFields;
@property (nonatomic) IBOutlet UIImageView*  mMarriedImageAsButton;
@property (nonatomic) IBOutlet UIImageView*  mSingleImageAsButton;
@property (nonatomic) IBOutlet UITextField*   mAnnualGrossIncomeField;
@property (nonatomic) IBOutlet UITextField*   mAnnualRetirementContributionField;
@property (nonatomic) IBOutlet UISegmentedControl* mNumberOfChildrenControl;
@property (nonatomic) IBOutlet UIView*  mUserExpensesViewAsButton;

@property (nonatomic, weak) id <AboutYouControllerDelegate> mAboutYouControllerDelegate;
@end
