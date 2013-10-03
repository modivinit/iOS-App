//
//  Dash1HomeEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoViewController.h"

@protocol Dash1HomeEnteredViewDelegate <NSObject>
-(void) calculateAndCompareHomes;
@end

@interface Dash1HomeEnteredViewController : UIViewController<HomeInfoViewDelegate>

@property (nonatomic, strong) IBOutlet UIView* mAddAHomeButtonAsView;
@property (nonatomic, strong) HomeInfoViewController* mHomeInfoViewController;

@property (nonatomic, weak) id <Dash1HomeEnteredViewDelegate> mDash1HomEnteredDelegate;
@end
