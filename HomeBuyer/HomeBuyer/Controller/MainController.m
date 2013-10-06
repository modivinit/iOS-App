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
#import "PKRevealController.h"
#import "APIUserInfoService.h"
#import "DashNoInfoViewController.h"
#import "AppDelegate.h"

@interface MainController ()
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@end

@implementation MainController

-(id) initWithNavController:(UINavigationController*) navController
{
    self = [super init];
    
    if(self)
    {
        self.mMainNavController = navController;
        self.mAPIUserInfoService = [[APIUserInfoService alloc] init];
        self.mAPIUserInfoService.mAPIUserInfoServiceDelegate = self;
        self.mLeftMenuViewController = [[LeftMenuViewController alloc] init];
        self.mLeftMenuViewController.mLeftMenuDelegate = self;
    }
    
    return self;
}

-(void) start
{
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
            self.mSignUpViewController = [[SignUpViewController alloc] init];
            self.mSignUpViewController.mSignUpDelegate = self;
            [self.mMainNavController presentViewController:self.mSignUpViewController animated:NO completion:nil];
        }
    }
}

-(void) loginSavedUser
{
    __block NSString* email = nil;
    __block NSString* password = nil;
    
    if([[kunanceUser getInstance] getUserEmail:&email andPassword:&password])
    {
        FatFractal *ff = [AppDelegate ff];
        [ff loginWithUserName:email andPassword:password
                   onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse)
        {
            FFUser *loggedInUser = (FFUser *)obj;
            if(loggedInUser)
            {
                [[kunanceUser getInstance] saveUserInfoAfterLoginSignUp:loggedInUser
                                                               passowrd:password];
                
                [self savedUserLoggedInSuccessfully];
                //[Utilities showAlertWithTitle:@"Success" andMessage:@"Sign Up Successful"];
            }
            else
            {
                [self failedToLoginSavedUser];
            }

        }];
    }
}

-(void) displayDash
{
    switch ([kunanceUser getInstance].mUserProfileStatus)
    {
        case ProfileStatusNoInfoEntered:
        case ProfileStatusUserPersonalFinanceInfoEntered:
            self.mMainDashController = [[DashNoInfoViewController alloc] init];
            ((DashNoInfoViewController*) self.mMainDashController).mDashNoInfoViewDelegate = self;
            break;
            
        case ProfileStatusUserExpensesInfoEntered:
            self.mMainDashController = [[DashUserPFInfoViewController alloc] init];
            ((DashUserPFInfoViewController*) self.mMainDashController).mDashUserPFInfoDelegate = self;
            break;
            
        case ProfileStatusUser1HomeInfoEntered:
        case ProfileStatusUser1HomeAndLoanInfoEntered:
            self.mMainDashController = [[Dash1HomeEnteredViewController alloc] init];
            ((Dash1HomeEnteredViewController*) self.mMainDashController).mDash1HomEnteredDelegate = self;
            break;
            
        case ProfileStatusUserTwoHomesAndLoanInfoEntered:
            self.mMainDashController = [[Dash2HomesEnteredViewController alloc] init];
            //((Dash2HomesEnteredViewController*) self.mMainDashController).mDash1HomEnteredDelegate = self;
            break;
            
        default:
            break;
    }
    
    [self setRootView:self.mMainDashController];
}

-(void) setRootView:(UIViewController*) viewController
{
    self.mFrontViewController = [[UINavigationController alloc]
                                 initWithRootViewController:viewController];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:self.mFrontViewController
                                                                     leftViewController:self.mLeftMenuViewController
                                                                    rightViewController:nil
                                                                                options:nil];
    if(self.mMainControllerDelegate &&
       [self.mMainControllerDelegate respondsToSelector:@selector(resetRootView:)])
    {
        [self.mMainControllerDelegate resetRootView:self.revealController];
    }
}

-(void) readUserPFInfo
{
    if(self.mAPIUserInfoService)
        [self.mAPIUserInfoService readUserPFInfo];
}

-(void) savedUserLoggedInSuccessfully
{
    [self readUserPFInfo];
}

