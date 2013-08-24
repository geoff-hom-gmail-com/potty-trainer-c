//
//  GGKPerfectPottyModel.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPerfectPottyModel.h"

#import "GGKReward.h"

// Key for storing data for all children.
NSString *GGKChildrenKeyString = @"Children data";

// Key for storing the most-recent custom symbol used.
NSString *GGKMostRecentCustomSymbolStringKeyString = @"Most-recent-custom-symbol string";

// Key for storing the number of stars purchased.
NSString *GGKNumberOfStarsPurchasedNumberKeyString = @"Number of stars purchased";

// Key for storing the number of minutes used for the previous reminder.
NSString *GGKReminderMinutesNumberKeyString = @"Reminder-minutes number";

@interface GGKPerfectPottyModel ()

// All children being tracked.
@property (strong, nonatomic) NSMutableArray *childrenMutableArray;

@end

@implementation GGKPerfectPottyModel

- (id)init
{
    self = [super init];
    if (self) {
        
        // get any saved data
        
        // Current custom symbol.
        NSString *aSymbolString = [[NSUserDefaults standardUserDefaults] stringForKey:GGKMostRecentCustomSymbolStringKeyString];
        if (aSymbolString != nil) {
            
            self.currentCustomSymbol = aSymbolString;
        }
        
        // Stars purchased.
        NSNumber *theNumberOfStarsPurchasedNumber = [[NSUserDefaults standardUserDefaults] objectForKey:GGKNumberOfStarsPurchasedNumberKeyString];
        if (theNumberOfStarsPurchasedNumber != nil) {
            
            self.numberOfStarsPurchasedInteger = [theNumberOfStarsPurchasedNumber integerValue];
        }
        
        // Minutes for reminder. If no previous reminder, use the default.
        NSDateComponents *theReminderIncrementDateComponents = [[NSDateComponents alloc] init];
        NSNumber *theNumberOfReminderMinutesNumber = [[NSUserDefaults standardUserDefaults] objectForKey:GGKReminderMinutesNumberKeyString];
        if (theNumberOfReminderMinutesNumber != nil) {
            
            NSInteger theNumberOfReminderMinutesInteger = [theNumberOfReminderMinutesNumber integerValue];
            [theReminderIncrementDateComponents setHour:theNumberOfReminderMinutesInteger / 60];
            [theReminderIncrementDateComponents setMinute:theNumberOfReminderMinutesInteger % 60];
        } else {
            
            [theReminderIncrementDateComponents setHour:1];
            [theReminderIncrementDateComponents setMinute:30];
        }
        self.reminderIncrementDateComponents = theReminderIncrementDateComponents;


        // Key for storing the name of the color theme to show.
        extern NSString *GGKThemeKeyString;

        
        // Get children data. If none, make a new child and also check for data from earlier versions.

        self.childrenMutableArray = [[NSUserDefaults standardUserDefaults] objectForKey:GGKChildrenKeyString];
        
        if (self.childrenMutableArray == nil) {
            
            GGKChild *aChild = [[GGKChild alloc] init];
            self.childrenMutableArray = [NSMutableArray arrayWithObject:aChild];
            
            // If the user upgrades from v1.1.0 or before, there won't be any children. The data will instead be under separate keys in the user defaults. We must retrieve that data, assemble that into a new child, save the child and remove the old data from the user defaults.
            
            // Potty attempts.
            
            NSString *aKeyString = @"Potty attempts";
            NSArray *aPottyAttemptDayArray = [[NSUserDefaults standardUserDefaults] objectForKey:aKeyString];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKeyString];
            if (aPottyAttemptDayArray != nil) {
                
                aChild.pottyAttemptDayArray = aPottyAttemptDayArray;
                
            }
            
            // Rewards.
            
            // Reward 1.
            
            GGKReward *aReward = aChild.rewardArray[0];
            
            aKeyString = @"Number of successes for reward 1";            
            NSNumber *theNumberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:aKeyString];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKeyString];
            if (theNumberOfSuccessesForRewardNumber != nil) {
                
                aReward.numberOfSuccessesNeededInteger = [theNumberOfSuccessesForRewardNumber integerValue];
            }
            
            // Whether reward 1 is text or an image.
            aKeyString = @"Reward-1-is-text BOOL number";
            NSNumber *theRewardIsTextBOOLNumber = [[NSUserDefaults standardUserDefaults] objectForKey:aKeyString];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKeyString];

            // The text for reward 1.
            aKeyString = @"Reward 1 text";
            NSString *theRewardString = [[NSUserDefaults standardUserDefaults] objectForKey:aKeyString];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKeyString];

            if ( theRewardIsTextBOOLNumber && (theRewardString != nil) ) {
                
                aReward.text = theRewardString;
            }
            
            // Reward 2.
            
            aReward = aChild.rewardArray[1];
            
            aKeyString = @"Number of successes for reward 2";
            theNumberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:aKeyString];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKeyString];
            if (theNumberOfSuccessesForRewardNumber != nil) {
                
                aReward.numberOfSuccessesNeededInteger = [theNumberOfSuccessesForRewardNumber integerValue];
            }
            
            // Whether reward 2 is text or an image.
            aKeyString = @"Reward-2-is-text BOOL number";
            theRewardIsTextBOOLNumber = [[NSUserDefaults standardUserDefaults] objectForKey:aKeyString];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKeyString];
            
            // The text for reward 2.
            aKeyString = @"Reward 2 text";
            theRewardString = [[NSUserDefaults standardUserDefaults] objectForKey:aKeyString];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKeyString];
            
            if ( theRewardIsTextBOOLNumber && (theRewardString != nil) ) {
                
                aReward.text = theRewardString;
            }
            
            // Reward 3.
            
            aReward = aChild.rewardArray[2];
            
            aKeyString = @"Number of successes for reward 3";
            theNumberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:aKeyString];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKeyString];
            if (theNumberOfSuccessesForRewardNumber != nil) {
                
                aReward.numberOfSuccessesNeededInteger = [theNumberOfSuccessesForRewardNumber integerValue];
            }
            
            // Whether reward 3 is text or an image.
            aKeyString = @"Reward-3-is-text BOOL number";
            theRewardIsTextBOOLNumber = [[NSUserDefaults standardUserDefaults] objectForKey:aKeyString];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKeyString];
            
            // The text for reward 3.
            aKeyString = @"Reward 3 text";
            theRewardString = [[NSUserDefaults standardUserDefaults] objectForKey:aKeyString];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKeyString];
            
            if ( theRewardIsTextBOOLNumber && (theRewardString != nil) ) {
                
                aReward.text = theRewardString;
            }

            
            
        }
        
    }
    return self;
}

@end
