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
-(BOOL) readUserPFInfo;
-(BOOL) readUserExpensesInfo;

@property (nonatomic, weak) id <APIServiceDelegate> mAPIServiceDelegate;
@end
