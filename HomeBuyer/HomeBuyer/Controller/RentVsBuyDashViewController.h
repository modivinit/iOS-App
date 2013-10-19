//
//  Dash1HomeEnteredViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RentVsBuyDashViewDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface RentVsBuyDashViewController : UIViewController

@property (nonatomic, weak) id <RentVsBuyDashViewDelegate> mRentVsBuyDashViewDelegate;
@property (nonatomic, strong) IBOutlet UILabel* mRentalLifeStyleIncome;
@property (nonatomic, strong) IBOutlet UILabel* mHomeLifeStyleIncome;
@property (nonatomic, strong) IBOutlet UILabel* mRentalMonthlyPayment;
@property (nonatomic, strong) IBOutlet UILabel* mHomeMonthlyPayment;
@end
