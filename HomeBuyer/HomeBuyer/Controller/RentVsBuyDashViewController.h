//
//  Dash1HomeEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashLeftMenuViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@protocol RentVsBuyDashViewDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface RentVsBuyDashViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIView* mAddAHomeButtonAsView;

@property (nonatomic, weak) id <RentVsBuyDashViewDelegate> mRentVsBuyDashViewDelegate;
@end
