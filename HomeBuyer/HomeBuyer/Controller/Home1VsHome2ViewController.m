//
//  Dash2HomesEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/3/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "Home1VsHome2ViewController.h"

@interface Home1VsHome2ViewController ()
@end

@implementation Home1VsHome2ViewController

-(void) viewWillAppear:(BOOL)animated
{
    [self.mHomes1VsHome2Delegate setNavTitle:@"First Home Vs Second Home"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
