//
//  UsersHomesList.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "UsersHomesList.h"

@interface UsersHomesList ()
    @property (nonatomic, strong) NSMutableArray* mHomesAddedByUser;
@end



@implementation UsersHomesList

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mHomesAddedByUser = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void) addNewHome:(homeInfo *)newHomeInfo
{
    if(!newHomeInfo)
        return;
    
    if(self.mHomesAddedByUser)
        [self.mHomesAddedByUser addObject:newHomeInfo];
}

-(void) updateHomeInfo:(homeInfo*) aHomeInfo
{
    if(aHomeInfo && (aHomeInfo.mHomeId < self.mHomesAddedByUser.count))
        self.mHomesAddedByUser[aHomeInfo.mHomeId] = aHomeInfo;
}

-(uint) getCurrentHomesCount
{
    return self.mHomesAddedByUser.count;
}

-(homeInfo*) getHomeAtIndex:(uint) index
{
    if(index >= self.mHomesAddedByUser.count)
        return nil;
    else
        return (homeInfo*) self.mHomesAddedByUser[index];
}
@end
