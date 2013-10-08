//
//  OneHomeLifeStyleViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneHomeLifeStyleDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end



@interface OneHomeLifeStyleViewController : UIViewController
@property (nonatomic, weak) id <OneHomeLifeStyleDelegate> mOneHomeLifeStyleDelegate;
@end
