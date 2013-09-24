//
//  APIService.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/17/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIServiceDelegate <NSObject>
-(void) userPFInfoReadSuccessfully;
-(void) userExpensesInfoReadSuccessfully;
@end

@interface APIService : NSObject

-(BOOL) writeUserPFInfo:(UInt64)annualGross
       annualRetirement:(UInt64)annualRetirement
       numberOfChildren:(uint)numberOfChildren
          maritalStatus:(userMaritalStatus) status;

-(BOOL) readUserPFInfo;

@property (nonatomic, weak) id <APIServiceDelegate> mAPIServiceDelegate;
@end
