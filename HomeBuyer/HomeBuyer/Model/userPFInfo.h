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
    StatusSingle = 1,
    StatusNotDefined = 3
}userMaritalStatus;

@interface userPFInfo : NSObject
@property (nonatomic, readwrite) userMaritalStatus mMaritalStatus;
@property (nonatomic) UInt64                       mGrossAnnualIncome;
@property (nonatomic) UInt8                        mNumberOfChildren;
@property (nonatomic) UInt64                       mAnnualRetirementSavingsContributions;
@property (nonatomic) UInt16                       mCurrentMonthlyIncomeTax;
@property (nonatomic, strong) NSString*            mUserPFInfoGUID;
@end
