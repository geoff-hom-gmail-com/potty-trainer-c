//
//  GGKPerfectPottyModel.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPerfectPottyModel.h"

#import "GGKReward.h"

NSString *GGKBoyThemeString = @"Boy theme";

// Key for storing data for all children.
NSString *GGKChildrenKeyString = @"Children data";

NSString *GGKCurrentChildNameKeyString = @"Current child";

NSString *GGKGirlThemeString = @"Girl theme";

NSString *GGKGiveDollarProductIDString = @"com.geoffhom.PerfectPotty.GiveADollar";

// Key for storing the most-recent custom symbol used.
NSString *GGKMostRecentCustomSymbolStringKeyString = @"Most-recent-custom-symbol string";

// Key for storing the number of stars purchased.
NSString *GGKNumberOfStarsPurchasedNumberKeyString = @"Number of stars purchased";

NSString *GGKPottyAttemptDateKeyString = @"Potty-attempt date";

NSString *GGKPottyAttemptSymbolStringKeyString = @"Potty-attempt symbol string";

NSString *GGKPottyAttemptWasSuccessfulNumberKeyString = @"Potty-attempt-was-successful number";

// Key for storing the number of minutes used for the previous reminder.
NSString *GGKReminderMinutesNumberKeyString = @"Reminder-minutes number";

NSString *GGKStarRewardString = @"\u2b50";

NSString *GGKStarSymbolString = @"\u2605";

// Key for storing the name of the color theme to show.
NSString *GGKThemeKeyString = @"Theme";

NSString *GGKXSymbolString = @"\u2718";

@interface GGKPerfectPottyModel ()

@end

@implementation GGKPerfectPottyModel

