//
//  Utilities.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
+(void) showAlertWithTitle:(NSString*)title andMessage:(NSString*) msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert show];
}

+(BOOL) isUITextFieldEmpty:(UITextField*) aTextField
{
    if(aTextField && ![aTextField.text isEqualToString:@""])
        return NO;
    return YES;
}

+(CGFloat) getDeviceWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+(CGFloat) getDeviceHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

@end
