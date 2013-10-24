//
//  UsersHomesList.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "UsersHomesList.h"
#import <Parse/Parse.h>

static NSString* const kHomesListClassKey = @"HomesList";
static NSString* const kHomesArrayKey = @"HomesArray";

static NSString* const kUserKey          = @"User";
static NSString* const kNumberOfHomesKey = @"NumberOfHomes";

static NSString* const kHomeInfoClassKey = @"HomeInfo";

static NSString* const kHomeTypeKey = @"HomeType";
static NSString* const kIdentifyingFeatureKey = @"IdentifiyingHomeFeature";
static NSString* const kHomeListProceKey = @"HomeListPrice";
static NSString* const kHOAFeesKey = @"HOAFees";
static NSString* const kHomeAddressKey = @"HomeAddress";
static NSString* const kHomeIDKey = @"mHomeId";

@interface UsersHomesList ()
@property (nonatomic, strong) PFObject* mParseHomesListObject;
@end

@implementation UsersHomesList

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mParseHomesListObject = nil;
    }
    
    return self;
}

-(BOOL) readHomesInfo
{
    PFQuery* query = [PFQuery queryWithClassName:kHomesListClassKey];
    [query whereKey:kUserKey equalTo:[[kunanceUser getInstance] getUserID]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *userObject, NSError *error)
     {
         if(!error && userObject)
         {
             self.mParseHomesListObject = userObject;
         }
         
         if(self.mUsersHomesListDelegate && [self.mUsersHomesListDelegate respondsToSelector:@selector(finishedReadingUserPFInfo)])
         {
             [self.mUsersHomesListDelegate finishedReadingHomeInfo];
         }
     }];
    
    return YES;
}

-(PFObject*) getParseHomeObjectFromHomeInfo:(homeInfo*) aHomeInfo
{
    if(!aHomeInfo)
        return nil;
    
    PFObject* parseHomeInfo = [PFObject objectWithClassName:kHomeInfoClassKey];
    
    parseHomeInfo[kHomeTypeKey] = [NSNumber numberWithInt:aHomeInfo.mHomeType];
    parseHomeInfo[kIdentifyingFeatureKey] = aHomeInfo.mIdentifiyingHomeFeature;
    parseHomeInfo[kHomeListProceKey] = [NSNumber numberWithLong:aHomeInfo.mHomeListPrice];
    parseHomeInfo[kHOAFeesKey] = [NSNumber numberWithLong:aHomeInfo.mHOAFees];
//    parseHomeInfo[kHomeAddressKey] = [aHomeInfo.mHomeAddress getparseObject];
    parseHomeInfo[kHomeIDKey] = [NSNumber numberWithInteger:aHomeInfo.mHomeId];
    
    return parseHomeInfo;
}

-(BOOL) createNewHomeInfo:(homeInfo*) aHomeInfo
{
    if(!aHomeInfo || !aHomeInfo.mIdentifiyingHomeFeature || !aHomeInfo.mHomeListPrice || !aHomeInfo.mHomeId)
        return NO;

    if([self getCurrentHomesCount] == MAX_NUMBER_OF_HOMES_PER_USER)
        return NO;
    
    __block PFObject* parseHomesListObj = nil;
    
    if(!self.mParseHomesListObject)
    {
        parseHomesListObj = [PFObject objectWithClassName:kHomesListClassKey];
    }
    else
    {
        parseHomesListObj = self.mParseHomesListObject;
    }
    
    PFObject* ahome = [self getParseHomeObjectFromHomeInfo:aHomeInfo];
    NSArray* homesArry = [[NSArray alloc] initWithObjects:ahome, nil];
    
    parseHomesListObj[kHomesArrayKey] = homesArry;
    
    //[parseHomesListObj addUniqueObject:aHomeInfo forKey:kHomesArrayKey];
    parseHomesListObj[kNumberOfHomesKey] = @([self getCurrentHomesCount] + 1);
    
    if(!parseHomesListObj[kUserKey])
        parseHomesListObj[kUserKey] = [[kunanceUser getInstance] getUserID];
    
    if(!parseHomesListObj.ACL)
    {
        PFACL* homesListACL = [PFACL ACLWithUser:[kunanceUser getInstance].mLoggedInKunanceUser];
        parseHomesListObj.ACL = homesListACL;
    }
    
    [self uploadObject:parseHomesListObj];
    return YES;
}

-(BOOL) updateExistingHomeInfo:(homeInfo*) aHomeInfo
{
    return NO;
}

-(void) uploadObject:(PFObject*) parseHomesListObject
{
    if(!parseHomesListObject)
        return;
    
    [parseHomesListObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if(succeeded && !error)
         {
             if(self.mUsersHomesListDelegate &&
                [self.mUsersHomesListDelegate respondsToSelector:@selector(finishedWritingHomeInfo)])
             {
                 [self.mUsersHomesListDelegate finishedWritingHomeInfo];
             }
         }
         
     }];
}


-(uint) getCurrentHomesCount
{
    if(self.mParseHomesListObject && self.mParseHomesListObject[kNumberOfHomesKey])
        return [self.mParseHomesListObject[kNumberOfHomesKey] integerValue];
    else
        return 0;
}

-(homeInfo*) getHomeAtIndex:(uint) index
{
    if(index >= [self getCurrentHomesCount])
        return nil;
    else
    {
        NSArray* homes = self.mParseHomesListObject[kHomesArrayKey];
        if(homes && homes.count > 0 && index < homes.count )
        {
            return (homeInfo*) homes[index];
        }
    }

    return nil;
}

-(homeType) getTypeForHomeAtIndex:(uint) index
{
    homeInfo* home = [self getHomeAtIndex:index];
    if(home)
        return home.mHomeType;
    
    return homeTypeNotDefined;
}
@end
