//
//  UsersHomesList.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "homeInfo.h"

#define MAX_NUMBER_OF_HOMES_PER_USER 2

@interface UsersHomesList : NSObject
-(uint) getCurrentHomesCount;
-(void) addNewHome:(homeInfo*) newHomeInfo;
-(void) updateHomeInfo:(homeInfo*) aHomeInfo;
-(homeInfo*) getHomeAtIndex:(uint) index;
@end
