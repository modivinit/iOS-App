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
static NSString* const kHomeAddressCityKey = @"HomeAddressCity";
static NSString* const kHomeAddressStateKey = @"HomeAddressState";
static NSString* const kHomeAddressZipCodeKey = @"HomeAddressZipCode";

@implementation homeAddress

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mStreetAddress = nil;
        self.mCity = nil;
        self.mState = nil;
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
        
        if(addressDict[kHomeAddressCityKey])
            self.mCity = addressDict[kHomeAddressCityKey];
        else
            self.mCity = nil;
        
        if(addressDict[kHomeAddressStateKey])
            self.mState = addressDict[kHomeAddressStateKey];
        else
            self.mState = nil;
        
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
    
    if(self.mCity)
        dict[kHomeAddressCityKey] = self.mCity;
    
    if(self.mState)
        dict[kHomeAddressStateKey] = self.mState;
    
    if(self.mZipCode)
        dict[kHomeAddressZipCodeKey] = self.mZipCode;
    
    return dict;
}
@end
