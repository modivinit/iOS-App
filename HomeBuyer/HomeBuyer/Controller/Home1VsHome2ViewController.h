//
//  Dash2HomesEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/3/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashLeftMenuViewController.h"

@protocol Homes1VsHome2Delegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end


@interface Home1VsHome2ViewController : UIViewController
@property (nonatomic, strong) UINavigationItem* navItem;

@property (nonatomic, weak) id <Homes1VsHome2Delegate> mHomes1VsHome2Delegate;
@property (nonatomic, strong) IBOutlet UILabel* mHome1LifeStyle;
@property (nonatomic, strong) IBOutlet UILabel* mHome2LifeStyle;

@property (nonatomic, strong) IBOutlet UILabel* mHome1Payment;
@property (nonatomic, strong) IBOutlet UILabel* mHome2Payment;

@end
