//
//  TwoHomeTaxSavingsViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TwoHomeTaxSavingsDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface TwoHomeTaxSavingsViewController : UIViewController
@property (nonatomic, strong) IBOutlet UILabel* mEstFirstHomeTaxes;
@property (nonatomic, strong) IBOutlet UILabel* mEstSecondHomeTaxes;
@property (nonatomic, strong) IBOutlet UILabel* mEstRentalUnitTaxes;

@property (nonatomic, strong) IBOutlet UIImageView* mFirstHomeType;
@property (nonatomic, strong) IBOutlet UIImageView* mSecondHomeType;

@property (nonatomic, weak) id <TwoHomeTaxSavingsDelegate> mTwoHomeTaxSavingsDelegate;
@end
