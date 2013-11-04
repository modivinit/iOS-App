//
//  TermsAndPoliciesViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/9/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsAndPoliciesViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIView* mPrivacyPolicyView;
@property (nonatomic, strong) IBOutlet UIView* mTermsOfUserView;
@property (nonatomic, strong) IBOutlet UISegmentedControl* mSegmentedControl;

@property (nonatomic, strong) IBOutlet UIButton* mDashboardButton;
-(IBAction)dashboardButtonTapped:(id)sender;
@end
