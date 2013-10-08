//
//  OneHomePaymentsViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneHomePaymentsDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end


@interface OneHomePaymentsViewController : UIViewController
@property (nonatomic, weak) id <OneHomePaymentsDelegate> mOneHomePaymentsDelegate;
@end
