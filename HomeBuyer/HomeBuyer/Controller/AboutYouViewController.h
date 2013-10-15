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
#import "APIUserInfoService.h"
#import "FixedCostsViewController.h"

@interface AboutYouViewController : FormViewController
<APIUserInfoServiceDelegate, FixedCostsControllerDelegate>
@property (nonatomic) userMaritalStatus      mSelectedMaritalStatus;
@property (nonatomic, strong) FixedCostsViewController* mFixedCostsController;

@property (nonatomic) IBOutlet UIImageView*  mMarriedImageAsButton;
@property (nonatomic) IBOutlet UIImageView*  mSingleImageAsButton;
@property (nonatomic) IBOutlet UITextField*   mAnnualGrossIncomeField;
@property (nonatomic) IBOutlet UITextField*   mAnnualRetirementContributionField;
@property (nonatomic) IBOutlet UISegmentedControl* mNumberOfChildrenControl;

@property (nonatomic, strong) IBOutlet UIButton*  mDashboardButton;
@property (nonatomic, strong) IBOutlet UIButton*  mHelpButton;
@property (nonatomic, strong) IBOutlet UIButton*  mFixedCostsButton;

-(IBAction)fixedCostsButtonTapped:(id)sender;
-(IBAction)dashButtonTapped:(id)sender;
-(IBAction)helpButtonTapped:(id)sender;

@end
