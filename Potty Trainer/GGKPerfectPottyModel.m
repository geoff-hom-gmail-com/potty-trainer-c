//
//  GGKPerfectPottyModel.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPerfectPottyModel.h"

#import "GGKReward.h"
#import "NSDate+GGKDate.h"

// Potty-record symbols.
NSString *GGKBothSymbolString = @"B";
NSString *GGKPeeSymbolString = @"P";
NSString *GGKPooSymbolString = @"💩";
NSString *GGKStarSymbolString = @"\u2605";
NSString *GGKXSymbolString = @"\u2718";

// Keys for saving data.
// Key for storing data for all children.
NSString *GGKChildrenKeyString = @"Children data";
// Key for storing ID of current child.
NSString *GGKCurrentChildIDNumberKeyString = @"Current child ID number";
// Key for storing the most-recent custom symbol used.
NSString *GGKMostRecentCustomSymbolStringKeyString = @"Most-recent-custom-symbol string";
// Key for storing the number of stars purchased.
NSString *GGKNumberOfStarsPurchasedNumberKeyString = @"Number of stars purchased";
NSString *GGKPottyAttemptDateKeyString = @"Potty-attempt date";
NSString *GGKPottyAttemptSymbolStringKeyString = @"Potty-attempt symbol string";
NSString *GGKPottyAttemptWasSuccessfulNumberKeyString = @"Potty-attempt-was-successful number";
// Key for storing the number of minutes used for the previous reminder.
NSString *GGKReminderMinutesNumberKeyString = @"Reminder-minutes number";
// Key for storing the name of the color theme to show.
NSString *GGKThemeKeyString = @"Theme";

NSString *GGKBoyThemeString = @"Boy theme";
NSString *GGKGirlThemeString = @"Girl theme";
NSString *GGKGiveDollarProductIDString = @"com.geoffhom.PerfectPotty.GiveADollar";
NSString *GGKReminderSoundPrefixString = @"reminder1-mono-s16K";
NSString *GGKStarRewardString = @"\u2b50";

@interface GGKPerfectPottyModel ()

// Create and return a child. If saved data from v1.1.0 or before, use that. Else, return a new child.
- (GGKChild *)childFromOldData;

// For the given child, fill in info for the given reward number using saved data from v1.1.0 or before. The reward number should be 1, 2 or 3.
- (void)populateRewardFromOldData:(GGKChild *)child rewardNumber:(NSInteger)rewardNumberInteger;

@end

@implementation GGKPerfectPottyModel

