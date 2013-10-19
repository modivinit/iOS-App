//
//  DashUserPFInfoViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashUserPFInfoViewController.h"
#import "HelpDashboardViewController.h"

@interface DashUserPFInfoViewController ()

@end

@implementation DashUserPFInfoViewController

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
    NSString* titleText = [NSString stringWithFormat:@"Current Lifestyle Income"];
    self.navigationController.navigationBar.topItem.title = titleText;
    // Do any additional setup after loading the view from its nib.
}


#pragma mark actions, gestures
-(IBAction)helpButtonTapped:(id)sender
{
    HelpDashboardViewController* dashHelp = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:dashHelp animated:NO];
}

-(IBAction)addHomeIcon:(id)sender
{
    [self showHomeInfo];
}

-(IBAction)addHomeInfo:(id)sender
{
    [self showHomeInfo];
}

-(void) showHomeInfo
{
    self.mHomeInfoViewController = [[HomeInfoEntryViewController alloc] initAsHomeNumber:FIRST_HOME];
    [self.navigationController pushViewController:self.mHomeInfoViewController animated:NO];
}
#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
