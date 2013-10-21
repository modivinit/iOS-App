//
//  homeAddress.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeAddress : NSObject
@property (nonatomic, copy) NSString* mStreetAddress;
@property (nonatomic) uint mCityCode;
@property (nonatomic) uint mStateCode;
@property (nonatomic, copy) NSString* mZipCode;
@end
