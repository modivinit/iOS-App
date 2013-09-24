//
//  MainController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/27/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "MainController.h"
#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "LeftMenuViewController.h"
#import "PKRevealController.h"
#import "APIService.h"

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
        self.mAPIService = [[APIService alloc] init];
        self.mAPIService.mAPIServiceDelegate = self;
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
            SignUpViewController* signupCOntroller = [[SignUpViewController alloc] init];
            signupCOntroller.mSignUpDelegate = self;
            [self.mMainNavController pushViewController:signupCOntroller animated:NO];
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
    UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:[[DashboardViewController alloc] init]];
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

-(void) savedUserLoggedInSuccessfully
{
    if(self.mAPIService)
        [self.mAPIService readUserPFInfo];

    //display the dashboard
    [self displayDash];
}

-(void) failedToLoginSavedUser
{
    //show login screen here
    LoginViewController* loginViewController = [[LoginViewController alloc] init];
    [self.mMainNavController pushViewController:loginViewController animated:YES];
}


#pragma mark SignUpDelegate
-(void) userSignedUpSuccessfully
{
    //Display the dashboard
    [self displayDash];
}
#pragma end

#pragma mark APIServiceDelegate
-(void) userPFInfoReadSuccessfully
{
}

-(void) userExpensesInfoReadSuccessfully
{
    
}
#pragma end
@end
