//
//  OneHomeTaxSavingsViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeTaxSavingsViewController.h"

@interface HomeTaxSavingsViewController ()

@end

@implementation HomeTaxSavingsViewController

-(void) viewWillAppear:(BOOL)animated
{
    [self.mHomeTaxSavingsDelegate setNavTitle:@"Estimated Tax Savings"];
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
