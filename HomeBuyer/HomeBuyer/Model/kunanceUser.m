//
//  kunanceUser.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/30/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kunanceUser.h"
#import "KeychainWrapper.h"
#import "AppDelegate.h"

static kunanceUser *kunanceUserSingleton;

@interface kunanceUser()
@property (nonatomic, strong, readwrite) PFUser* mLoggedInKunanceUser;
@end

@implementation kunanceUser

+ (void) initialize
{
    if (self == [kunanceUser class]){
        kunanceUserSingleton = [[kunanceUser alloc] init];
    }
}

- (id) init
{
    NSAssert(kunanceUserSingleton == nil, @"Duplication initialization of singleton");
    self = [super init];
    if (self) {
        // Initialization
        self.mLoggedInKunanceUser = nil;
        self.mkunanceUserProfileInfo = nil;
        self.mKunanceUserHomes = nil;
        self.mKunanceUserLoans = nil;
        self.mUserProfileStatus = ProfileStatusUndefined;
        NSLog(@"User profile status = ProfileStatusNoInfoEntered");
    }
    
    return self;
}

-(BOOL) signupWithName:(NSString*) name
              password:(NSString*) password
                 email:(NSString*) email
           realtorCode:(NSString*) code
{
    if(!password || !email)
    {
        return NO;
    }
    
    PFUser* user = [PFUser user];
    user.username = email;
    user.password = password;
    user.email = email;
    
    NSArray* names = [name componentsSeparatedByString:@" "];
    if(names && names.count > 0)
    {
        user[@"FirstName"] = names[0];
        if(names.count > 1)
            user[@"LastName"] = names[1];
    }
    
    if(code)
        user[@"RealtorCode"] = code;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if(succeeded && !error)
            self.mLoggedInKunanceUser = user;
        
        if(self.mKunanceUserDelegate &&
           [self.mKunanceUserDelegate respondsToSelector:@selector(signupCompletedWithError:)])
        {
            [self.mKunanceUserDelegate signupCompletedWithError:error];
        }
    }];
    
    return YES;
}

-(BOOL) loginWithEmail:(NSString*) email
              password:(NSString*) password
{
    if(!email || !password)
    {
        return NO;
    }
    
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error)
     {
         if(user)
             self.mLoggedInKunanceUser = user;
         
         if(self.mKunanceUserDelegate &&
            [self.mKunanceUserDelegate respondsToSelector:@selector(loginCompletedWithError:)])
         {
             [self.mKunanceUserDelegate loginCompletedWithError:error];
         }
     }];
    
    return YES;
}

-(NSString*) getUserID
{
    if(self.mLoggedInKunanceUser)
        return self.mLoggedInKunanceUser.objectId;
    else
        return nil;
}

-(BOOL)userAccountFoundOnDevice
{
    if([PFUser currentUser])
        return YES;
    else
        return NO;
}

-(BOOL) loginSavedUser
{
    self.mLoggedInKunanceUser = [PFUser currentUser];
    
    if(self.mLoggedInKunanceUser)
        return YES;
    else
        return NO;
}

-(void) updateStatusWithUserProfileInfo
{
    if(!self.mkunanceUserProfileInfo)
        return;
    
    if((self.mUserProfileStatus == ProfileStatusUndefined) ||
       (self.mUserProfileStatus == ProfileStatusPersonalFinanceAndFixedCostsInfoEntered))
    {
        if([self.mkunanceUserProfileInfo isFixedCostsInfoEntered])
            self.mUserProfileStatus = ProfileStatusPersonalFinanceAndFixedCostsInfoEntered;
        else
            self.mUserProfileStatus = ProfileStatusUserPersonalFinanceInfoEntered;
    }
    else if(self.mUserProfileStatus == ProfileStatusUserPersonalFinanceInfoEntered &&
            [self.mkunanceUserProfileInfo isFixedCostsInfoEntered])
    {
        self.mUserProfileStatus = ProfileStatusPersonalFinanceAndFixedCostsInfoEntered;
    }
}

-(void) updateStatusWithHomeInfoStatus
{
    if(!self.mKunanceUserHomes || ![self.mKunanceUserHomes getCurrentHomesCount])
        return;
    
    if([self.mKunanceUserHomes getCurrentHomesCount] == 1)
    {
        if(self.mUserProfileStatus == ProfileStatusPersonalFinanceAndFixedCostsInfoEntered ||
           self.mUserProfileStatus == ProfileStatusUser1HomeInfoEntered)
        {
            self.mUserProfileStatus = ProfileStatusUser1HomeInfoEntered;
            NSLog(@"User profile status = ProfileStatusUser1HomeInfoEntered");
        }
        else
        {
            self.mUserProfileStatus = ProfileStatusUndefined;
        }
    }
    else if([self.mKunanceUserHomes getCurrentHomesCount] == 2)
    {
        if(self.mUserProfileStatus == ProfileStatusUser1HomeAndLoanInfoEntered ||
           self.mUserProfileStatus == ProfileStatusUserTwoHomesAndLoanInfoEntered)
        {
            self.mUserProfileStatus = ProfileStatusUserTwoHomesAndLoanInfoEntered;
            NSLog(@"User profile status = ProfileStatusUserTwoHomesAndLoanInfoEntered");
        }
        else if(self.mUserProfileStatus == ProfileStatusPersonalFinanceAndFixedCostsInfoEntered)
        {
            self.mUserProfileStatus = ProfileStatusUserTwoHomesButNoLoanInfoEntered;
        }
        else
            self.mUserProfileStatus = ProfileStatusUndefined;
    }
    else
        self.mUserProfileStatus = ProfileStatusUndefined;
}

