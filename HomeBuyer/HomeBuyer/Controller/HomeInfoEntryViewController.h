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

@protocol HomeInfoEntryViewDelegate <NSObject>
@optional
-(void) loanInfoButtonTapped;
@end

@interface HomeInfoEntryViewController : FormViewController <APIHomeInfoServiceDelegate>
@property (nonatomic) homeType      mSelectedHomeType;

@property (nonatomic) IBOutlet UIImageView*  mSingleFamilyImageAsButton;
@property (nonatomic) IBOutlet UIImageView*  mCondoImageAsButton;
@property (nonatomic) IBOutlet UITextField*   mBestHomeFeatureField;
@property (nonatomic) IBOutlet UITextField*   mAskingPriceField;
@property (nonatomic) IBOutlet UITextField*   mMontylyHOAField;
@property (nonatomic) IBOutlet UIButton*      mHomeAddressButton;
@property (nonatomic) IBOutlet UIView*       mLoanInfoViewAsButton;
@property (nonatomic) IBOutlet UIView*       mCompareHomesViewAsButton;
@property (nonatomic, strong) IBOutlet UIImageView* mDashboardIcon;

@property (nonatomic) uint mHomeNumber;
@property (nonatomic, weak) id <HomeInfoEntryViewDelegate> mHomeInfoEntryViewDelegate;

@property (nonatomic, strong) homeInfo*  mCorrespondingHomeInfo;
-(IBAction) enterHomeAddressButtonTapped;
-(id) initAsHomeNumber:(uint) homeNumber;
@end