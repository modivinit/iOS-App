//
//  SignUpViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpDelegate <NSObject>
-(void) userSignedUpSuccessfully;
@end

@interface SignUpViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, weak) id <SignUpDelegate> mSignUpDelegate;
@end
