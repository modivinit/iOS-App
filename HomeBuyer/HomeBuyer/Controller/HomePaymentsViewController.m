//
//  OneHomePaymentsViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomePaymentsViewController.h"

@interface HomePaymentsViewController ()

@end

@implementation HomePaymentsViewController

-(void) viewWillAppear:(BOOL)animated
{
    [self.mHomePaymentsDelegate setNavTitle:@"Home Payments"];
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
