//
//  MainController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/27/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "MainController.h"
#import "LoginViewController.h"
#import "LeftMenuViewController.h"
#import <PKRevealController/PKRevealController.h>
#import "DashNoInfoViewController.h"
#import "AppDelegate.h"
#import "HomeInfoDashViewController.h"
#import "TermsAndPoliciesViewController.h"
#import "ContactRealtorViewController.h"

@interface MainController ()
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@property (nonatomic, strong) kCATIntroViewController* mIntroView;
@end

@implementation MainController

-(id) initWithNavController:(UINavigationController*) navController
{
    self = [super init];
    
    if(self)
    {
        self.mMainNavController = navController;
        self.mLeftMenuViewController = [[LeftMenuViewController alloc] init];
        self.mLeftMenuViewController.mLeftMenuDelegate = self;
    }
    
    return self;
}

-(void) start
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayDash)
                                                 name:kDisplayMainDashNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayHomeDash:)
                                                 name:kDisplayHomeDashNotification
                                               object:nil];

    //if logged in,
    if([[kunanceUser getInstance] isUserLoggedIn])
    {
        //then go to the dashboard
    }
    else  //If not logged in
    {
        //check to see if there is a user account on keychain
        if([[kunanceUser getInstance] userAccountFoundOnDevice])
        {
            //then login
            [self loginSavedUser];
        }
        else //If there is no user account
        {
            //then show the signup view
            [self showIntroScreens];
        }
    }
}

-(void) loginSavedUser
{
    if([[kunanceUser getInstance] loginSavedUser])
    {
        [self readUserPFInfo];
    }
    else
    {
        [self presentLoginViewController];
    }
}

-(void) readUserPFInfo
{
    if(![kunanceUser getInstance].mkunanceUserProfileInfo)
        [kunanceUser getInstance].mkunanceUserProfileInfo = [[userProfileInfo alloc] init];
   
    if([kunanceUser getInstance].mkunanceUserProfileInfo)
    {
        [kunanceUser getInstance].mkunanceUserProfileInfo.mUserProfileInfoDelegate = self;
        [[kunanceUser getInstance].mkunanceUserProfileInfo readUserPFInfo];
    }
}

-(void) logUserOut
{
    [[kunanceUser getInstance] logoutUser];
    [self showIntroScreens];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"User Logged Out" properties:Nil];
}

-(void)displayHomeDash:(NSNotification*) notice
{
    if(notice)
    {
        NSNumber* homeNumber = (NSNumber*) notice.object;
        HomeInfoDashViewController* homeInfoDash = [[HomeInfoDashViewController alloc] initWithHomeNumber:homeNumber];
        [self setRootView:homeInfoDash];
    }
}

-(void) showIntroScreens
{
    self.mIntroView = [[kCATIntroViewController alloc] init];
    self.mIntroView.mkCATIntroDelegate = self;
    
    if(self.mMainControllerDelegate &&
      [self.mMainControllerDelegate respondsToSelector:@selector(resetRootView:)])
    {
       [self.mMainControllerDelegate resetRootView:self.mIntroView];
    }
}

-(void) setRootView:(UIViewController*) viewController
{
    self.mFrontViewController = [[UINavigationController alloc]
                                 initWithRootViewController:viewController];
    
    //self.mFrontViewController.navigationBar.tintColor = [UIColor grayColor];
    self.revealController = [PKRevealController revealControllerWithFrontViewController:self.mFrontViewController
                                                                     leftViewController:self.mLeftMenuViewController];
    if(self.mMainControllerDelegate &&
       [self.mMainControllerDelegate respondsToSelector:@selector(resetRootView:)])
    {
        [self.mMainControllerDelegate resetRootView:self.revealController];
    }
}

-(void) presentLoginViewController
{
    LoginViewController* loginViewController = [[LoginViewController alloc] init];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    loginViewController.mLoginDelegate = self;
    
    if(self.mMainControllerDelegate &&
       [self.mMainControllerDelegate respondsToSelector:@selector(resetRootView:)])
    {
        [self.mMainControllerDelegate resetRootView:navController];
    }
}

-(void) presentSignupViewController
{
    self.mSignUpViewController = [[SignUpViewController alloc] init];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:self.mSignUpViewController];

    self.mSignUpViewController.mSignUpDelegate = self;
    if(self.mMainControllerDelegate &&
       [self.mMainControllerDelegate respondsToSelector:@selector(resetRootView:)])
    {
        [self.mMainControllerDelegate resetRootView:navController];
    }
}

