//
//  kunanceConstants.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#ifndef HomeBuyer_kunanceConstants_h
#define HomeBuyer_kunanceConstants_h


//Used to find out if the screen size is 3.5" or 4" Retina display. For iPad it defaults to 3.5" view
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height == 568 ))

// Used for saving to NSUserDefaults that a PIN has been set, and is the unique identifier for the Keychain.
#define PIN_SAVED @"hasSavedPIN"

// Used for saving the user's name to NSUserDefaults.
#define USERNAME @"username"


#define FIRST_HOME 0
#define SECOND_HOME 1

#define MIN_PASSWORD_LENGTH 6
// Used to specify the application used in accessing the Keychain.
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

// Used to help secure the PIN.
// Ideally, this is randomly generated, but to avoid the unnecessary complexity and overhead of storing the Salt separately, we will standardize on this key.
// !!KEEP IT A SECRET!!
#define SALT_HASH @"NIFojfmblMFLKmknvdknLFK3048njU9BHKB39reGVG8V2knahs8214HBHBibhsf"

#define SHINOBI_LICENSE_KEY @"UQYgT78jOV2ruVjMjAxMzEwMjdpbmZvQHNoaW5vYmljb250cm9scy5jb20=aPdgi4UKjOC/oSKLym4aWsyvqhn+9MSEVxSigB5axMtOL+2bv1IXlzq4KXLVrBiclKalaevAwtUOjj+DQKHA5p5uFJ6mg1mnIGH/CN+tP1RfZerSFr72EwY09fnpO/0mi7C+3XrEfC901LltFG7VAMlVPs+c=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+"

static NSString* const kDisplayMainDashNotification=@"DisplayMainDash";
static NSString* const kDisplayHomeDashNotification=@"DisplayHomeDash";
static NSString* const kReturnButtonClickedOnSignupForm=@"ReturnButtonOnSingnupFOrm";
static NSString* const kReturnButtonClickedOnSigninForm=@"ReturnButtonOnSigninFOrm";
static NSString* const kHomeButtonTappedFromDash=@"HomeButtonTappedFromDash";
static NSString* const kDisplayUserDash=@"ShowUserDash";


#define USE_PARSE 1

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
    ProfileStatusUndefined = 0,
    ProfileStatusUserPersonalFinanceInfoEntered,  //1
    ProfileStatusPersonalFinanceAndFixedCostsInfoEntered, //2
    ProfileStatusUser1HomeInfoEntered,  //3
    ProfileStatusUser1HomeAndLoanInfoEntered, //4
    ProfileStatusUserTwoHomesButNoLoanInfoEntered, //5
    ProfileStatusUserTwoHomesAndLoanInfoEntered, //6
}kunanceUserProfileStatus;
#endif
