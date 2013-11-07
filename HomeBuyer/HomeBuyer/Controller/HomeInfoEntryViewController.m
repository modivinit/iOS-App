//
//  HomeInfoViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeInfoEntryViewController.h"
#import "HelpHomeViewController.h"
#import "Cities.h"
#import "States.h"
#import <MBProgressHUD.h>

#define MAX_HOME_PRICE_LENGTH 10
#define MAX_HOA_PRICE_LENGTH 5

@interface HomeInfoEntryViewController ()
@property (nonatomic, copy) NSString* mHomeStreetAddress;
@property (nonatomic, copy) NSString* mHomeCity;
@property (nonatomic, copy) NSString* mHomeState;
@property (nonatomic, copy) NSString* mHomeZip;
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
        self.mLoanInfoController = nil;
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
            self.mAskingPriceField.text =
            [NSString stringWithFormat:@"%llu", self.mCorrespondingHomeInfo.mHomeListPrice];
        
        if(self.mCorrespondingHomeInfo.mIdentifiyingHomeFeature)
            self.mBestHomeFeatureField.text = self.mCorrespondingHomeInfo.mIdentifiyingHomeFeature;
        
        if(self.mCorrespondingHomeInfo.mHOAFees)
            self.mMontylyHOAField.text = [NSString stringWithFormat:@"%d", self.mCorrespondingHomeInfo.mHOAFees];
        
        if(self.mCorrespondingHomeInfo.mHomeAddress)
        {
            homeAddress* address = self.mCorrespondingHomeInfo.mHomeAddress;
            
            [Utilities emptyIfNil:address.mStreetAddress];
            [Utilities emptyIfNil:address.mCity];
            [Utilities emptyIfNil:address.mState];
            
            NSString* addressStr = nil;
            
            if(address.mState || address.mCity || address.mStreetAddress)
            {
                addressStr = [NSString stringWithFormat:@"%@, %@, %@",
                                     address.mStreetAddress,
                                     address.mCity,
                                     address.mState];
                [self.mHomeAddressButton setTitle:addressStr forState:UIControlStateNormal];
            }
        }
    }
}

-(void) selectSingleFamilyHome
{
    [self.mSingleFamilyButton setImage:[UIImage imageNamed:@"sfh-homeinfo-selected.png"] forState:UIControlStateNormal];
    [self.mCondoButton setImage:[UIImage imageNamed:@"condo.png"] forState:UIControlStateNormal];
    
    self.mSelectedHomeType = homeTypeSingleFamily;
}

-(void) selectCondominuim
{
    [self.mSingleFamilyButton setImage:[UIImage imageNamed:@"sfh-homeinfo.png"] forState:UIControlStateNormal];
    [self.mCondoButton setImage:[UIImage imageNamed:@"condo-selected.png"] forState:UIControlStateNormal];;
    
    self.mSelectedHomeType = homeTypeCondominium;
}

-(void) setupGestureRecognizers
{
    [self.mFormScrollView setCanCancelContentTouches:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void) setupButtons
{
    if([[kunanceUser getInstance].mKunanceUserLoans getCurrentLoanCount])
    {
        self.mShowHomePayments.hidden = NO;
        self.mLoanInfoViewAsButton.hidden = YES;
    }
    else
    {
        self.mShowHomePayments.hidden = YES;
        self.mLoanInfoViewAsButton.hidden = NO;
    }
}

- (void)viewDidLoad
{
    self.mFormFields = [[NSArray alloc] initWithObjects:
    self.mBestHomeFeatureField,
    self.mAskingPriceField,
    self.mMontylyHOAField, nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupGestureRecognizers];
    
    [self setupButtons];
    [self addExistingHomeInfo];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.mFormScrollView setContentSize:CGSizeMake(320, 400)];

    self.mAskingPriceField.maxLength = MAX_HOME_PRICE_LENGTH;
    self.mMontylyHOAField.maxLength = MAX_HOA_PRICE_LENGTH;
    
    self.navigationController.navigationBar.topItem.title = @"Enter Home Info";
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Entered Dashboard Help Screen" properties:Nil];
    
    self.mHomeAddressButton.titleLabel.textAlignment = NSTextAlignmentLeft;
}

