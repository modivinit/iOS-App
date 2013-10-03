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
        FatFractal *ff = [FatFractal main];
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
    
    UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController: self.mMainDashController];
    LeftMenuViewController *leftViewController = [[LeftMenuViewController alloc] init];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:frontViewController
                                                                     leftViewController:leftViewController
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

#pragma mark APIServiceDelegate
-(void) finishedReadingUserPFInfo
{
    APIHomeInfoService* homeInfoService = [[APIHomeInfoService alloc] init];
    if(homeInfoService)
    {
        if(![homeInfoService readHomesInfo])
        {
            NSLog(@"Error: reading homes info for user");
        }
    }
    
    APILoanInfoService* loanInfoService = [[APILoanInfoService alloc] init];
    if(loanInfoService)
    {
        if(![loanInfoService readLoanInfo])
        {
            NSLog(@"Error: Unable to read user laons Info");
        }
    }
    
    [self displayDash];
}

#pragma end
@end
