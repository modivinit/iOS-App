//
//  APILoanInfoService.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "loan.h"

@protocol APILoanInfoServiceDelegate <NSObject>
@optional
-(void) finishedWritingLoanInfo;
-(void) finishedReadingLoanInfo;
@end

@interface APILoanInfoService : NSObject
@property (nonatomic, weak) id <APILoanInfoServiceDelegate> mAPILoanInfoDelegate;

-(BOOL) updateLoanInfo:(loan*) aLoan;
-(BOOL) readLoanInfo;
-(BOOL) createLoanInfo:(loan*) aLoan;
@end