- (GGKChild *)addChildWithName:(NSString *)name
{
    NSInteger uniqueIDInteger = [self uniqueIDForNewChild];
    GGKChild *newChild = [[GGKChild alloc] initWithUniqueID:uniqueIDInteger];
    newChild.nameString = name;
    [self.childrenMutableArray addObject:newChild];
    
    // Alphabetize.
    NSSortDescriptor *aNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nameString" ascending:YES];
    NSArray *aSortedArray = [self.childrenMutableArray sortedArrayUsingDescriptors:@[aNameSortDescriptor]];
    self.childrenMutableArray = [aSortedArray mutableCopy];
    
    [self saveChildren];
    
    return newChild;
}
- (void)addPottyAttempt:(NSDictionary *)thePottyAttemptDictionary {
    // Add data. To find where to add the data, check previous attempts until we find the same date or a previous date (searching backward through the attempts). We search backward because the user is probably adding a recent attempt.
    // By default, add the attempt as a new date at the start of the array. (Works if there was no data before.)
    NSMutableArray *thePottyAttemptDayMutableArray = [self.currentChild.pottyAttemptDayArray mutableCopy];
    NSDate *thePottyAttemptDate = thePottyAttemptDictionary[GGKPottyAttemptDateKeyString];
    __block BOOL theAttemptDateIsNew = YES;
    __block NSInteger theIndexToInsertAttempt = 0;
    [thePottyAttemptDayMutableArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSArray *aPottyAttemptArray, NSUInteger idx, BOOL *stop) {
        NSDictionary *aPottyAttemptDictionary = aPottyAttemptArray[0];
        NSDate *aPottyAttemptDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
        NSComparisonResult aComparisonResult = [aPottyAttemptDate compareByDay:thePottyAttemptDate];
        if (aComparisonResult == NSOrderedSame) {
            theAttemptDateIsNew = NO;
            theIndexToInsertAttempt = idx;
            *stop = YES;
        } else if (aComparisonResult == NSOrderedAscending) {
            // Add after the current date.
            theIndexToInsertAttempt = idx + 1;
            *stop = YES;
        }
    }];
    // If the attempt is for a new date, then make a new array for that date and add the array. Else, add the attempt to the proper array.
    if (theAttemptDateIsNew) {
        [thePottyAttemptDayMutableArray insertObject:@[thePottyAttemptDictionary] atIndex:theIndexToInsertAttempt];
    } else {
        // Search forward until finding a later date (or the end). Insert the attempt there.
        NSArray *thePottyAttemptArray = thePottyAttemptDayMutableArray[theIndexToInsertAttempt];
        NSMutableArray *thePottyAttemptMutableArray = [thePottyAttemptArray mutableCopy];
        [thePottyAttemptArray enumerateObjectsUsingBlock:^(NSDictionary *aPottyAttemptDictionary, NSUInteger idx, BOOL *stop) {
            NSDate *aPottyAttemptDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
            NSComparisonResult aComparisonResult = [thePottyAttemptDate compare:aPottyAttemptDate];
            if (aComparisonResult == NSOrderedAscending) {
                [thePottyAttemptMutableArray insertObject:thePottyAttemptDictionary atIndex:idx];
                *stop = YES;
            } else if (idx == thePottyAttemptArray.count - 1) {
                [thePottyAttemptMutableArray addObject:thePottyAttemptDictionary];
            }
        }];
        [thePottyAttemptDayMutableArray replaceObjectAtIndex:theIndexToInsertAttempt withObject:[thePottyAttemptMutableArray copy]];
        
    }    
    self.currentChild.pottyAttemptDayArray = [thePottyAttemptDayMutableArray copy];
    self.currentChild.dayIndex = theIndexToInsertAttempt;
    [self saveChildren];
}
- (GGKChild *)childFromOldData
{
    // If the user upgrades from v1.1.0 or before, there won't be any children. The data will instead be under separate keys in the user defaults. We will assemble that data into a new child.
    
    NSInteger uniqueIDInteger = [self uniqueIDForNewChild];
    GGKChild *child = [[GGKChild alloc] initWithUniqueID:uniqueIDInteger];
    
    // Potty attempts (when tracking only one child).
    NSString *pottyAttemptsKeyString = @"Potty attempts";
    NSArray *pottyAttemptDayArray = [[NSUserDefaults standardUserDefaults] objectForKey:pottyAttemptsKeyString];
    if (pottyAttemptDayArray != nil) {
        
        child.pottyAttemptDayArray = pottyAttemptDayArray;
    }
    
    // Rewards.
    [self populateRewardFromOldData:child rewardNumber:1];
    [self populateRewardFromOldData:child rewardNumber:2];
    [self populateRewardFromOldData:child rewardNumber:3];
    
    // Delete old data.
    // The images were already moved, so the rest of this doesn't take much space. Will skip for now.
    
    return child;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        // Load saved data.
        
        // Current custom symbol.
        NSString *aSymbolString = [[NSUserDefaults standardUserDefaults] stringForKey:GGKMostRecentCustomSymbolStringKeyString];
        self.currentCustomSymbol = aSymbolString;
        
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
        
        // Children data. If none, import child data from earlier versions. If none, make a new child.
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:GGKChildrenKeyString];
        if (data == nil) {
            
            GGKChild *child = [self childFromOldData];
            self.childrenMutableArray = [NSMutableArray arrayWithObject:child];
            [self saveChildren];
        } else {
            
            self.childrenMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        
        // Current child.
        NSNumber *currentChildIDNumber = [[NSUserDefaults standardUserDefaults] objectForKey:GGKCurrentChildIDNumberKeyString];
        if (currentChildIDNumber == nil) {
            
            self.currentChild = self.childrenMutableArray[0];
            [self saveCurrentChildID];
        } else {
        
            // Find child with that ID.
            NSInteger currentChildIDInteger = [currentChildIDNumber integerValue];
            [self.childrenMutableArray enumerateObjectsUsingBlock:^(GGKChild *aChild, NSUInteger idx, BOOL *stop) {
                
                if (aChild.uniqueIDInteger == currentChildIDInteger) {
                    
                    self.currentChild = aChild;
                    *stop = YES;
                }
            }];
        }
    }
    return self;
}

