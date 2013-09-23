//
//  ExpensesViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/16/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExpensesControllerDelegate <NSObject>
-(void) currentLifeStyleIncomeButtonPressed;
@end

@interface ExpensesViewController : UIViewController

@property (nonatomic, weak) id <ExpensesControllerDelegate> mExpensesControllerDelegate;
@end
