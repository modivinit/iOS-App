//
//  HomeInfoViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeInfoViewController.h"

@interface HomeInfoViewController ()

@end

@implementation HomeInfoViewController

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

- (id)initWithExistingHomeInfo:(homeInfo*) aHomeInfo
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        self.mSelectedHomeType = homeTypeNotDefined;
        if(aHomeInfo)
        {
            self.mCorrespondingHomeInfo = aHomeInfo;
        }
    }
    return self;
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
}

-(void) setupAsFirstHome
{
    self.mCompareHomesViewAsButton.hidden = YES;
    self.mLoanInfoViewAsButton.hidden = NO;
}

-(void) setupAsSecondHome
{
    self.mCompareHomesViewAsButton.hidden = NO;
    self.mLoanInfoViewAsButton.hidden = YES;
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
    
    if(self.mHomeNumber == FIRST_HOME)
    {
        [self setupAsFirstHome];
    }
    else if(self.mHomeNumber == SECOND_HOME)
    {
        [self setupAsSecondHome];
    }
}

-(void) uploadHomeInfo
{
    if(!self.mBestHomeFeatureField.text || !self.mAskingPriceField.text || (self.mSelectedHomeType == homeTypeNotDefined))
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter all necessary fields"];
        return;
    }
    
    uint currentNumberOfHomes = [[kunanceUser getInstance].mKunanceUserHomes getCurrentHomesCount];
    
    if((currentNumberOfHomes+1) != self.mHomeNumber)
    {
        NSLog(@"uploadHomeInfo Error: home numbers do not match, current+1 = %d, future = %d", currentNumberOfHomes+1, self.mHomeNumber);
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Internal Error"];
        return;
    }
    
    APIHomeInfoService* homeInfoService = [[APIHomeInfoService alloc] init];
    homeInfo* aHomeInfo = [[homeInfo alloc] init];
    
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
    if(self.mHomeNumber == FIRST_HOME)
    {
        if(self.mHomeInfoViewDelegate && [self.mHomeInfoViewDelegate respondsToSelector:@selector(loanInfoButtonTapped)])
        {
            [self.mHomeInfoViewDelegate loanInfoButtonTapped];
        }
    }
    else if(self.mHomeNumber == SECOND_HOME)
    {
        if(self.mHomeInfoViewDelegate &&
           [self.mHomeInfoViewDelegate respondsToSelector:@selector(calculateAndCompareHomes)])
        {
            [self.mHomeInfoViewDelegate calculateAndCompareHomes];
        }
    }
}
#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