- (void)populateRewardFromOldData:(GGKChild *)child rewardNumber:(NSInteger)rewardNumberInteger
{
    // Get reward from child. Get number of successes needed. If reward is text, get reward text and remove any image. Else, move the image.
    
    GGKReward *reward = child.rewardArray[rewardNumberInteger - 1];
    NSString *rewardNumberOfSuccessesNumberKeyString = [NSString stringWithFormat:@"Number of successes for reward %ld", (long)rewardNumberInteger];
    NSString *rewardIsTextBOOLNumberKeyString = [NSString stringWithFormat:@"Reward-%ld-is-text BOOL number", (long)rewardNumberInteger];
    NSString *rewardTextKeyString = [NSString stringWithFormat:@"Reward %ld text", (long)rewardNumberInteger];
    NSString *theSourceImagePathComponentString = [NSString stringWithFormat:@"/reward%ld.png", (long)rewardNumberInteger];
    NSString *theDestinationImagePathComponentString = [NSString stringWithFormat:@"/%@.png", reward.imageName];
    
    NSNumber *numberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:rewardNumberOfSuccessesNumberKeyString];
    if (numberOfSuccessesForRewardNumber != nil) {
        
        reward.numberOfSuccessesNeededInteger = [numberOfSuccessesForRewardNumber integerValue];
    }
    
    NSNumber *rewardIsTextBOOLNumber = [[NSUserDefaults standardUserDefaults] objectForKey:rewardIsTextBOOLNumberKeyString];
    BOOL rewardIsTextBOOL = [rewardIsTextBOOLNumber boolValue];
    NSString *rewardTextString = [[NSUserDefaults standardUserDefaults] objectForKey:rewardTextKeyString];
    NSFileManager *aFileManager = [[NSFileManager alloc] init];
    NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
    NSURL *theSourceFileURL = [aDirectoryURL URLByAppendingPathComponent:theSourceImagePathComponentString];
    if (rewardIsTextBOOL) {
        
        reward.text = rewardTextString;
        BOOL wasSuccessful = [aFileManager removeItemAtURL:theSourceFileURL error:nil];
        NSLog(@"PPM populateRewardFromOldData remove-image wasSuccessful: %@", wasSuccessful ? @"Yes" : @"No");
    } else {
        
        NSURL *theDestinationFileURL = [aDirectoryURL URLByAppendingPathComponent:theDestinationImagePathComponentString];
        BOOL wasSuccessful = [aFileManager moveItemAtURL:theSourceFileURL toURL:theDestinationFileURL error:nil];
        NSLog(@"PPM populateRewardFromOldData move-image wasSuccessful: %@", wasSuccessful ? @"Yes" : @"No");
    }
}
- (void)removePottyAttempt:(NSDictionary *)thePottyAttemptDictionary {
    __block NSInteger theDayIndex = 0;
    NSMutableArray *thePottyAttemptDayMutableArray = [self.currentChild.pottyAttemptDayArray mutableCopy];
    [thePottyAttemptDayMutableArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSArray *aPottyAttemptArray, NSUInteger idx, BOOL *stop) {
        NSUInteger theIndex = [aPottyAttemptArray indexOfObject:thePottyAttemptDictionary];
        if (theIndex != NSNotFound) {
//            NSLog(@"found the attempt to remove!");
            theDayIndex = idx;
            *stop = YES;
        }
    }];
    NSArray *thePottyAttemptArray = thePottyAttemptDayMutableArray[theDayIndex];
    NSMutableArray *thePottyAttemptMutableArray = [thePottyAttemptArray mutableCopy];
    [thePottyAttemptMutableArray removeObject:thePottyAttemptDictionary];
    // If no more attempts for that day, remove it. Else, replace with the updated day.
    if ([thePottyAttemptMutableArray count] == 0) {
        [thePottyAttemptDayMutableArray removeObjectAtIndex:theDayIndex];
    } else {
        [thePottyAttemptDayMutableArray replaceObjectAtIndex:theDayIndex withObject:[thePottyAttemptMutableArray copy]];
    }
    self.currentChild.pottyAttemptDayArray = [thePottyAttemptDayMutableArray copy];
    [self saveChildren];
}
- (void)replacePottyAttempt:(NSDictionary *)theFirstPottyAttemptDictionary withAttempt:(NSDictionary *)theSecondPottyAttemptDictionary {
    [self removePottyAttempt:theFirstPottyAttemptDictionary];
    [self addPottyAttempt:theSecondPottyAttemptDictionary];
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

- (void)saveCurrentChildID
{
    NSNumber *currentChildIDNumber = [NSNumber numberWithInteger:self.currentChild.uniqueIDInteger];
    [[NSUserDefaults standardUserDefaults] setObject:currentChildIDNumber forKey:GGKCurrentChildIDNumberKeyString];
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

- (NSInteger)uniqueIDForNewChild
{
    // Return the first non-negative integer that isn't being used.
    // If there are currently X children, then some number from 0 to X must be unused.
    NSInteger uniqueIDInteger = -1;
    for (int i1 = 0; i1 < [self.childrenMutableArray count] + 1; i1++) {
        
        __block BOOL i1IsUsed = NO;
        [self.childrenMutableArray enumerateObjectsUsingBlock:^(GGKChild *aChild, NSUInteger idx, BOOL *stop) {
            
            if (aChild.uniqueIDInteger == i1) {
                
                i1IsUsed = YES;
                *stop = YES;
            }
        }];
        if (!i1IsUsed) {
            
            uniqueIDInteger = i1;
            break;
        }
    }
    return uniqueIDInteger;
}

@end