-(void) uploadHomeInfo
{
    if(!self.mBestHomeFeatureField.text || self.mAskingPriceField.amount <= 0 ||
       (self.mSelectedHomeType == homeTypeNotDefined))
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Please enter all necessary fields"];
        return;
    }
    
    
    uint currentNumberOfHomes = [[kunanceUser getInstance].mKunanceUserHomes getCurrentHomesCount];
    
    
    homeInfo* aHomeInfo = nil;
    if(self.mCorrespondingHomeInfo)
        aHomeInfo = self.mCorrespondingHomeInfo;
    else
        aHomeInfo = [[homeInfo alloc] init];
    
    aHomeInfo.mHomeType = self.mSelectedHomeType;
    aHomeInfo.mIdentifiyingHomeFeature = self.mBestHomeFeatureField.text;
    aHomeInfo.mHomeListPrice = [self.mAskingPriceField.amount longValue];
    
    if(self.mMontylyHOAField.text)
        aHomeInfo.mHOAFees = [self.mMontylyHOAField.amount longValue];
    else if(self.mCorrespondingHomeInfo && self.mCorrespondingHomeInfo.mHOAFees)
        aHomeInfo.mHOAFees = self.mCorrespondingHomeInfo.mHOAFees;

    aHomeInfo.mHomeAddress = [[homeAddress alloc] init];
    if(self.mHomeStreetAddress)
        aHomeInfo.mHomeAddress.mStreetAddress = self.mHomeStreetAddress;
    
    if(self.mHomeState)
        aHomeInfo.mHomeAddress.mState = self.mHomeState;
        
    if(self.mHomeCity)
        aHomeInfo.mHomeAddress.mCity = self.mHomeCity;
    
    if(self.mHomeZip)
        aHomeInfo.mHomeAddress.mZipCode = self.mHomeZip;
    
    if(![kunanceUser getInstance].mKunanceUserHomes)
        [kunanceUser getInstance].mKunanceUserHomes = [[UsersHomesList alloc] init];

    [kunanceUser getInstance].mKunanceUserHomes.mUsersHomesListDelegate = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Updating";

    if(!self.mCorrespondingHomeInfo)
    {
        aHomeInfo.mHomeId = currentNumberOfHomes+1;
        
        if(![[kunanceUser getInstance].mKunanceUserHomes createNewHomeInfo:aHomeInfo])
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to create home info"];
        }

        self.mCorrespondingHomeInfo = aHomeInfo;
    }
    else
    {
        if(![[kunanceUser getInstance].mKunanceUserHomes updateExistingHomeInfo:aHomeInfo])
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utilities showAlertWithTitle:@"Error" andMessage:@"Unable to update home info"];
        }
    }
}

#pragma mark actions gestures
-(IBAction)dashButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

-(IBAction)showHomePaymentsButtonTapped:(id)sender
{
    [self uploadHomeInfo];
}

-(IBAction) enterHomeAddressButtonTapped
{
//    self.mHomeAddressView = [[HomeAddressViewController alloc] init];
//    self.mHomeAddressView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    self.mHomeAddressView.mHomeAddressViewDelegate = self;
//    if(self.mCorrespondingHomeInfo.mHomeAddress)
//    {
//        self.mHomeAddressView.mCorrespondingHomeInfo = self.mCorrespondingHomeInfo.mHomeAddress;
//    }

    self.googlePlacesViewController = [[SPGooglePlacesAutocompleteViewController alloc] init];
    {
        NSString* address = [NSString stringWithFormat:@"%@, %@, %@",
                             self.mHomeStreetAddress,
                             self.mHomeCity,
                             self.mHomeState];
        
        self.googlePlacesViewController.searchDisplayController.searchBar.text = address;
    }
    self.googlePlacesViewController.placemarkDelegate = self;
    [self.navigationController presentViewController:self.googlePlacesViewController animated:NO completion:nil];
}

