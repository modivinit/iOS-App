//
//  DashUserPFInfoViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoEntryViewController.h"
#import "LoanInfoViewController.h"
#import "DashLeftMenuViewController.h"

@interface DashUserPFInfoViewController : DashLeftMenuViewController 
@property (nonatomic, strong) IBOutlet UIButton* mAddAHomeButton;
@property (nonatomic, strong) IBOutlet UIButton* mAddAHomeIconButton;
@property (nonatomic, strong) IBOutlet UIButton* mHelpButton;


@property (nonatomic, strong) HomeInfoEntryViewController* mHomeInfoViewController;
@property (nonatomic, strong) LoanInfoViewController* mLoanInfoViewController;
@property (nonatomic) BOOL mWasLoadedFromMenu;

-(IBAction)helpButtonTapped:(id)sender;
-(IBAction)addHomeInfo:(id)sender;
-(IBAction)addHomeIcon:(id)sender;
@end
