//
//  Utilities.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
+(void) showAlertWithTitle:(NSString*)title andMessage:(NSString*)msg;
+(BOOL) isUITextFieldEmpty:(UITextField*) aTextField;
+(CGFloat) getDeviceWidth;
+(CGFloat) getDeviceHeight;
+(UIColor*) getKunanceBlueColor;
@end