#pragma mark kCATIntroDelegate
-(void) signInFromIntro
{
    [self presentLoginViewController];
}

-(void) signupFromIntro
{
    [self presentSignupViewController];
}
#pragma end

#pragma mark FixedCostsControllerDelegate
-(void) aboutYouFromFixedCosts
{
    AboutYouViewController* aboutYouViewController = [[AboutYouViewController alloc] init];
    [self setRootView:aboutYouViewController];
}
#pragma end

#pragma mark DashNoInfoViewDelegate
#pragma mark DashUserPFInfoDelegate
#pragma mark Dash1HomeEnteredViewDelegate
-(void) displayDash
{
    NSLog(@"ProfileStatus = %d", [kunanceUser getInstance].mUserProfileStatus);
    switch ([kunanceUser getInstance].mUserProfileStatus)
    {
        case ProfileStatusUndefined:
        case ProfileStatusUserPersonalFinanceInfoEntered:
            self.mMainDashController = [[DashNoInfoViewController alloc] init];
            break;
            
        case ProfileStatusPersonalFinanceAndFixedCostsInfoEntered:
        case ProfileStatusUser1HomeInfoEntered:
            self.mMainDashController = [[DashUserPFInfoViewController alloc] init];
            break;
            
        case ProfileStatusUser1HomeAndLoanInfoEntered:
            self.mMainDashController = [[DashOneHomeEnteredViewController alloc] init];
            break;
            
        case ProfileStatusUserTwoHomesAndLoanInfoEntered:
            self.mMainDashController = [[DashTwoHomesEnteredViewController alloc] init];
            break;
            
        default:
            break;
    }
    
    [self setRootView:self.mMainDashController];
}
#pragma end

#pragma mark LoginDelegate
-(void) loggedInUserSuccessfully
{
    [self readUserPFInfo];
}

-(void) cancelLoginScreen
{
    [self showIntroScreens];
}

-(void) signupButtonPressed
{
    if(self.mLoginViewController)
        [self.mLoginViewController dismissViewControllerAnimated:NO completion:nil];
    
    if(self.mSignUpViewController)
        self.mSignUpViewController = nil;
    
    [self presentSignupViewController];
}
#pragma end

#pragma mark SignUpDelegate
-(void) userSignedUpSuccessfully
{
    //Display the dashboard
    [self displayDash];
}

-(void) cancelSignUpScreen
{
    [self showIntroScreens];
}

-(void) loadSignInClicked
{
    if(self.mSignUpViewController)
        [self.mSignUpViewController dismissViewControllerAnimated:NO completion:nil];
    
    if(self.mLoginViewController)
        self.mLoginViewController = nil;

    [self presentLoginViewController];
}
#pragma end

#pragma mark APILoanInfoDelegate
-(void) finishedReadingLoanInfo
{
    [[kunanceUser getInstance] updateStatusWithLoanInfoStatus];
    [self displayDash];
}
#pragma end
#pragma mark APIHomeInfoServiceDelegate
-(void) finishedReadingHomeInfo
{
    [[kunanceUser getInstance] updateStatusWithHomeInfoStatus];

    if(![kunanceUser getInstance].mKunanceUserLoans)
        [kunanceUser getInstance].mKunanceUserLoans = [[usersLoansList alloc] init];
    
    [kunanceUser getInstance].mKunanceUserLoans.mLoansListDelegate = self;
    if(![[kunanceUser getInstance].mKunanceUserLoans readLoanInfo])
    {
        [Utilities showAlertWithTitle:@"Error" andMessage:@"Sorry unable to read loan info"];
        return;
    }
}
#pragma end

#pragma mark APIServiceDelegate
-(void) finishedReadingUserPFInfo
{
    [[kunanceUser getInstance] updateStatusWithUserProfileInfo];
    
    if(![kunanceUser getInstance].mKunanceUserHomes)
        [kunanceUser getInstance].mKunanceUserHomes = [[UsersHomesList alloc] init];
    
    [kunanceUser getInstance].mKunanceUserHomes.mUsersHomesListDelegate = self;
    if(![[kunanceUser getInstance].mKunanceUserHomes readHomesInfo])
    {
        NSLog(@"Error: reading homes info for user");
    }
}
#pragma end

-(void) handleUserMenu:(NSInteger) row
{
    switch (row) {
        case ROW_DASHBOARD:
        {
            [self displayDash];
        }
            break;
            
        case ROW_REALTOR:
        {
            ContactRealtorViewController* contactRealtor = [[ContactRealtorViewController alloc] init];
            [self setRootView:contactRealtor];
        }
            break;
            
        default:
            break;
    }
}

