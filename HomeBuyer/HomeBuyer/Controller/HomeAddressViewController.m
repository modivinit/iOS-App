//
//  HomeAddressViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeAddressViewController.h"
#import "HTAutocompleteManager.h"
#import "Cities.h"
#import "States.h"

@interface HomeAddressViewController ()
@property (nonatomic, strong) NSDictionary* mStatesList;
@property (nonatomic, strong) NSDictionary* mCitiesList;
@end

@implementation HomeAddressViewController

-(IBAction)homeInfoButtonTapped:(id)sender
{
    if(self.mHomeAddressViewDelegate && [self.mHomeAddressViewDelegate respondsToSelector:@selector(popHomeAddressFromHomeInfo)])
    {
        [self.mHomeAddressViewDelegate popHomeAddressFromHomeInfo];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    //TODO: We will need to move htis to a centralized location in the future
}

- (void)viewDidLoad
{
    self.mShowDoneButton = YES;
    self.mFormFields = [[NSArray alloc] initWithObjects:self.mStreetAddress, self.mCity, nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mCity.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    
    if(self.mCorrespondingHomeInfo)
    {
        if(self.mCorrespondingHomeInfo.mStreetAddress)
            self.mStreetAddress.text = self.mCorrespondingHomeInfo.mStreetAddress;
        
        self.mState.text = [States getStateNameForStateCode:self.mCorrespondingHomeInfo.mStateCode];
        
        Cities* cities = [[Cities alloc] initForState:self.mCorrespondingHomeInfo.mStateCode];
        self.mCity.text = [cities getCityNameForCityCode:self.mCorrespondingHomeInfo.mCityCode];
    }
    
    self.navigationItem.title = @"Home Address";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
