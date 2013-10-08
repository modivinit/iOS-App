//
//  Dash1HomeEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "RentVsBuyDashViewController.h"

@interface RentVsBuyDashViewController ()

@end

@implementation RentVsBuyDashViewController

-(void) viewWillAppear:(BOOL)animated
{
    [self.mRentVsBuyDashViewDelegate setNavTitle:@"Rent vs Buy"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer* addAHomeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAHome)];
    [self.mAddAHomeButtonAsView addGestureRecognizer:addAHomeTapGesture];
}

#pragma mark actions, gesture etc
-(void) addAHome
{
    self.mHomeInfoViewController = [[HomeInfoViewController alloc] initAsHomeNumber:SECOND_HOME];
    self.mHomeInfoViewController.mHomeInfoViewDelegate = self;
    [self.navigationController pushViewController:self.mHomeInfoViewController animated:NO];
}
#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