- (GGKChild *)addChildWithName:(NSString *)name
{
    GGKChild *newChild = [[GGKChild alloc] init];
    newChild.nameString = name;
    [self.childrenMutableArray addObject:newChild];
    
    // Alphabetize.
    NSSortDescriptor *aNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nameString" ascending:YES];
    NSArray *aSortedArray = [self.childrenMutableArray sortedArrayUsingDescriptors:@[aNameSortDescriptor]];
    self.childrenMutableArray = [aSortedArray mutableCopy];
    
    return newChild;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        // Load saved data.
        
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

        // Color theme.
        self.colorThemeString = [[NSUserDefaults standardUserDefaults] objectForKey:GGKThemeKeyString];
        
        // Children data. If none, make a new child and also check for data from earlier versions.

        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:GGKChildrenKeyString];
        if (data != nil) {
            
            self.childrenMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        if (self.childrenMutableArray == nil) {
            
            GGKChild *aChild = [[GGKChild alloc] init];
            self.childrenMutableArray = [NSMutableArray arrayWithObject:aChild];
            
            // If the user upgrades from v1.1.0 or before, there won't be any children. The data will instead be under separate keys in the user defaults. We must retrieve that data, assemble that into a new child, save the child and remove the old data from the user defaults.
            
            NSString *pottyAttemptsKeyString = @"Potty attempts";
            NSString *reward1NumberOfSuccessesNumberKeyString = @"Number of successes for reward 1";
            NSString *reward2NumberOfSuccessesNumberKeyString = @"Number of successes for reward 2";
            NSString *reward3NumberOfSuccessesNumberKeyString = @"Number of successes for reward 3";
            
            // Whether reward is text or an image.
            NSString *reward1IsTextBOOLNumberKeyString = @"Reward-1-is-text BOOL number";
            NSString *reward2IsTextBOOLNumberKeyString = @"Reward-2-is-text BOOL number";
            NSString *reward3IsTextBOOLNumberKeyString = @"Reward-3-is-text BOOL number";
            
            // Text for the reward.
            NSString *reward1TextKeyString = @"Reward 1 text";
            NSString *reward2TextKeyString = @"Reward 2 text";
            NSString *reward3TextKeyString = @"Reward 3 text";
            
            // Potty attempts (when tracking only one child).
            NSArray *pottyAttemptDayArray = [[NSUserDefaults standardUserDefaults] objectForKey:pottyAttemptsKeyString];
            if (pottyAttemptDayArray != nil) {
                
                aChild.pottyAttemptDayArray = pottyAttemptDayArray;
            }
            
            // Reward 1.
            
            GGKReward *reward = aChild.rewardArray[0];
            NSNumber *numberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:reward1NumberOfSuccessesNumberKeyString];
            if (numberOfSuccessesForRewardNumber != nil) {
                
                reward.numberOfSuccessesNeededInteger = [numberOfSuccessesForRewardNumber integerValue];
            }
            
            // If text, and if reward text there, use that. If not text, move the image.
            NSNumber *rewardIsTextBOOLNumber = [[NSUserDefaults standardUserDefaults] objectForKey:reward1IsTextBOOLNumberKeyString];
            BOOL rewardIsTextBOOL = [rewardIsTextBOOLNumber boolValue];
            NSString *rewardTextString = [[NSUserDefaults standardUserDefaults] objectForKey:reward1TextKeyString];
            if (rewardIsTextBOOL) {
                
                if (rewardTextString != nil) {
                                    
                    reward.text = rewardTextString;
                }
            } else {
                
                NSFileManager *aFileManager = [[NSFileManager alloc] init];
                NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
                NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
                NSString *theSourceImagePathComponentString = @"/reward1.png";
                NSURL *theSourceFileURL = [aDirectoryURL URLByAppendingPathComponent:theSourceImagePathComponentString];
                NSString *theDestinationImagePathComponentString = [NSString stringWithFormat:@"/%@.png", reward.imageName];
                NSURL *theDestinationFileURL = [aDirectoryURL URLByAppendingPathComponent:theDestinationImagePathComponentString];
                BOOL wasSuccessful = [aFileManager moveItemAtURL:theSourceFileURL toURL:theDestinationFileURL error:nil];
                NSLog(@"wasSuccessful: %@", wasSuccessful ? @"Yes" : @"No");
            }
            
            // Reward 2.
            
            reward = aChild.rewardArray[1];
            numberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:reward2NumberOfSuccessesNumberKeyString];
            if (numberOfSuccessesForRewardNumber != nil) {
                
                reward.numberOfSuccessesNeededInteger = [numberOfSuccessesForRewardNumber integerValue];
            }
            
            // If text, and if reward text there, use that. If not text, move the image.
            rewardIsTextBOOLNumber = [[NSUserDefaults standardUserDefaults] objectForKey:reward2IsTextBOOLNumberKeyString];
            rewardIsTextBOOL = [rewardIsTextBOOLNumber boolValue];
            rewardTextString = [[NSUserDefaults standardUserDefaults] objectForKey:reward2TextKeyString];
            if (rewardIsTextBOOL) {
                
                if (rewardTextString != nil) {
                    
                    reward.text = rewardTextString;
                }
            } else {
                
                NSFileManager *aFileManager = [[NSFileManager alloc] init];
                NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
                NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
                NSString *theSourceImagePathComponentString = @"/reward2.png";
                NSURL *theSourceFileURL = [aDirectoryURL URLByAppendingPathComponent:theSourceImagePathComponentString];
                NSString *theDestinationImagePathComponentString = [NSString stringWithFormat:@"/%@.png", reward.imageName];
                NSURL *theDestinationFileURL = [aDirectoryURL URLByAppendingPathComponent:theDestinationImagePathComponentString];
                [aFileManager moveItemAtURL:theSourceFileURL toURL:theDestinationFileURL error:nil];
            }
            
            // Reward 3.
            
            reward = aChild.rewardArray[2];
            numberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:reward3NumberOfSuccessesNumberKeyString];
            if (numberOfSuccessesForRewardNumber != nil) {
                
                reward.numberOfSuccessesNeededInteger = [numberOfSuccessesForRewardNumber integerValue];
            }
            
            // If text, and if reward text there, use that. If not text, move the image.
            rewardIsTextBOOLNumber = [[NSUserDefaults standardUserDefaults] objectForKey:reward3IsTextBOOLNumberKeyString];
            rewardIsTextBOOL = [rewardIsTextBOOLNumber boolValue];
            rewardTextString = [[NSUserDefaults standardUserDefaults] objectForKey:reward3TextKeyString];
            if (rewardIsTextBOOL) {
                
                if (rewardTextString != nil) {
                    
                    reward.text = rewardTextString;
                }
            } else {
                
                NSFileManager *aFileManager = [[NSFileManager alloc] init];
                NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
                NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
                NSString *theSourceImagePathComponentString = @"/reward3.png";
                NSURL *theSourceFileURL = [aDirectoryURL URLByAppendingPathComponent:theSourceImagePathComponentString];
                NSString *theDestinationImagePathComponentString = [NSString stringWithFormat:@"/%@.png", reward.imageName];
                NSURL *theDestinationFileURL = [aDirectoryURL URLByAppendingPathComponent:theDestinationImagePathComponentString];
                [aFileManager moveItemAtURL:theSourceFileURL toURL:theDestinationFileURL error:nil];
            }

            // Save data.
            [self saveChildren];
            
            // Delete old data.
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:pottyAttemptsKeyString];
             
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:reward1NumberOfSuccessesNumberKeyString];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:reward1IsTextBOOLNumberKeyString];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:reward1TextKeyString];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:reward2NumberOfSuccessesNumberKeyString];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:reward2IsTextBOOLNumberKeyString];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:reward2TextKeyString];

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:reward3NumberOfSuccessesNumberKeyString];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:reward3IsTextBOOLNumberKeyString];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:reward3TextKeyString];
        }
        
        // Current child.
        NSString *currentChildName = [[NSUserDefaults standardUserDefaults] objectForKey:GGKCurrentChildNameKeyString];
        if (currentChildName == nil) {
            
            self.currentChild = self.childrenMutableArray[0];
        } else {
            
            // Find child with that name.
            [self.childrenMutableArray enumerateObjectsUsingBlock:^(GGKChild *aChild, NSUInteger idx, BOOL *stop) {
                
                if ([aChild.nameString isEqualToString:currentChildName]) {
                    
                    self.currentChild = aChild;
                    *stop = YES;
                }
            }];
        }
    }
    return self;
}

