//
//  userPFInfo.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    StatusMarried = 0,
    StatusSingle = 1
}userMaritalStatus;

@interface userPFInfo : NSObject
@property (nonatomic, readwrite) userMaritalStatus mMaritalStatus;
@property (nonatomic) UInt16                       mGrossAnnualIncome;
@property (nonatomic) UInt8                        mNumberOfChildren;
@property (nonatomic) UInt16                       mAnnualRetirementSavingsContributions;
@property (nonatomic) UInt16                       mCurrentMonthlyIncomeTax;
@end
