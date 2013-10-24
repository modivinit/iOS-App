//
//  loan.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOLLAR_VALUE_DOWN_PAYMENT 0
#define PERCENT_VALUE_DOWN_PAYMENT 1

#define LOAN_DURATION_10_YEARS 10
#define LOAN_DURATION_15_YEARS 15
#define LOAN_DURATION_20_YEARS 20
#define LOAN_DURATION_30_YEARS 30

#define MAX_POSSIBLE_INTEREST_RATE 30

typedef enum
{
    loanDurationTenYears = 1,
    loanDurationFifteenYears = 2,
    loanDurationTwentyYears = 3,
    loanDurationThirtyYears = 4
}loanDurationIndex;


#define DEFAULT_LOAN_DURATION_IN_YEARS loanDurationThirtyYears


@interface loan : NSObject
    @property (nonatomic) float mDownPayment;
    @property (nonatomic) uint   mDownPaymentType;
    @property (nonatomic) float  mLoanInterestRate;
    @property (nonatomic) uint   mLoanDuration;

+(uint) getLoanDurationForIndex:(uint) index;
+(uint) getIndexForLoanDuration:(uint) loanDuration;

-(id) initWithDictionary:(NSDictionary*) dict;
-(NSDictionary*) getDictionaryObjectWithLoan;
@end
