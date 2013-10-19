//
//  HelpHomeViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/25/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HelpHomeViewController.h"

@interface HelpHomeViewController ()

@end

@implementation HelpHomeViewController

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
-(IBAction)dashButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

-(IBAction)helpButtonTapped:(id)sender
{
    [self removeFromParentViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
