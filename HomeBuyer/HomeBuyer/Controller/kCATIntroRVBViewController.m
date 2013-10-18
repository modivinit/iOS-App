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
    backImage.image = [UIImage imageNamed:@"home-interior_04.jpg"];
    [self.view addSubview:backImage];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(160, 70, 250, 70)];
    label.center = CGPointMake(self.view.center.x, label.center.y);
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Share with family.\nConnect with realtors.";
    label.font = [UIFont fontWithName:@"cocon" size:16];
    label.textColor = [UIColor colorWithRed:15/255.0 green:125/255.0 blue:255/255.0 alpha:1.0];
    [self.view addSubview:label];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