-(void) handleHomeMenu:(NSInteger) row
{
    uint currentNumOfHomes = [[kunanceUser getInstance].mKunanceUserHomes getCurrentHomesCount];

    if(row <0 || row >= MAX_NUMBER_OF_HOMES_PER_USER)
    {
        NSLog(@"ROw %d out of bounds", row);
        return;
    }
    
    kunanceUserProfileStatus status = [kunanceUser getInstance].mUserProfileStatus;
    
    if((row == currentNumOfHomes) && currentNumOfHomes < MAX_NUMBER_OF_HOMES_PER_USER)
    {
        HomeInfoEntryViewController* homeInfoViewController =
        [[HomeInfoEntryViewController alloc] initAsHomeNumber:row];
        [self setRootView:homeInfoViewController];
    }
    else if(row < currentNumOfHomes)
    {
        if(status == ProfileStatusUser1HomeAndLoanInfoEntered || status == ProfileStatusUserTwoHomesAndLoanInfoEntered)
        {
            HomeInfoDashViewController* homeDash = [[HomeInfoDashViewController alloc]
                                                    initWithHomeNumber:[NSNumber numberWithInt:row]];
            [self setRootView:homeDash];
        }
        else
        {
            HomeInfoEntryViewController* homeInfoViewController =
            [[HomeInfoEntryViewController alloc] initAsHomeNumber:row];
            [self setRootView:homeInfoViewController];
        }
    }
    else if(row > currentNumOfHomes)
    {
        NSLog(@"Error: Cannot enter 2nd home before first");
        return;
    }
}

-(void) handleLoanMenu:(NSInteger) row
{
   if(row != ROW_LOAN_INFO)
       return;
    
    LoanInfoViewController* loanInfoViewController = [[LoanInfoViewController alloc] init];
    [self setRootView:loanInfoViewController];
}

-(void) handleProfileMenu:(NSInteger) row
{
    switch (row)
    {
        case ROW_YOUR_PROFILE:
        {
            AboutYouViewController* aboutYouViewController = [[AboutYouViewController alloc] init];
            [self setRootView:aboutYouViewController];
        }
            break;
            
        case ROW_FIXED_COSTS:
        {
            FixedCostsViewController* fixedCostsViewController = [[FixedCostsViewController alloc] init];
            fixedCostsViewController.mFixedCostsControllerDelegate = self;
            [self setRootView:fixedCostsViewController];
        }
            break;
            
        case ROW_CURRENT_LIFESTYLE:
        {
            DashUserPFInfoViewController* vc = [[DashUserPFInfoViewController alloc] init];
            vc.mWasLoadedFromMenu = YES;
            self.mMainDashController = vc;
            
            [self setRootView:self.mMainDashController];
        }
    }
}

-(void) handleHelpMenu:(NSInteger) row
{
    switch (row)
    {
        case ROW_HELP_CENTER:
        {
            
        }
            break;
            
        case ROW_TERMS_AND_POLICIES:
        {
            TermsAndPoliciesViewController* termsAndPolicies = [[TermsAndPoliciesViewController alloc] init];
            [self setRootView:termsAndPolicies];
        }
            break;
            
        case ROW_LOGOUT:
        {
            [self logUserOut];
        }
            break;
            
        default:
            break;
    }
}

-(void) hideLeftView
{
    if (self.mFrontViewController.navigationController.revealController.focusedController == self.mFrontViewController.navigationController.revealController.leftViewController)
    {
        [self.mFrontViewController.navigationController.revealController
         showViewController:self.mFrontViewController];
    }
}


#pragma mark LeftMenuDelegate
-(void) showFrontViewForSection:(NSInteger)section andRow:(NSInteger)row
{    
    switch (section)
    {
        case SECTION_USER_NAME_DASH_REALTOR:
        {
            [self handleUserMenu:row];
        }
            break;
            
        case SECTION_HOMES:
        {
            [self handleHomeMenu:row];
        }
            break;
            
        case SECTION_LOAN:
        {
            [self handleLoanMenu:row];
        }
            break;
        
        case SECTION_USER_PROFILE:
        {
            [self handleProfileMenu:row];
        }
            break;
            
        case SECTION_INFO:
        {
            [self handleHelpMenu:row];
        }
            break;
            
        default:
            break;
    }
}

#pragma end
@end
