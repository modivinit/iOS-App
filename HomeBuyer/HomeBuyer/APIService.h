//
//  APIService.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/17/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIServiceDelegate <NSObject>

@optional
-(void) finishedReadingUserPFInfo;
-(void) finishedWritingUserPFInfo;

@end

@interface APIService : NSObject

-(BOOL) writeFixedCostsInfo:(UInt64)enteredMonthlyRent
          monthlyCarPaments:(UInt64)enteredCarPayments
            otherFixedCosts:(UInt64)enteredOtherCosts;

-(BOOL) writeUserPFInfo:(UInt64)annualGross
       annualRetirement:(UInt64)annualRetirement
       numberOfChildren:(uint)numberOfChildren
          maritalStatus:(userMaritalStatus) status;

-(BOOL) readUserPFInfo;

@property (nonatomic, weak) id <APIServiceDelegate> mAPIServiceDelegate;
@end
