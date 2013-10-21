//
//  homeAddress.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "homeAddress.h"
#import "Cities.h"
#import "States.h"

@implementation homeAddress

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mStreetAddress = nil;
        self.mCityCode = OTHER_CITY_CODE;
        self.mStateCode = UNDEFINED_STATE_CODE;
        self.mZipCode = nil;
    }
    
    return self;
}
@end
