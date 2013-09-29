//
//  AboutYouViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/15/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userPFInfo.h"
#import "FormViewController.h"

@protocol AboutYouControllerDelegate <NSObject>
-(void) userExpensesButtonTapped;
@end

@interface AboutYouViewController : FormViewController

@property (nonatomic, strong) UISegmentedControl *mNavControl;
@property (nonatomic) userMaritalStatus      mSelectedMaritalStatus;

@property (nonatomic) IBOutlet UIImageView*  mMarriedImageAsButton;
@property (nonatomic) IBOutlet UIImageView*  mSingleImageAsButton;
@property (nonatomic) IBOutlet UITextField*   mAnnualGrossIncomeField;
@property (nonatomic) IBOutlet UITextField*   mAnnualRetirementContributionField;
@property (nonatomic) IBOutlet UISegmentedControl* mNumberOfChildrenControl;
@property (nonatomic) IBOutlet UIView*  mUserExpensesViewAsButton;

@property (nonatomic, weak) id <AboutYouControllerDelegate> mAboutYouControllerDelegate;
@end
