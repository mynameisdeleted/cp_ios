//
//  CPConstants.h
//  candpiosapp
//
//  Created by Stephen Birarda on 3/9/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// define a way to quickly grab the app delegate
#define CPAppDelegate (AppDelegate *)[UIApplication sharedApplication].delegate

// define a way to quickly grab and set NSUserDefaults
#define DEFAULTS(type, key) ([[NSUserDefaults standardUserDefaults] type##ForKey:key])
#define SET_DEFAULTS(Type, key, val) do {\
[[NSUserDefaults standardUserDefaults] set##Type:val forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];\
} while (0)

@interface CPConstants : NSObject

extern  NSString* const kCandPWebServiceUrl;
extern  NSString* const kCandPAPIVersion;
extern  NSString* const kCandPAddFundsUrl;
extern  NSString* const kLinkedInKey;
extern  NSString* const kLinkedInSecret;
extern  NSString* const flurryAnalyticsKey;
extern  NSString* const kSmartererKey;
extern  NSString* const kSmartererSecret;
extern  NSString* const kSmartererCallback;
extern  NSString* const kTestFlightKey;
extern  NSString* const kUserVoiceSite;
extern  NSString* const kUserVoiceKey;
extern  NSString* const kUserVoiceSecret;


// NOTE: We are slowly moving the way we store data to the 
// iOS standard NSUserDefaults (eventually replacing Settings.h)
// these are the keys for things stored in NSUserDefaults
extern NSString* const kUDCurrentUser;
extern NSString* const kUDCurrentVenue;
extern NSString* const kUDPastVenues;
extern NSString* const kUDCheckoutTime;
extern NSString* const kUDLastLoggedAppVersion;
extern NSString* const kAutomaticCheckins;

extern int const kDefaultDimissDelay;

@end