-(void) failedToLoginSavedUser
{
    //show login screen here
    LoginViewController* loginViewController = [[LoginViewController alloc] init];
    loginViewController.mLoginDelegate = self;
    [self.mMainNavController pushViewController:loginViewController animated:YES];
}

#pragma mark LoginDelegate
-(void) loggedInUserSuccessfully
{
    [self readUserPFInfo];
}

-(void) signupButtonPressed
{
    if(self.mLoginViewController)
        [self.mLoginViewController dismissViewControllerAnimated:NO completion:nil];
    
    if(self.mSignUpViewController)
        self.mSignUpViewController = nil;
    
    self.mSignUpViewController = [[SignUpViewController alloc] init];
    self.mSignUpViewController.mSignUpDelegate = self;
    [self.mMainNavController presentViewController:self.mSignUpViewController animated:NO completion:nil];
}
#pragma end

#pragma mark SignUpDelegate
-(void) userSignedUpSuccessfully
{
    //Display the dashboard
    [self displayDash];
}

-(void) loadSignInClicked
{
    if(self.mSignUpViewController)
        [self.mSignUpViewController dismissViewControllerAnimated:NO completion:nil];
    
    if(self.mLoginViewController)
        self.mLoginViewController = nil;
    
    self.mLoginViewController = [[LoginViewController alloc] init];
    self.mLoginViewController.mLoginDelegate = self;
    [self.mMainNavController presentViewController:self.mLoginViewController animated:NO completion:nil];
}
#pragma end

#pragma mark DashNoInfoViewDelegate
-(void) showAndCalcCurrentLifeStyleIncome
{
    [self displayDash];
}
#pragma end

#pragma mark DashUserPFInfoDelegate
-(void) showAndCalculateRentVsBuy
{
    [self displayDash];
}
#pragma end

#pragma mark Dash1HomeEnteredViewDelegate
-(void) calculateAndCompareHomes
{
    [self displayDash];
}
#pragma end

#pragma mark APILoanInfoDelegate
-(void) finishedReadingLoanInfo
{
    [self displayDash];
}
#pragma end
#pragma mark APIHomeInfoServiceDelegate
-(void) finishedReadingHomeInfo
{
    APILoanInfoService* loanInfoService = [[APILoanInfoService alloc] init];
    loanInfoService.mAPILoanInfoDelegate = self;
    if(loanInfoService)
    {
        if(![loanInfoService readLoanInfo])
        {
            NSLog(@"Error: Unable to read user laons Info");
        }
    }
}
#pragma end

#pragma mark APIServiceDelegate
-(void) finishedReadingUserPFInfo
{
    APIHomeInfoService* homeInfoService = [[APIHomeInfoService alloc] init];
    if(homeInfoService)
    {
        homeInfoService.mAPIHomeInfoDelegate = self;
        if(![homeInfoService readHomesInfo])
        {
            NSLog(@"Error: reading homes info for user");
        }
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
    
    if(row == ROW_SECOND_HOME && currentNumOfHomes == 0)
    {
        NSLog(@"Error: Cannot enter 2nd home before first");
        return;
    }
    
    HomeInfoViewController* homeInfoViewController = [[HomeInfoViewController alloc] initAsHomeNumber:row];
    homeInfoViewController.mHomeInfoViewDelegate = self;
    [self setRootView:homeInfoViewController];
}

-(void) handleLoanMenu:(NSInteger) row
{
   if(row != ROW_LOAN_INFO)
       return;
    
    LoanInfoViewController* loanInfoViewController = [[LoanInfoViewController alloc] init];
    loanInfoViewController.mLoanInfoViewDelegate = self;
    [self setRootView:loanInfoViewController];
}

-(void) handleProfileMenu:(NSInteger) row
{
    switch (row)
    {
        case ROW_YOUR_PROFILE:
        {
            
        }
            break;
            
        case ROW_FIXED_COSTS:
        {
            
        }
            break;
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
            
        }
            break;
            
        case ROW_LOGOUT:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark LeftMenuDelegate
-(void) showFrontViewForSection:(NSInteger)section andRow:(NSInteger)row
{
    [self.mMainDashController hideLeftView];
    
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