-(IBAction)sfhButtonTapped:(id)sender
{
    [self selectSingleFamilyHome];
}

-(IBAction) condoButtonTapped:(id)sender
{
    [self selectCondominuim];
}

-(IBAction)loanInfoButtonTapped:(id)sender
{
    [self uploadHomeInfo];
}

-(IBAction)helpButtonTapped:(id)sender
{
    HelpHomeViewController* hPV = [[HelpHomeViewController alloc] init];
    [self.navigationController pushViewController:hPV animated:NO];
}
#pragma mark end

#pragma mark GooglePlacesDelegate
-(void) addressSelected:(CLPlacemark *)placemark
{
    if(placemark)
    {
        NSLog(@"address: %@", placemark.addressDictionary);
        self.mHomeStreetAddress = placemark.addressDictionary[@"Street"];
        if([self.mHomeStreetAddress isEqual:[NSNull null]])
            self.mHomeStreetAddress = nil;
        
        self.mHomeCity = placemark.addressDictionary[@"City"];
        if([self.mHomeCity isEqual:[NSNull null]])
            self.mHomeCity = nil;
        
        self.mHomeState = placemark.addressDictionary[@"State"];
        if([self.mHomeState isEqual:[NSNull null]])
            self.mHomeState = nil;
        
        self.mHomeZip = placemark.addressDictionary[@"ZIP"];
        if([self.mHomeZip isEqual:[NSNull null]])
            self.mHomeZip = nil;
        
        
        NSString* address = [NSString stringWithFormat:@"%@, %@, %@",
                             self.mHomeStreetAddress,
                             self.mHomeCity,
                             self.mHomeState];
        [self.mHomeAddressButton setTitle:address forState:UIControlStateNormal];

    }
    
    [self.googlePlacesViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma end

#pragma mark HomeAddressViewDelegate
-(void) popHomeAddressFromHomeInfo
{
    if(self.mHomeAddressView.mStreetAddress.text && (self.mHomeAddressView.mStreetAddress.text.length > 0))
    {
        self.mHomeStreetAddress = self.mHomeAddressView.mStreetAddress.text;
    }
    
    if(self.mHomeAddressView.mCity.text && (self.mHomeAddressView.mCity.text.length > 0))
    {
        self.mHomeCity = [self.mHomeAddressView.mCity.text uppercaseString];
    }

    if(self.mHomeAddressView.mState.text && (self.mHomeAddressView.mState.text.length > 0))
    {
        self.mHomeState = self.mHomeAddressView.mState.text;
    }

    [self.mHomeAddressView dismissViewControllerAnimated:YES completion:nil];
}
#pragma end

#pragma mark APIHomeInfoServiceDelegate
-(void) finishedWritingHomeInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [[kunanceUser getInstance] updateStatusWithHomeInfoStatus];
    if(!self.mLoanInfoViewAsButton.hidden)
    {
        if(!self.mLoanInfoController)
            self.mLoanInfoController = [[LoanInfoViewController alloc]
                                        initFromHomeInfoEntry:[NSNumber numberWithInt:self.mHomeNumber]];
        self.mLoanInfoController.mLoanInfoViewDelegate = self;
        
        [self.navigationController pushViewController:self.mLoanInfoController animated:NO];
    }
    else if(!self.mHomeAddressButton.hidden)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayHomeDashNotification object:[NSNumber numberWithInt:self.mHomeNumber]];
    }
}
#pragma end

#pragma mark LoanInfoDelegate
-(void) backToHomeInfo
{
    if(self.mLoanInfoController)
        [self.navigationController popViewControllerAnimated:NO];
}

#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
