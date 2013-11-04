//
//  HelpDashboardViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 9/25/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HelpDashboardViewController.h"

@interface HelpDashboardViewController ()

@end

@implementation HelpDashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction) dashboard:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Entered Dashboard Help Screen" properties:Nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
