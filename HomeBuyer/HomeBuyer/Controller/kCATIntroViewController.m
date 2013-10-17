//
//  kCATIntroViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroViewController.h"
#import "kCATIntroAffordViewController.h"
#import "kCATIntroLifestyleViewController.h"
#import "kCATIntroRVBViewController.h"
#import "kCATIntroTaxViewController.h"

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
    
    UIViewController* viewController1 = [[kCATIntroAffordViewController alloc] init];
    [self.mPageViewControllers addObject:viewController1];
    
    viewController1 = [[kCATIntroLifestyleViewController alloc] init];
    [self.mPageViewControllers addObject:viewController1];
    
    viewController1 = [[kCATIntroTaxViewController alloc] init];
    [self.mPageViewControllers addObject:viewController1];
    
    viewController1 = [[kCATIntroRVBViewController alloc] init];
    [self.mPageViewControllers addObject:viewController1];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect pageBound = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,
                                  self.view.bounds.size.width, self.view.bounds.size.height);
    self.pageController.view.frame = pageBound;
    self.pageController.view.backgroundColor = [UIColor clearColor];

}

-(IBAction)signInButtonTapped:(id)sender
{
    [self.mkCATIntroDelegate signInFromIntro];
}

-(IBAction)signUpButtonTapped:(id)sender
{
    [self.mkCATIntroDelegate signupFromIntro];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