-(void) updateStatusWithLoanInfoStatus
{
    if(!self.mKunanceUserLoans || ![self.mKunanceUserLoans getCurrentLoanCount])
        return;
    
    if(self.mUserProfileStatus == ProfileStatusUser1HomeInfoEntered)
        self.mUserProfileStatus = ProfileStatusUser1HomeAndLoanInfoEntered;
    else if(self.mUserProfileStatus == ProfileStatusUser1HomeAndLoanInfoEntered)
        self.mUserProfileStatus = ProfileStatusUser1HomeAndLoanInfoEntered;
    else if (self.mUserProfileStatus == ProfileStatusUserTwoHomesAndLoanInfoEntered)
    {
        self.mUserProfileStatus = ProfileStatusUserTwoHomesAndLoanInfoEntered;
        NSLog(@"User profile status = ProfileStatusUserTwoHomesAndLoanInfoEntered");
    }
    else if(self.mUserProfileStatus == ProfileStatusUserTwoHomesButNoLoanInfoEntered)
    {
        self.mUserProfileStatus = ProfileStatusUserTwoHomesAndLoanInfoEntered;
    }
    else
        self.mUserProfileStatus = ProfileStatusUndefined;
}


-(NSString*) getFirstName
{
    NSLog(@"PFUser %@", [PFUser currentUser]);
    return [PFUser currentUser][@"FirstName"];
}

-(BOOL) isUserLoggedIn
{
    if ([kunanceUser getInstance].mLoggedInKunanceUser)
    {
        return YES;
    }
    else
        return NO;
}

+(homeAndLoanInfo*) getCalculatorHomeAndLoanFrom:(homeInfo*)aHome andLoan:(loan*)aLoan
{
    if(!aHome || !aLoan)
        return nil;
    
    homeAndLoanInfo* homeAndLoan = [[homeAndLoanInfo alloc] init];
    homeAndLoan.mHomeListPrice = aHome.mHomeListPrice;

    if(aLoan.mDownPaymentType == DOLLAR_VALUE_DOWN_PAYMENT)
        homeAndLoan.mDownPaymentAmount = aLoan.mDownPayment;
    else if(aLoan.mDownPaymentType == PERCENT_VALUE_DOWN_PAYMENT)
        homeAndLoan.mDownPaymentAmount = aLoan.mDownPayment*aHome.mHomeListPrice/100;
    
    homeAndLoan.mHOAFees = aHome.mHOAFees;
    homeAndLoan.mLoanInterestRate = aLoan.mLoanInterestRate;
    homeAndLoan.mNumberOfMortgageMonths = aLoan.mLoanDuration * NUMBER_OF_MONTHS_IN_YEAR;
    homeAndLoan.mPropertyTaxRate = 1.25;
    
    return homeAndLoan;
}

-(void) logoutUser
{
    [PFUser logOut];
    self.mLoggedInKunanceUser = [PFUser currentUser];
    
    self.mkunanceUserProfileInfo = nil;
    self.mKunanceUserHomes = nil;
    self.mKunanceUserLoans = nil;
    self.mUserProfileStatus = ProfileStatusUndefined;
}

-(BOOL) getUserEmail:(NSString**)email andPassword:(NSString**)password
{
    if(!email || !password)
        return NO;
    
    NSData* emailData = [KeychainWrapper searchKeychainCopyMatchingIdentifier:@"email"];
    if(!emailData)
        return NO;
    
    NSString* emailStr = [[NSString alloc] initWithData:emailData
                                               encoding:NSUTF8StringEncoding];
    NSString* pswdStr = nil;
    if(emailStr)
    {
        NSData* pswdData = [KeychainWrapper searchKeychainCopyMatchingIdentifier:@"pswd"];

        if(!pswdData)
            return NO;
        
        pswdStr = [[NSString alloc] initWithData:pswdData
                                        encoding:NSUTF8StringEncoding];
    }
    
    if(emailStr && pswdStr)
    {
        *email = [emailStr copy];
        *password = [pswdStr copy];
        
        return YES;
    }
    
    return NO;

}

+ (kunanceUser*) getInstance
{
    return kunanceUserSingleton;
}
@end
