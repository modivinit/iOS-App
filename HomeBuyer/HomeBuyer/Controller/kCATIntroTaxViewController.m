//
//  kCATIntroTaxViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroTaxViewController.h"

@interface kCATIntroTaxViewController ()

@end

@implementation kCATIntroTaxViewController

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
    backImage.image = [UIImage imageNamed:@"home-interior_03.jpg"];
    [self.view addSubview:backImage];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(160, 70, 250, 70)];
    label.center = CGPointMake(self.view.center.x, label.center.y);
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Compare income tax savings across homes before you buy.";
    label.font = [UIFont fontWithName:@"cocon" size:16];
    label.textColor = [Utilities getKunanceBlueColor];
    [self.view addSubview:label];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
