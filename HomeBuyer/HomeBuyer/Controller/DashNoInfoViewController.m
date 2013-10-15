//
//  DashNoInfoViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashNoInfoViewController.h"

@interface DashNoInfoViewController ()

@end

@implementation DashNoInfoViewController

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
    UITapGestureRecognizer* tapAboutYou = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(aboutYouTapped)];
   
     [self.mCompositeAboutYouButton addGestureRecognizer:tapAboutYou];
   
     NSString* userName = (([kunanceUser getInstance].mLoggedInKunanceUser.firstName)?
                                                 [NSString stringWithFormat:@" %@!",
                                                  [kunanceUser getInstance].mLoggedInKunanceUser.firstName] :
                                                 [NSString stringWithFormat:@"!"]);
     
     NSString* titleText = [NSString stringWithFormat:@"Welcome %@", userName];
     self.navigationController.navigationBar.topItem.title = titleText;
}

#pragma mark target action functions geature recognizers
-(void) aboutYouTapped
{
     self.mAboutYouViewController = [[AboutYouViewController alloc] init];
     [self.navigationController pushViewController:self.mAboutYouViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
