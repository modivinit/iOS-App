//
//  OneHomeTaxSavingsViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeTaxSavingsViewDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface HomeTaxSavingsViewController : UIViewController
@property (nonatomic, weak) id <HomeTaxSavingsViewDelegate> mHomeTaxSavingsDelegate;
@property (nonatomic, strong) IBOutlet UILabel* mEstTaxSavings;
@property (nonatomic, strong) IBOutlet UILabel* mEstTaxesPaidWithHome;
@property (nonatomic, strong) IBOutlet UILabel* mEstTaxPaidWithRental;
@end
