//
//  kCATIntroViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroViewController.h"

@interface kCATIntroViewController ()

@end

@implementation kCATIntroViewController

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
    self.mPageViewControllers = [[NSMutableArray alloc] init];
    
    UIViewController* viewController1 = [[UIViewController alloc] initWithNibName:@"kcatintro"
                                                                           bundle:nil];
    [self.mPageViewControllers addObject:viewController1];
    
    viewController1 = [[UIViewController alloc] initWithNibName:@"kcatintro-lifestyle"
                                                         bundle:nil];
    [self.mPageViewControllers addObject: viewController1];
    

    viewController1 = [[UIViewController alloc] initWithNibName:@"kcatintro-rvb"
                                                         bundle:nil];
    [self.mPageViewControllers addObject: viewController1];

    viewController1 = [[UIViewController alloc] initWithNibName:@"kcatintro-tax"
                                                         bundle:nil];
    [self.mPageViewControllers addObject: viewController1];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
