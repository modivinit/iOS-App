//
//  FormViewController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/28/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormViewController : UIViewController <UITextFieldDelegate>
{
 
}

- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;
- (void)dismissKeyboard;

-(void) deregisterForKeyboardNotifications;
-(void) registerForKeyboardNotifications;

@property (nonatomic, strong) IBOutlet UIScrollView* mFormScrollView;
@property (nonatomic, strong) UITextField*  mActiveField;
@property (nonatomic, strong) NSArray*      mFormFields;
@property (nonatomic, strong) UIToolbar*    mKeyBoardToolbar;
@end
