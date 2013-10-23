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

@protocol userProfileInfoDelegate <NSObject>
@optional
-(void) finishedReadingUserPFInfo;
-(void) finishedWritingUserPFInfo;
@end

@interface userProfileInfo : NSObject

-(BOOL) writeFixedCostsInfo:(UInt64)enteredMonthlyRent
          monthlyCarPaments:(UInt64)enteredCarPayments
            otherFixedCosts:(UInt64)enteredOtherCosts;

-(BOOL) writeUserPFInfo:(UInt64)annualGross
       annualRetirement:(UInt64)annualRetirement
       numberOfChildren:(uint)numberOfChildren
          maritalStatus:(userMaritalStatus) status;

-(void) readUserPFInfo;

-(BOOL) isFixedCostsInfoEntered;

-(userMaritalStatus) getMaritalStatus;
-(long) getAnnualGrossIncome;
-(long) getAnnualRetirementSavings;
-(int) getNumberOfChildren;
-(int) getMonthlyRentInfo;
-(int) getCarPaymentsInfo;
-(int) getOtherFixedCostsInfo;

@property (nonatomic, weak) id <userProfileInfoDelegate> mUserProfileInfoDelegate;
@end
