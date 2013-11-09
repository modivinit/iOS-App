//
//  DashTwoHomesEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashTwoHomesEnteredViewController.h"
#import "HelpDashboardViewController.h"
#import "ContactRealtorViewController.h"

@interface DashTwoHomesEnteredViewController ()
{
    TwoHomeLifestyleIncomeViewController* lifestyleViewController;
    TwoHomeTaxSavingsViewController* taxSavingsViewController;
    TwoHomePaymentViewController* paymentViewController;
    UIViewController* mCurrentViewController;
}
@end

@implementation DashTwoHomesEnteredViewController

-(void) addButtons
{
    self.mRentalButton = [[UIButton alloc] initWithFrame:CGRectMake(49, 360, 104, 30)];
    self.mRentalButton.backgroundColor = [UIColor clearColor];
    [self.mRentalButton addTarget:self
                          action:@selector(rentalButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mRentalButton];

    self.mHome1Button = [[UIButton alloc] initWithFrame:CGRectMake(49, 400, 104, 30)];
    self.mHome1Button.backgroundColor = [UIColor clearColor];
    [self.mHome1Button addTarget:self
                          action:@selector(home1ButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mHome1Button];

    self.mHome2Button = [[UIButton alloc] initWithFrame:CGRectMake(49, 447, 104, 30)];
    self.mHome2Button.backgroundColor = [UIColor clearColor];
    [self.mHome2Button addTarget:self
                          action:@selector(home2ButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mHome2Button];

    
    self.mHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(274, 520, 44, 44)];
    [self.mHelpButton setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
    [self.mHelpButton addTarget:self action:@selector(helpButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mHelpButton];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                  target:self
                                                  action:@selector(shareGraph)];
    
}

-(void) addPages
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];
    
    lifestyleViewController = [[TwoHomeLifestyleIncomeViewController alloc] init];
    lifestyleViewController.mTwoHomeLifestyleDelegate = self;
    [self.mPageViewControllers addObject:lifestyleViewController];
    
    taxSavingsViewController = [[TwoHomeTaxSavingsViewController alloc] init];
    taxSavingsViewController.mTwoHomeTaxSavingsDelegate = self;
    [self.mPageViewControllers addObject:taxSavingsViewController];
    
    paymentViewController = [[TwoHomePaymentViewController alloc] init];
    paymentViewController.mTwoHomePaymentDelegate = self;
    [self.mPageViewControllers addObject:paymentViewController];
    
    if([kunanceUser getInstance].mRealtor && [kunanceUser getInstance].mRealtor.mIsValid)
    {
        ContactRealtorViewController* contactRealtor = [[ContactRealtorViewController alloc] init];
        contactRealtor.mContactRealtorDelegate = self;
        [self.mPageViewControllers addObject:contactRealtor];
    }
    
    [[self.pageController view] setFrame:[[self view] bounds]];

}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        mCurrentViewController = [pageViewController.viewControllers lastObject];
    }
}

- (void)viewDidLoad
{
    [self addPages];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *revealImagePortrait = [UIImage imageNamed:@"MenuIcon.png"];
    
    if ([self.navigationController.revealController hasLeftViewController])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImagePortrait
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView)];
    }
    
    [self addButtons];
    self.pageController.delegate = self;

    mCurrentViewController = lifestyleViewController;
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed 2-home dashboard" properties:Nil];
}

-(void)shareGraph
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *emailDialog = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [emailDialog setMailComposeDelegate:self];
        
        NSMutableString *htmlMsg = [NSMutableString string];
        [htmlMsg appendString:@"<html><body><p>"];
        [htmlMsg appendString:@"I compared a couple of homes we were interested in using Kunance. Here are the results."];
        [htmlMsg appendString:@"</p></body></html>"];
        
        if(mCurrentViewController == taxSavingsViewController)
        {
            UIImage *taxChartImage = [taxSavingsViewController snapshotWithOpenGLViews];
            NSData *taxJpegData = UIImagePNGRepresentation(taxChartImage);
            NSString *taxFileName = @"HomesTax";
            taxFileName = [taxFileName stringByAppendingPathExtension:@"png"];
            [emailDialog addAttachmentData:taxJpegData mimeType:@"image/png" fileName:taxFileName];
        }
        else if (mCurrentViewController == paymentViewController)
        {
             UIImage *paymentChartImage = [paymentViewController snapshotWithOpenGLViews];
             NSData *paymentJpegData = UIImageJPEGRepresentation(paymentChartImage, 1);
             NSString *paymentFileName = @"HomesPayment";
             paymentFileName = [paymentFileName stringByAppendingPathExtension:@"jpeg"];
             [emailDialog addAttachmentData:paymentJpegData
                            mimeType:@"image/jpeg" fileName:paymentFileName];
        }
        else if(mCurrentViewController == lifestyleViewController)
        {
            UIImage *lifestyleChartImage = [lifestyleViewController snapshotWithOpenGLViews];
            NSData *lifestyleJpegData = UIImageJPEGRepresentation(lifestyleChartImage, 1);
            NSString *lifestyleFileName = @"HomesLifestyle";
            lifestyleFileName = [lifestyleFileName stringByAppendingPathExtension:@"jpeg"];
            [emailDialog addAttachmentData:lifestyleJpegData
                                  mimeType:@"image/jpeg" fileName:lifestyleFileName];
        }

        [emailDialog setSubject:@"Homes Comparision"];
        [emailDialog setMessageBody:htmlMsg isHTML:YES];
        [self.navigationController presentViewController:emailDialog animated:NO completion:nil];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) rentalButtonTapped:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayUserDash object:Nil];
}

-(void) home1ButtonTapped:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHomeButtonTappedFromDash
                                                        object:[NSNumber numberWithInt:FIRST_HOME]];
}

-(void) home2ButtonTapped:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHomeButtonTappedFromDash
                                                        object:[NSNumber numberWithInt:SECOND_HOME]];
}

-(void) helpButtonTapped
{
    HelpDashboardViewController* dashHelp = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:dashHelp animated:NO];
}

-(void) setNavTitle:(NSString *)title
{
    if(title)
        self.navigationItem.title = title;
}

-(void)contactRealtor
{
    ContactRealtorViewController* contactRealtor = [[ContactRealtorViewController alloc] init];
    [self.navigationController pushViewController:contactRealtor animated:NO];
}

-(void) hideLeftView
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController
         showViewController:self.navigationController.revealController.frontViewController];
    }
}

-(void)showLeftView
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController
         showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController
         showViewController:self.navigationController.revealController.leftViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
