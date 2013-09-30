//
//  MainController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/27/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "DashNoInfoViewController.h"
#import "APIService.h"
#import "DashUserPFInfoViewController.h"

@protocol MainControllerDelegate <NSObject>
-(void) resetRootView:(UIViewController*) viewController;
@end

@interface MainController : NSObject <SignUpDelegate, APIServiceDelegate, LoginDelegate, DashNoInfoViewDelegate>
@property (nonatomic, strong) UINavigationController* mMainNavController;
@property (nonatomic, weak) id <MainControllerDelegate> mMainControllerDelegate;
@property (nonatomic, strong) APIService* mAPIService;
@property (nonatomic, strong) SignUpViewController* mSignUpViewController;
@property (nonatomic, strong) LoginViewController* mLoginViewController;
@property (nonatomic, strong) UIViewController*    mMainDashController;

-(id) initWithNavController:(UINavigationController*) navController;
-(void) start;
@end
