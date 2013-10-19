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

+(UIColor*) getKunanceBlueColor
{
    return [UIColor colorWithRed:15/255.0 green:125/255.0 blue:255/255.0 alpha:1.0];
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

+ (UIActivityIndicatorView*) getAndStartBusyIndicator
{
    CGFloat width = 40;
    CGFloat height = 40;
    
    CGFloat navBarHeight = 40;
    
    CGFloat x = [[UIScreen mainScreen] bounds].size.width/2-(width/2);
    CGFloat y = [[UIScreen mainScreen] bounds].size.height/2-navBarHeight-(height/2);
    
    UIActivityIndicatorView* busyIndicator = [[UIActivityIndicatorView alloc]
                                              initWithFrame:CGRectMake(x, y, width, height)];
    
    [busyIndicator setColor:[UIColor blackColor]];
    [busyIndicator startAnimating];
    
    return busyIndicator;
}

@end
