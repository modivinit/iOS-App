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

static NSString* const kHomeAddressStreetAddressKey = @"HomeStreetAddress";
static NSString* const kHomeAddressCityCodeKey = @"HomeAddressCityCode";
static NSString* const kHomeAddressStateCodeKey = @"HomeAddressStateCode";
static NSString* const kHomeAddressZipCodeKey = @"HomeAddressZipCode";

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

-(id) initWithDictionary:(NSDictionary*) addressDict
{
    self = [super init];
    
    if(self)
    {
        if(!addressDict)
            return self;
        
        if(addressDict[kHomeAddressStreetAddressKey])
            self.mStreetAddress = addressDict[kHomeAddressStreetAddressKey];
        else
            self.mStreetAddress = nil;
        
        if(addressDict[kHomeAddressCityCodeKey])
            self.mCityCode = [addressDict[kHomeAddressCityCodeKey] integerValue];
        else
            self.mCityCode = 0;
        
        if(addressDict[kHomeAddressStateCodeKey])
            self.mStateCode = [addressDict[kHomeAddressStateCodeKey] integerValue];
        else
            self.mStateCode = 0;
        
        if(addressDict[kHomeAddressZipCodeKey])
            self.mZipCode = addressDict[kHomeAddressZipCodeKey];
        else
            self.mZipCode = nil;
    }
    
    return self;
}

-(NSDictionary*) getDictionaryForAddressObject
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    if(self.mStreetAddress)
        dict[kHomeAddressStreetAddressKey] = self.mStreetAddress;
    
    if(self.mCityCode)
        dict[kHomeAddressCityCodeKey] = [NSNumber numberWithInt:self.mCityCode];
    
    if(self.mStateCode)
        dict[kHomeAddressStateCodeKey] = [NSNumber numberWithInt:self.mStateCode];
    
    if(self.mZipCode)
        dict[kHomeAddressZipCodeKey] = self.mZipCode;
    
    return dict;
}
@end
