//
//  OneHomePaymentsViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePaymentsDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end


@interface HomePaymentsViewController : UIViewController
@property (nonatomic, weak) id <HomePaymentsDelegate> mHomePaymentsDelegate;
@end
