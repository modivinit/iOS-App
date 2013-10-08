//
//  HomesComparisionViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomesComparisionDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface HomesComparisionViewController : UIViewController
@property (nonatomic, strong) UINavigationItem* navItem;

@property (nonatomic, weak) id <HomesComparisionDelegate> mHomesComparisionDelegate;
@end
