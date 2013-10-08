//
//  kunanceConstants.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#ifndef HomeBuyer_kunanceConstants_h
#define HomeBuyer_kunanceConstants_h


// Used for saving to NSUserDefaults that a PIN has been set, and is the unique identifier for the Keychain.
#define PIN_SAVED @"hasSavedPIN"

// Used for saving the user's name to NSUserDefaults.
#define USERNAME @"username"


#define FIRST_HOME 0
#define SECOND_HOME 1

// Used to specify the application used in accessing the Keychain.
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

// Used to help secure the PIN.
// Ideally, this is randomly generated, but to avoid the unnecessary complexity and overhead of storing the Salt separately, we will standardize on this key.
// !!KEEP IT A SECRET!!
#define SALT_HASH @"NIFojfmblMFLKmknvdknLFK3048njU9BHKB39reGVG8V2knahs8214HBHBibhsf"

static NSString* kDisplayDashNotification=@"DisplayDash";

// Typedefs just to make it a little easier to read in code.
typedef enum {
    kAlertTypePIN = 0,
    kAlertTypeSetup
} AlertTypes;

typedef enum {
    kTextFieldPIN = 1,
    kTextFieldName,
    kTextFieldPassword
} TextFieldTypes;

typedef enum{
    ProfileStatusNoInfoEntered = 0,
    ProfileStatusUserPersonalFinanceInfoEntered,
    ProfileStatusUser1HomeInfoEntered,
    ProfileStatusUser1HomeAndLoanInfoEntered,
    ProfileStatusUser2HomesButNoLoanEntered, //This can only be an intermidiate state
    ProfileStatusUserTwoHomesAndLoanInfoEntered,
}kunanceUserProfileStatus;
#endif
