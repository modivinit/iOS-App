//
//  ContactRealtorViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/9/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "ContactRealtorViewController.h"

@interface ContactRealtorViewController ()

@end

@implementation ContactRealtorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)showDash:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
