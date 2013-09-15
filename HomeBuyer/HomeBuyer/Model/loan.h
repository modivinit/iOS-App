//
//  loan.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface loan : NSObject
    @property (nonatomic) UInt16 mDownPayment;
    @property (nonatomic) float  mLoanInterestRate;
    @property (nonatomic) uint   mLoanDuration;
@end
