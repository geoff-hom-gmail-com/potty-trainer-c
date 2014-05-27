//
//  GGKPerfectPottyModel.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGKChild.h"

// Potty-record symbols.
// Symbol for pee + poo.
extern NSString *GGKBothSymbolString;
// Symbol for pee.
extern NSString *GGKPeeSymbolString;
// A poo emoji.
extern NSString *GGKPooSymbolString;
// A star symbol. Used for successful attempts in v1.0.4 and earlier.
extern NSString *GGKStarSymbolString;
// An X symbol. Used for unsuccessful attempts.
extern NSString *GGKXSymbolString;

// Keys for saving data.
// Time for first reminder, in seconds after midnight.
extern NSString *GGKFirstReminderSecondsAfterMidnightIntegerKeyString;
// Last possible time for a repeating reminder, in seconds after midnight.
extern NSString *GGKLastReminderSecondsAfterMidnightIntegerKeyString;
extern NSString *GGKMinutesBetweenRemindersIntegerKeyString;
// Key for storing the date of a potty attempt. Object is an NSDate.
extern NSString *GGKPottyAttemptDateKeyString;
// Key for storing the symbol for a potty attempt.
extern NSString *GGKPottyAttemptSymbolStringKeyString;
// Key for storing whether a potty attempt was successful. Object is a BOOL stored as an NSNumber.
extern NSString *GGKPottyAttemptWasSuccessfulNumberKeyString;
// Whether to add multiple reminders.
extern NSString *GGKRepeatReminderBOOLKeyString;

// String to identify the boy theme.
extern NSString *GGKBoyThemeString;
// String to identify the girl theme.
extern NSString *GGKGirlThemeString;
// String for the product ID for giving a dollar.
extern NSString *GGKGiveDollarProductIDString;
// Prefix for the sound file to use for reminders.
extern NSString *GGKReminderSoundPrefixString;
// A star symbol. Used for showing number of successful attempts, and for donation thank-yous.
extern NSString *GGKStarRewardString;

@interface GGKPerfectPottyModel : NSObject
// All children being tracked.
@property (strong, nonatomic) NSMutableArray *childrenMutableArray;
// Which color theme to use.
@property (strong, nonatomic) NSString *colorThemeString;
// Child the parent is currently tracking.
@property (strong, nonatomic) GGKChild *currentChild;
// Custom symbol to use, if any, for a new potty attempt.
@property (strong, nonatomic) NSString *currentCustomSymbol;
// Date for first reminder.
// Custom accessors.
@property (strong, nonatomic) NSDate *firstReminderDate;
// Whether currently setting the first reminder time or the last.
@property (assign, nonatomic) BOOL isSettingFirstReminderTimeBOOL;
// Last possible date for a repeating reminder. (May be earlier if interval doesn't fit evenly.)
// Custom accessors.
@property (strong, nonatomic) NSDate *lastReminderDate;
// Minutes between repeating reminders.
// Custom accessors.
@property (assign, nonatomic) NSInteger minutesBetweenRemindersInteger;
// For in-app donation. Not related to child rewards.
@property (assign, nonatomic) NSInteger numberOfStarsPurchasedInteger;
// The reminder is set using date components. I.e., time from the given date. 
@property (strong, nonatomic) NSDateComponents *reminderIncrementDateComponents;
// Whether to add multiple reminders.
// Custom accessors.
@property (assign, nonatomic) BOOL repeatReminderBOOL;
// Create child with name. Add to database. Return child.
- (GGKChild *)addChildWithName:(NSString *)name;
// Add the given potty attempt to the current child.
- (void)addPottyAttempt:(NSDictionary *)thePottyAttemptDictionary;
// Override.
- (id)init;
// Remove the given potty attempt from the current child.
- (void)removePottyAttempt:(NSDictionary *)thePottyAttemptDictionary;
// Remove the first potty attempt and add the second for the current child.
- (void)replacePottyAttempt:(NSDictionary *)theFirstPottyAttemptDictionary withAttempt:(NSDictionary *)theSecondPottyAttemptDictionary;
// Save data for all children.
- (void)saveChildren;

- (void)saveColorTheme;

- (void)saveCurrentChildID;

- (void)saveCustomSymbol;

- (void)saveNumberOfStarsPurchased;

- (void)saveReminderInterval;

// Return a child ID that doesn't conflict with existing IDs.
- (NSInteger)uniqueIDForNewChild;

@end
