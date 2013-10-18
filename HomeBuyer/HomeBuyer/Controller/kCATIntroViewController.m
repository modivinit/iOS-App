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

-(void) addButtons
{
    self.mSignInButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 520, 60, 44)];
    [self.mSignInButton setBackgroundColor:[UIColor clearColor]];
    [self.mSignInButton addTarget:self action:@selector(signInButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.mSignInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    self.mSignInButton.titleLabel.font = [UIFont fontWithName:@"cocon" size:14];
    self.mSignInButton.titleLabel.textColor =
    [UIColor colorWithRed:15/255.0 green:125/255.0 blue:255/255.0 alpha:1.0];
    [self.pageController.view addSubview:self.mSignInButton];
    
    self.mSignUpButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 520, 100, 44)];
    [self.mSignUpButton setBackgroundColor:[UIColor clearColor]];
    [self.mSignUpButton addTarget:self action:@selector(signUpButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.mSignUpButton setTitle:@"Create Account" forState:UIControlStateNormal];
    self.mSignUpButton.titleLabel.font = [UIFont fontWithName:@"cocon" size:14];
    self.mSignUpButton.titleLabel.textColor =
    [UIColor colorWithRed:15/255.0 green:125/255.0 blue:255/255.0 alpha:1.0];
    [self.pageController.view addSubview:self.mSignInButton];

    [self.pageController.view addSubview:self.mSignUpButton];

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

    self.mBackground = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.mBackground.image = [UIImage imageNamed:@"home-interior_01.jpg"];
    [self.view addSubview:self.mBackground];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pageController.delegate = self;
    
    [[self.pageController view] setFrame:[[self view] bounds]];
    self.pageController.view.backgroundColor = [UIColor clearColor];

    [self.view setBackgroundColor:[UIColor clearColor]];
    [self addButtons];
    
}

#pragma mark UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    NSString* imageName = [NSString stringWithFormat:@"home-interior_0%d.jpg", ((UIViewController*)pendingViewControllers[0]).view.tag+1];
    NSLog(@"willTransitionToViewControllers %@", imageName);
    self.mBackground.image = [UIImage imageNamed:imageName];
}
#pragma end

-(void)signInButtonTapped:(id)sender
{
    [self.mkCATIntroDelegate signInFromIntro];
}

-(void)signUpButtonTapped:(id)sender
{
    [self.mkCATIntroDelegate signupFromIntro];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
