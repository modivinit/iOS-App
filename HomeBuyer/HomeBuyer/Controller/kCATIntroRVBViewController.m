//
//  kCATIntroRVBViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroRVBViewController.h"

@interface kCATIntroRVBViewController ()

@end

@implementation kCATIntroRVBViewController

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
    backImage.image = [UIImage imageNamed:@"home-interior_041.jpg"];
    [self.view addSubview:backImage];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, 250, 90)];
    label.center = CGPointMake(self.view.center.x, label.center.y);
    label.numberOfLines = 4;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Share results with family.\n\nConnect with realtors when you are ready.";
    label.font = [UIFont fontWithName:@"cocon" size:16];
    label.textColor = [Utilities getKunanceBlueColor];
    [self.view addSubview:label];

    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Looked at FTUE Screen 1 - Connect and Share" properties:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
