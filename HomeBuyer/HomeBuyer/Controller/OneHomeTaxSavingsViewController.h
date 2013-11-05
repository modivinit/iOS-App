//
//  OneHomeTaxSavingsViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoEntryViewController.h"

@protocol OneHomeTaxSavingsViewDelegate <NSObject>
-(void) setNavTitle:(NSString*) title;
@end

@interface OneHomeTaxSavingsViewController : UIViewController
@property (nonatomic, weak) id <OneHomeTaxSavingsViewDelegate> mOneHomeTaxSavingsDelegate;
@property (nonatomic, strong) IBOutlet UILabel* mEstTaxSavings;
@property (nonatomic, strong) IBOutlet UILabel* mEstTaxesPaidWithHome;
@property (nonatomic, strong) IBOutlet UILabel* mEstTaxPaidWithRental;

@property (nonatomic, strong) IBOutlet UILabel* mHomeNickName;
@property (nonatomic, strong) IBOutlet UIImageView* mHomeTypeIcon;

@property (nonatomic) IBOutlet UIButton* mAddAHomeButton;
-(IBAction)addAHomeTapped:(id)sender;

@property (nonatomic, strong) HomeInfoEntryViewController* mHomeInfoViewController;
@end
