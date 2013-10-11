//
//  HomeInfoViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeInfoEntryViewController.h"

@interface HomeInfoEntryViewController ()

@end

@implementation HomeInfoEntryViewController

- (id)initAsHomeNumber:(uint)homeNumber
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        self.mSelectedHomeType = homeTypeNotDefined;
        self.mHomeNumber = homeNumber;
    }

    return self;
}

-(void) addExistingHomeInfo
{
    self.mCorrespondingHomeInfo = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:self.mHomeNumber];
    if(self.mCorrespondingHomeInfo)
    {
        if(self.mCorrespondingHomeInfo.mHomeType == homeTypeSingleFamily)
            [self selectSingleFamilyHome];
        else if(self.mCorrespondingHomeInfo.mHomeType == homeTypeCondominium)
            [self selectCondominuim];
        
        if(self.mCorrespondingHomeInfo.mHomeListPrice)
            self.mAskingPriceField.text = [NSString stringWithFormat:@"%llu", self.mCorrespondingHomeInfo.mHomeListPrice];
        
        if(self.mCorrespondingHomeInfo.mIdentifiyingHomeFeature)
            self.mBestHomeFeatureField.text = self.mCorrespondingHomeInfo.mIdentifiyingHomeFeature;
        
        if(self.mCorrespondingHomeInfo.mHOAFees)
            self.mMontylyHOAField.text = [NSString stringWithFormat:@"%d", self.mCorrespondingHomeInfo.mHOAFees];
    }
}

-(void) selectSingleFamilyHome
{
    self.mSingleFamilyImageAsButton.image = [UIImage imageNamed:@"sfh-homeinfo-selected.png"];
    self.mCondoImageAsButton.image = [UIImage imageNamed:@"condo.png"];
    
    self.mSelectedHomeType = homeTypeSingleFamily;
}

-(void) selectCondominuim
{
    self.mSingleFamilyImageAsButton.image = [UIImage imageNamed:@"sfh-homeinfo.png"];
    self.mCondoImageAsButton.image = [UIImage imageNamed:@"condo-selected.png"];
    
    self.mSelectedHomeType = homeTypeCondominium;
}

-(void) setupGestureRecognizers
{
    [self.mFormScrollView setCanCancelContentTouches:YES];

    UITapGestureRecognizer* sfhButtonTappedGesture = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(sfhButtonTapped:)];
    [self.mSingleFamilyImageAsButton addGestureRecognizer:sfhButtonTappedGesture];
    
    UITapGestureRecognizer* condoButtonTappedGesture = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self
                                                        action:@selector(condoButtonTapped:)];
    [self.mCondoImageAsButton addGestureRecognizer:condoButtonTappedGesture];
    
    UITapGestureRecognizer* loanInfoTappedGesture = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self
                                                     action:@selector(loanInfoButtonTapped:)];
    [self.mLoanInfoViewAsButton addGestureRecognizer:loanInfoTappedGesture];
    
    UITapGestureRecognizer* compareHomesGesture = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(compareHomesButtonTapped:)];
    [self.mCompareHomesViewAsButton addGestureRecognizer:compareHomesGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer* dboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dashButtonTapped)];
    [self.mDashboardIcon addGestureRecognizer:dboardTap];
}

-(void) setupButtons
{
    if([kunanceUser getInstance].mKunanceUserLoan)
    {
        self.mCompareHomesViewAsButton.hidden = NO;
        self.mLoanInfoViewAsButton.hidden = YES;
    }
    else
    {
        self.mCompareHomesViewAsButton.hidden = YES;
        self.mLoanInfoViewAsButton.hidden = NO;
    }
}

- (void)viewDidLoad
{
    self.mFormFields = [[NSArray alloc] initWithObjects:
    self.mBestHomeFeatureField,
    self.mAskingPriceField,
    self.mMontylyHOAField, nil];
    
    [self.mFormScrollView setContentSize:CGSizeMake(320, 100)];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupGestureRecognizers];
    
    [self setupButtons];
    [self addExistingHomeInfo];
    
    if(self.mHomeNumber == FIRST_HOME)
        self.navigationController.navigationBar.topItem.title = @"First Home Info";
    else if(self.mHomeNumber == SECOND_HOME)
        self.navigationController.navigationBar.topItem.title = @"Second Home Info";

}

-(void) uploadHomeInfo
{
    if(!self.mBestHomeFeatureField.text || !self.mAskingPriceField.text || (self.mSelectedHomeType == homeTypeNotDefined))
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter all necessary fields"];
        return;
    }
    
    uint currentNumberOfHomes = [[kunanceUser getInstance].mKunanceUserHomes getCurrentHomesCount];
    
    APIHomeInfoService* homeInfoService = [[APIHomeInfoService alloc] init];
    
    homeInfo* aHomeInfo = nil;
    if(self.mCorrespondingHomeInfo)
        aHomeInfo = self.mCorrespondingHomeInfo;
    else
        aHomeInfo = [[homeInfo alloc] init];
    
    aHomeInfo.mHomeType = self.mSelectedHomeType;
    aHomeInfo.mIdentifiyingHomeFeature = self.mBestHomeFeatureField.text;
    aHomeInfo.mHomeListPrice = [self.mAskingPriceField.text intValue];
    
    if(self.mMontylyHOAField.text)
        aHomeInfo.mHOAFees = [self.mMontylyHOAField.text intValue];
    else if(self.mCorrespondingHomeInfo && self.mCorrespondingHomeInfo.mHOAFees)
        aHomeInfo.mHOAFees = self.mCorrespondingHomeInfo.mHOAFees;
    
    if(homeInfoService)
    {
        homeInfoService.mAPIHomeInfoDelegate = self;
        if(!self.mCorrespondingHomeInfo)
        {
            aHomeInfo.mHomeId = currentNumberOfHomes+1;
            
            if(![homeInfoService createNewHomeInfo:aHomeInfo])
                [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to create home info"];
        }
        else
        {
            if(![homeInfoService updateExistingHomeInfo:aHomeInfo])
                [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to update home info"];
        }
    }

}

#pragma mark actions gestures
-(void) dashButtonTapped
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayDashNotification object:nil];
}

-(void) compareHomesButtonTapped:(UITapGestureRecognizer*)recognizer
{
    [self uploadHomeInfo];
}

-(IBAction) enterHomeAddressButtonTapped
{
}

-(void) sfhButtonTapped:(UITapGestureRecognizer*)recognizer
{
    [self selectSingleFamilyHome];
}

-(void) condoButtonTapped:(UITapGestureRecognizer*)recognizer
{
    [self selectCondominuim];
}

-(void) loanInfoButtonTapped:(UITapGestureRecognizer*)recognizer
{
    [self uploadHomeInfo];
}
#pragma mark end

#pragma mark APIHomeInfoServiceDelegate
-(void) finishedWritingHomeInfo
{
    if(!self.mLoanInfoViewAsButton.hidden)
    {
        if(self.mHomeInfoEntryViewDelegate && [self.mHomeInfoEntryViewDelegate respondsToSelector:@selector(loanInfoButtonTapped)])
        {
            [self.mHomeInfoEntryViewDelegate loanInfoButtonTapped];
        }
    }
    else if(!self.mCompareHomesViewAsButton.hidden)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayDashNotification object:nil];
    }
}
#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
