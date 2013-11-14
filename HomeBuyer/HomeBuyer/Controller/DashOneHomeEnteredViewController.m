//
//  DashOneHomeEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashOneHomeEnteredViewController.h"
#import "HelpDashboardViewController.h"
#import "ContactRealtorViewController.h"

@interface DashOneHomeEnteredViewController ()
{
    OneHomeLifestyleViewController* lifestyleCOntroller;
    OneHomeTaxSavingsViewController* taxsavingsController;
    OneHomePaymentViewController* paymentController;
    UIViewController* currentViewcontroller;
}
@end

@implementation DashOneHomeEnteredViewController

-(void) addPages
{
    self.mPageViewControllers = [[NSMutableArray alloc] init];
    
    lifestyleCOntroller = [[OneHomeLifestyleViewController alloc] init];
    lifestyleCOntroller.mOneHomeLifestyleViewDelegate = self;
    [self.mPageViewControllers addObject:lifestyleCOntroller];
    
    taxsavingsController = [[OneHomeTaxSavingsViewController alloc] init];
    taxsavingsController.mOneHomeTaxSavingsDelegate = self;
    [self.mPageViewControllers addObject: taxsavingsController];
    
     paymentController = [[OneHomePaymentViewController alloc] init];
    paymentController.mOneHomePaymentViewDelegate = self;
    [self.mPageViewControllers addObject:paymentController];
}

-(void) addButtons
{
    self.mRentalButton = [[UIButton alloc] initWithFrame:CGRectMake(49, 363, 104, 30)];
    self.mRentalButton.backgroundColor = [UIColor clearColor];
    [self.mRentalButton addTarget:self
                           action:@selector(rentalButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mRentalButton];
    
    self.mHome1Button = [[UIButton alloc] initWithFrame:CGRectMake(49, 405, 104, 30)];
    self.mHome1Button.backgroundColor = [UIColor clearColor];
    [self.mHome1Button addTarget:self
                          action:@selector(home1ButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.pageController.view addSubview:self.mHome1Button];

    self.mContactRealtorIconButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 470, 25, 25)];
    self.mContactRealtorButton = [[UIButton alloc] initWithFrame:CGRectMake(52, 463, 160, 44)];

    if([kunanceUser getInstance].mRealtor.mIsValid)
    {
        if([kunanceUser getInstance].mRealtor.mSmallLogo)
            [self.mContactRealtorIconButton setImage:[kunanceUser getInstance].mRealtor.mSmallLogo
                                            forState:UIControlStateNormal];
        
        if([kunanceUser getInstance].mRealtor.mFirstName)
        {
            [self.mContactRealtorButton setTitle:[NSString stringWithFormat:@"Contact %@", [kunanceUser getInstance].mRealtor.mFirstName]
                                        forState:UIControlStateNormal];
        }
        else
        {
            [self.mContactRealtorButton setTitle:@"Contact Realtor" forState:UIControlStateNormal];
        }
        
        self.mContactRealtorButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
        [self.mContactRealtorButton setTitleColor:[Utilities getKunanceBlueColor] forState:UIControlStateNormal] ;
        self.mContactRealtorButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self.mContactRealtorIconButton addTarget:self action:@selector(contactRealtor) forControlEvents:UIControlEventTouchUpInside];
        [self.pageController.view addSubview:self.mContactRealtorIconButton];

        [self.mContactRealtorButton addTarget:self action:@selector(contactRealtor) forControlEvents:UIControlEventTouchUpInside];
        [self.pageController.view addSubview:self.mContactRealtorButton];
        
    }

    self.mHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(274, 520, 44, 44)];
    [self.mHelpButton setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
    [self.mHelpButton addTarget:self action:@selector(helpButtonTapped)
               forControlEvents:UIControlEventTouchUpInside];

    [self.pageController.view addSubview:self.mHelpButton];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                  target:self
                                                  action:@selector(shareGraph)];

}

-(void)shareGraph
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *emailDialog = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [emailDialog setMailComposeDelegate:self];
        
        NSMutableString *htmlMsg = [NSMutableString string];
        [htmlMsg appendString:@"<html><body><p>"];
        [htmlMsg appendString:@"I compared a home we were interested in using Kunance. Here are the results."];
        [htmlMsg appendString:@"</p></body></html>"];
        
        if(currentViewcontroller == taxsavingsController)
        {
            UIImage *taxChartImage = [taxsavingsController snapshotWithOpenGLViews];
            NSData *taxJpegData = UIImagePNGRepresentation(taxChartImage);
            NSString *taxFileName = @"HomesTax";
            taxFileName = [taxFileName stringByAppendingPathExtension:@"png"];
            [emailDialog addAttachmentData:taxJpegData mimeType:@"image/png" fileName:taxFileName];
        }
        else if (currentViewcontroller == paymentController)
        {
            UIImage *paymentChartImage = [paymentController snapshotWithOpenGLViews];
            NSData *paymentJpegData = UIImageJPEGRepresentation(paymentChartImage, 1);
            NSString *paymentFileName = @"HomesPayment";
            paymentFileName = [paymentFileName stringByAppendingPathExtension:@"jpeg"];
            [emailDialog addAttachmentData:paymentJpegData
                                  mimeType:@"image/jpeg" fileName:paymentFileName];
        }
        else if(currentViewcontroller == lifestyleCOntroller)
        {
            UIImage *lifestyleChartImage = [lifestyleCOntroller snapshotWithOpenGLViews];
            NSData *lifestyleJpegData = UIImageJPEGRepresentation(lifestyleChartImage, 1);
            NSString *lifestyleFileName = @"HomesLifestyle";
            lifestyleFileName = [lifestyleFileName stringByAppendingPathExtension:@"jpeg"];
            [emailDialog addAttachmentData:lifestyleJpegData
                                  mimeType:@"image/jpeg" fileName:lifestyleFileName];
        }
        
        [emailDialog setSubject:@"Home Comparison"];
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

- (void)viewDidLoad
{
    [self addPages];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *revealImagePortrait = [UIImage imageNamed:@"MenuIcon.png"];
    
    if ([self.navigationController.revealController hasLeftViewController])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImagePortrait
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView)];
    }

    CGRect pageBound = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,
                                  self.view.bounds.size.width, self.view.bounds.size.height);
    self.pageController.view.frame = pageBound;
    self.pageController.view.backgroundColor = [UIColor clearColor];
    
    [self addButtons];
    self.pageController.delegate = self;
    
    currentViewcontroller = lifestyleCOntroller;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed 1-home dashboard" properties:Nil];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        currentViewcontroller = [pageViewController.viewControllers lastObject];
    }
}

-(void) setNavTitle:(NSString *)title
{
    if(title)
        self.navigationItem.title = title;
}

-(void) helpButtonTapped
{
    HelpDashboardViewController* dashHelp = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:dashHelp animated:NO];
}

-(void)contactRealtor
{
    ContactRealtorViewController* contactRealtor = [[ContactRealtorViewController alloc] init];
    contactRealtor.showDashboardIcon = YES;
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
