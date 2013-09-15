//
//  homeInfo.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "homeAddress.h"
typedef enum
{
    singleFamily = 0,
    condominium = 1
}homeType;

@interface homeInfo : NSObject
@property (nonatomic) homeType          mHomeType;
@property (nonatomic, strong) NSString* mIdentifiyingHomeFeature;
@property (nonatomic) uint              mHomeListPrice;
@property (nonatomic) uint              mHOAFees;
@property (nonatomic) uint              mMonthlyLoanPayment;
@property (nonatomic) homeAddress*      mHomeAddress;
@property (nonatomic) uint              mMonthlyPropertyTaxOnHome;
@property (nonatomic) uint              mMonthlyInsurance;
@property (nonatomic) uint              mPMIForHome;
@end
