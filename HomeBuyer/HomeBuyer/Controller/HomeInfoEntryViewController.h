//
//  HomeInfoViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"
#import "homeInfo.h"
#import "APIHomeInfoService.h"
#import "LoanInfoViewController.h"

@interface HomeInfoEntryViewController : FormViewController <APIHomeInfoServiceDelegate, LoanInfoViewDelegate>
@property (nonatomic) homeType      mSelectedHomeType;
@property (nonatomic) uint mHomeNumber;
@property (nonatomic, strong) homeInfo*  mCorrespondingHomeInfo;
@property (nonatomic, strong) LoanInfoViewController* mLoanInfoController;
-(id) initAsHomeNumber:(uint) homeNumber;

@property (nonatomic, strong) IBOutlet UIImageView*  mSingleFamilyImageAsButton;
@property (nonatomic, strong) IBOutlet UIImageView*  mCondoImageAsButton;
@property (nonatomic, strong) IBOutlet UITextField*   mBestHomeFeatureField;
@property (nonatomic, strong) IBOutlet UITextField*   mAskingPriceField;
@property (nonatomic, strong) IBOutlet UITextField*   mMontylyHOAField;

@property (nonatomic, strong) IBOutlet UIButton*       mHomeAddressButton;
-(IBAction) enterHomeAddressButtonTapped;

@property (nonatomic, strong) IBOutlet UIButton*       mLoanInfoViewAsButton;
-(IBAction)loanInfoButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*       mShowHomePayments;
-(IBAction)showHomePaymentsButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*       mDashboardIcon;
-(IBAction)dashButtonTapped:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*       mHelpButton;
-(IBAction)helpButtonTapped:(id)sender;
@end
