//
//  OneHomePaymentViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneHomePaymentViewDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end


@interface OneHomePaymentViewController : UIViewController
@property (nonatomic, weak) id <OneHomePaymentViewDelegate> mOneHomePaymentViewDelegate;
@end