- (void)saveChildren
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.childrenMutableArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:GGKChildrenKeyString];
}

- (void)saveColorTheme
{
    [[NSUserDefaults standardUserDefaults] setObject:self.colorThemeString forKey:GGKThemeKeyString];
}

- (void)saveCurrentChildName
{
    [[NSUserDefaults standardUserDefaults] setObject:self.currentChild.nameString forKey:GGKCurrentChildNameKeyString];
}

- (void)saveCustomSymbol
{
    [[NSUserDefaults standardUserDefaults] setObject:self.currentCustomSymbol forKey:GGKMostRecentCustomSymbolStringKeyString];
}

- (void)saveNumberOfStarsPurchased
{
    NSNumber *theNumberOfStarsPurchasedNumber = [NSNumber numberWithInteger:self.numberOfStarsPurchasedInteger];
    [[NSUserDefaults standardUserDefaults] setObject:theNumberOfStarsPurchasedNumber forKey:GGKNumberOfStarsPurchasedNumberKeyString];
}

- (void)saveReminderInterval
{
    NSInteger theNumberOfReminderMinutesInteger = (self.reminderIncrementDateComponents.hour * 60) + self.reminderIncrementDateComponents.minute;
    NSNumber *theNumberOfReminderMinutesNumber = [NSNumber numberWithInteger:theNumberOfReminderMinutesInteger];
    [[NSUserDefaults standardUserDefaults] setObject:theNumberOfReminderMinutesNumber forKey:GGKReminderMinutesNumberKeyString];
}

@end
