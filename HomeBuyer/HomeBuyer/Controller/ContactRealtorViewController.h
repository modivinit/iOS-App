//
//  ContactRealtorViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/9/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashLeftMenuViewController.h"

@interface ContactRealtorViewController : DashLeftMenuViewController
@property (nonatomic, strong) IBOutlet UIButton* mDashboard;

-(IBAction)showDash:(id)sender;
@end
