//
//  MainController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/27/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "MainController.h"

@interface MainController ()
@end

@implementation MainController

-(id) init
{
    self = [super init];
    
    if(self)
    {
        
    }
    
    return self;
}

-(void) start
{
    //if logged in,
    if([[kunanceUser getInstance] isLoggedInUser])
    {
        //then go to the dashboard
    }
    else  //If not logged in
    {
        //check to see if there is a user account on keychain
        if([[kunanceUser getInstance] userAccountFoundOnDevice])
        {
            //then login
            [[kunanceUser getInstance] loginSavedUser];
        }
        else //If there is no user account
        {
            //then show the create account view
        }
 
    }
}
@end
