//
//  GGKSavedInfo.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>

//// String to identify the boy theme.
//extern NSString *GGKBoyThemeString;
//
//// String to identify the girl theme.
//extern NSString *GGKGirlThemeString;

// String for the product ID for giving a dollar.
extern NSString *GGKGiveDollarProductIDString;

// Key for storing the most-recent custom symbol used.
//extern NSString *GGKMostRecentCustomSymbolStringKeyString;

// Key for storing the number of stars purchased.
//extern NSString *GGKNumberOfStarsPurchasedNumberKeyString;

// Key for storing the number of successes needed for reward 1.
//extern NSString *GGKNumberOfSuccessesForReward1KeyString;

// Key for storing the number of successes needed for reward 2.
//extern NSString *GGKNumberOfSuccessesForReward2KeyString;
//
//// Key for storing the number of successes needed for reward 3.
//extern NSString *GGKNumberOfSuccessesForReward3KeyString;

// Key for storing the number of successful potties done.
//extern NSString *GGKNumberOfSuccessfulPottiesKeyString;

// Key for storing the date of a potty attempt. Object is an NSDate.
extern NSString *GGKPottyAttemptDateKeyString;

// Key for storing the symbol for a potty attempt.
extern NSString *GGKPottyAttemptSymbolStringKeyString;

// Key for storing whether a potty attempt was successful. Object is a BOOL stored as an NSNumber.
extern NSString *GGKPottyAttemptWasSuccessfulNumberKeyString;

// Key for storing all potty attempts. Object is an array of all potty attempts. Each element is an array of potty attempts for a given date. Each potty attempt is a dictionary containing the date (GGKPottyAttemptDateKeyString) and whether the attempt was successful (GGKPottyAttemptWasSuccessfulNumberKeyString).
//extern NSString *GGKPottyAttemptsKeyString;

//// Key for storing the number of minutes used for the previous reminder.
//extern NSString *GGKReminderMinutesNumberKeyString;
//
//// Key for storing whether reward 1 is text or an image.
//extern NSString *GGKReward1IsTextBOOLNumberKeyString;
//
//// Key for storing the text for reward 1.
//extern NSString *GGKReward1TextKeyString;
//
//// Key for storing whether reward 2 is text or an image.
//extern NSString *GGKReward2IsTextBOOLNumberKeyString;
//
//// Key for storing the text for reward 2.
//extern NSString *GGKReward2TextKeyString;
//
//// Key for storing whether reward 3 is text or an image.
//extern NSString *GGKReward3IsTextBOOLNumberKeyString;
//
//// Key for storing the text for reward 3.
//extern NSString *GGKReward3TextKeyString;

// A star symbol. Used for showing number of successful attempts, and for donation thank-yous.
extern NSString *GGKStarRewardString;

// A star symbol. Used for successful attempts in v1.0.4 and earlier.
extern NSString *GGKStarSymbolString;

// Key for storing the name of the color theme to show.
//extern NSString *GGKThemeKeyString;

// An X symbol. Used for unsuccessful attempts.
extern NSString *GGKXSymbolString;

@interface GGKSavedInfo : NSObject

@end
