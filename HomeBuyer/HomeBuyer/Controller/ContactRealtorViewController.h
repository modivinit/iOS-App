//
//  ContactRealtorViewController.h
//  HomeBuyer
//
//  Created by Vinit Modi on 10/9/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashLeftMenuViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface ContactRealtorViewController : DashLeftMenuViewController<MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) IBOutlet UIButton* mDashboard;


@property (nonatomic, strong) IBOutlet UILabel* mCompanyName;
@property (nonatomic, strong) IBOutlet UILabel* mAddress;
@property (nonatomic, strong) IBOutlet UILabel* mContactName;
@property (nonatomic, strong) IBOutlet UIButton* mEmail;
@property (nonatomic, strong) IBOutlet UIButton* mCallNumber;
@property (nonatomic, strong) IBOutlet UIButton* mTextNumber;
@property (nonatomic, strong) IBOutlet UIImageView* mLogoImage;
@property (nonatomic) bool showDashboardIcon;
-(IBAction)showDash:(id)sender;

-(IBAction)callRealtor:(id)sender;
-(IBAction)emailRealtor:(id)sender;
-(IBAction)textRealtor:(id)sender;
@end
