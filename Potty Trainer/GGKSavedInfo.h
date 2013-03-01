//
//  GGKSavedInfo.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>

// String to identify the boy theme.
extern NSString *GGKBoyThemeString;

// String to identify the girl theme.
extern NSString *GGKGirlThemeString;

// Key for storing the number of successful potties done.
//extern NSString *GGKNumberOfSuccessfulPottiesKeyString;

// Key for storing the date of a potty attempt. Object is an NSDate.
extern NSString *GGKPottyAttemptDateKeyString;

// Key for storing whether a potty attempt was successful. Object is a BOOL stored as an NSNumber.
extern NSString *GGKPottyAttemptWasSuccessfulNumberKeyString;

// Key for storing all potty attempts. Object is an array of all potty attempts. Each element is an array of potty attempts for a given date. Each potty attempt is a dictionary containing the date (GGKPottyAttemptDateKeyString) and whether the attempt was successful (GGKPottyAttemptWasSuccessfulNumberKeyString).
extern NSString *GGKPottyAttemptsKeyString;

// Key for storing the number of minutes used for the previous reminder.
extern NSString *GGKReminderMinutesNumberKeyString;

// Key for storing the name of the color theme to show.
extern NSString *GGKThemeKeyString;

@interface GGKSavedInfo : NSObject

@end
