//
//  kCATIntroAffordViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroAffordViewController.h"

@interface kCATIntroAffordViewController ()

@end

@implementation kCATIntroAffordViewController

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
    UIImageView* backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageNamed:@"home-interior_01.jpg"];
    [self.view addSubview:backImage];
    
    UIImageView* appName = [[UIImageView alloc] initWithFrame:CGRectMake(160, 46, 150, 53)];
    appName.center = CGPointMake(self.view.center.x, appName.center.y);
    appName.image = [UIImage imageNamed:@"appname.png"];
    [self.view addSubview:appName];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(160, 151, 237, 40)];
    label.center = CGPointMake(self.view.center.x, label.center.y);
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Turning first time homebuyers into pros.";
    label.font = [UIFont fontWithName:@"cocon" size:16];
    label.textColor = [Utilities getKunanceBlueColor];
    [self.view addSubview:label];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Looked at FTUE Screen 1 - Intro" properties:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
