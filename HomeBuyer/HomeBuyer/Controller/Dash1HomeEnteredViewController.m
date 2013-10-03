//
//  Dash1HomeEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "Dash1HomeEnteredViewController.h"

@interface Dash1HomeEnteredViewController ()

@end

@implementation Dash1HomeEnteredViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"Dash1HomeEnteredViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer* addAHomeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAHome)];
    [self.mAddAHomeButtonAsView addGestureRecognizer:addAHomeTapGesture];
}

#pragma HomeInfoViewDelegate
-(void) calculateAndCompareHomes
{
    if(self.mDash1HomEnteredDelegate && [self.mDash1HomEnteredDelegate respondsToSelector:@selector(calculateAndCompareHomes)])
    {
        [self.mDash1HomEnteredDelegate calculateAndCompareHomes];
    }
}
#pragma end

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
