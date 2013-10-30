//
//  TermsAndPoliciesViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/9/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TermsAndPoliciesViewController.h"

@interface TermsAndPoliciesViewController ()

@end

@implementation TermsAndPoliciesViewController

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
    [self.mSegmentedControl addTarget:self
                         action:@selector(segmentedControlSelectionChanged)
               forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.title = @"Terms And Policies";

    [self switchView];
}

-(void) switchView
{
    if(self.mSegmentedControl.selectedSegmentIndex == 0)
    {
        self.mPrivacyPolicyView.hidden = YES;
        self.mTermsOfUserView.hidden = NO;
    }
    else
    {
        self.mPrivacyPolicyView.hidden = NO;
        self.mTermsOfUserView.hidden = YES;
    }
}

-(IBAction)dashboardButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
}

-(void) segmentedControlSelectionChanged
{
    [self switchView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
