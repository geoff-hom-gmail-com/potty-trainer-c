//
//  GGKPerfectPottyModel.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGKChild.h"

// String to identify the boy theme.
extern NSString *GGKBoyThemeString;

// String to identify the girl theme.
extern NSString *GGKGirlThemeString;

// String for the product ID for giving a dollar.
extern NSString *GGKGiveDollarProductIDString;

// Key for storing the date of a potty attempt. Object is an NSDate.
extern NSString *GGKPottyAttemptDateKeyString;

// Key for storing the symbol for a potty attempt.
extern NSString *GGKPottyAttemptSymbolStringKeyString;

// Key for storing whether a potty attempt was successful. Object is a BOOL stored as an NSNumber.
extern NSString *GGKPottyAttemptWasSuccessfulNumberKeyString;

// A star symbol. Used for showing number of successful attempts, and for donation thank-yous.
extern NSString *GGKStarRewardString;

// A star symbol. Used for successful attempts in v1.0.4 and earlier.
extern NSString *GGKStarSymbolString;

// An X symbol. Used for unsuccessful attempts.
extern NSString *GGKXSymbolString;

@interface GGKPerfectPottyModel : NSObject

// All children being tracked.
@property (strong, nonatomic) NSMutableArray *childrenMutableArray;

// Which color theme to use.
@property (strong, nonatomic) NSString *colorThemeString;

// Child the parent is currently tracking.
@property (strong, nonatomic) GGKChild *currentChild;

// Custom symbol to use, if any, for a new potty attempt.
@property (strong, nonatomic) NSString *currentCustomSymbol;

// For in-app donation. Not related to child rewards.
@property (assign, nonatomic) NSInteger numberOfStarsPurchasedInteger;

// The reminder is set using date components. I.e., time from the given date. 
@property (strong, nonatomic) NSDateComponents *reminderIncrementDateComponents;

// Create child with name. Add to database. Return child.
- (GGKChild *)addChildWithName:(NSString *)name;

// Override.
- (id)init;

// Save data for all children.
- (void)saveChildren;

- (void)saveColorTheme;

- (void)saveCurrentChildName;

- (void)saveCustomSymbol;

- (void)saveNumberOfStarsPurchased;

- (void)saveReminderInterval;

@end
