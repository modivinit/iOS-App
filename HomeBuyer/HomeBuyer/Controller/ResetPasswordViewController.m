//
//  ResetPasswordViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/22/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mEmailField.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
    
        //self.mButtonColor = self.navigationItem.rightBarButtonItem.
}

-(void) doneButtonPressed
{
    
}

/*-(BOOL) textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString* newStr = [NSString stringWithFormat:@"%@%@",self.mEmailField.text, string];
    if([Utilities isValidEmail:newStr])
    {
        
    }
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
