//
//  kCATIntroViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"

@protocol kCATIntroViewDelegate <NSObject>
-(void) signInFromIntro;
-(void) signupFromIntro;
@end

@interface kCATIntroViewController : BasePageViewController
@property (nonatomic, strong) IBOutlet UIButton* mSignInButton;
@property (nonatomic, strong) IBOutlet UIButton* mSignUpButton;

@property (nonatomic, weak) id <kCATIntroViewDelegate> mkCATIntroDelegate;
-(IBAction)signInButtonTapped:(id)sender;
-(IBAction)signUpButtonTapped:(id)sender;
@end
