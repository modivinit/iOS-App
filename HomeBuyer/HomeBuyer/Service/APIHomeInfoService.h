//
//  APIHomeInfoService.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/1/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "homeInfo.h"
#import "UsersHomesList.h"

@protocol APIHomeInfoServiceDelegate <NSObject>
@optional
-(void) finishedWritingHomeInfo;
-(void) finishedReadingHomeInfo;
@end

@interface APIHomeInfoService : NSObject

@property (nonatomic, weak) id <APIHomeInfoServiceDelegate> mAPIHomeInfoDelegate;

-(BOOL) createNewHomeInfo:(homeInfo*) aHomeInfo;
-(BOOL) updateExistingHomeInfo:(homeInfo*) aHomeInfo;
-(BOOL) readHomesInfo;
@end
