//
//  GGKAddPottyViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAddPottyViewController.h"

#import "NSDate+GGKDate.h"

@interface GGKAddPottyViewController ()

- (void)handleSymbolSegmentedControlTapped;
// So, play the button sound. Adjust successfulness. If it was the last segment, let the user choose a custom symbol.

@end

@implementation GGKAddPottyViewController

- (void)handleSymbolSegmentedControlTapped
{
    [self playButtonSound];

    // Adjust successfulness.
    
    NSInteger theSelectedSegmentIndex = self.symbolSegmentedControl.selectedSegmentIndex;
    NSString *theCurrentSegmentTitleString = [self.symbolSegmentedControl titleForSegmentAtIndex:theSelectedSegmentIndex];
    
    // Assuming segment 0 = YES, 1 = NO.
    if ([theCurrentSegmentTitleString isEqualToString:GGKXSymbolString]) {
        
        self.successfulSegmentedControl.selectedSegmentIndex = 1;
    } else {
        
        self.successfulSegmentedControl.selectedSegmentIndex = 0;
    }
    
    // If the custom symbol was tapped, then show the view for entering a custom symbol.
    if (theSelectedSegmentIndex == 4) {
        
        [self performSegueWithIdentifier:@"ShowUseCustomSymbolView" sender:self];
    }
}
- (void)handleViewWillAppearToUser {
    [super handleViewWillAppearToUser];
}
- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender
{
    if ([theSegue.identifier hasPrefix:@"ShowUseCustomSymbolView"]) {
        
        GGKUseCustomSymbolViewController *aUseCustomSymbolViewController = [(UIStoryboardSegue *)theSegue destinationViewController];
        aUseCustomSymbolViewController.delegate = self;
    } else {
        
        [super prepareForSegue:theSegue sender:theSender];
    }
}

- (IBAction)savePottyAttempt
{
    // Get new data.
    BOOL thePottyAttemptWasSuccessfulBOOL = NO;
    if (self.successfulSegmentedControl.selectedSegmentIndex == 0) {
        
        thePottyAttemptWasSuccessfulBOOL = YES;
    };
    NSDate *thePottyAttemptDate = self.datePicker.date;
    NSNumber *thePottyAttemptWasSuccessfulNumber = [NSNumber numberWithBool:thePottyAttemptWasSuccessfulBOOL];
    
    // Version without custom symbols.
//    NSDictionary *thePottyAttemptDictionary = @{GGKPottyAttemptDateKeyString:thePottyAttemptDate, GGKPottyAttemptWasSuccessfulNumberKeyString:thePottyAttemptWasSuccessfulNumber};
    
    // Get the selected symbol.
    NSString *thePottyAttemptSymbolString;
    NSInteger theSelectedSegmentIndex = self.symbolSegmentedControl.selectedSegmentIndex;
    // Instead of "(p)ee" it's "p" and instead of "(B)oth" it's "B."
    switch (theSelectedSegmentIndex) {
        case 0:
            thePottyAttemptSymbolString = @"p";
            break;
        case 2:
            thePottyAttemptSymbolString = @"B";
            break;
        default:
            thePottyAttemptSymbolString = [self.symbolSegmentedControl titleForSegmentAtIndex:theSelectedSegmentIndex];
            break;
    }
    NSDictionary *thePottyAttemptDictionary = @{GGKPottyAttemptDateKeyString:thePottyAttemptDate, GGKPottyAttemptWasSuccessfulNumberKeyString:thePottyAttemptWasSuccessfulNumber, GGKPottyAttemptSymbolStringKeyString:thePottyAttemptSymbolString};
    
    // The model should handle the stuff below.
    if (self.pottyAttemptToEditDictionary == nil) {
        [self.perfectPottyModel addPottyAttempt:thePottyAttemptDictionary];
    } else {
        [self.perfectPottyModel replacePottyAttempt:self.pottyAttemptToEditDictionary withAttempt:thePottyAttemptDictionary];
        self.pottyAttemptToEditDictionary = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];

//    // Get saved data.
//    NSArray *thePottyAttemptDayArray = self.perfectPottyModel.currentChild.pottyAttemptDayArray;
//    
//    // Add data. To find where to add the data, check previous attempts until we find the same date or a previous date (searching backward through the attempts). We search backward because the user is probably adding a recent attempt.
//    
//    // By default, add the attempt as a new date at the start of the array. (Works if there was no data before.)
//    __block BOOL theAttemptDateIsNew = YES;
//    __block NSInteger theIndexToInsertAttempt = 0;
//    
//    [thePottyAttemptDayArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSArray *aPottyAttemptArray, NSUInteger idx, BOOL *stop) {
//        
//        NSDictionary *aPottyAttemptDictionary = aPottyAttemptArray[0];
//        NSDate *aPottyAttemptDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
//        
//        NSComparisonResult aComparisonResult = [aPottyAttemptDate compareByDay:thePottyAttemptDate];
//        if (aComparisonResult == NSOrderedSame) {
//            
//            theAttemptDateIsNew = NO;
//            theIndexToInsertAttempt = idx;
//            *stop = YES;
//        } else if (aComparisonResult == NSOrderedAscending) {
//            
//            // Add after the current date.
//            theIndexToInsertAttempt = idx + 1;
//            *stop = YES;
//        }
//    }];
//    
//    // If the attempt is for a new date, then make a new array for that date and add the array. Else, add the attempt to the proper array.
//    
//    NSMutableArray *thePottyAttemptDayMutableArray = [thePottyAttemptDayArray mutableCopy];
//    if (theAttemptDateIsNew) {
//        
//        [thePottyAttemptDayMutableArray insertObject:@[thePottyAttemptDictionary] atIndex:theIndexToInsertAttempt];
//    } else {
//        
//        NSArray *thePottyAttemptArray = thePottyAttemptDayArray[theIndexToInsertAttempt];
//        
//        // Search forward until finding a later date (or the end). Insert the attempt there.
//        
//        NSMutableArray *thePottyAttemptMutableArray = [thePottyAttemptArray mutableCopy];
//        [thePottyAttemptArray enumerateObjectsUsingBlock:^(NSDictionary *aPottyAttemptDictionary, NSUInteger idx, BOOL *stop) {
//            
//            NSDate *aPottyAttemptDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
//            NSComparisonResult aComparisonResult = [thePottyAttemptDate compare:aPottyAttemptDate];
//            if (aComparisonResult == NSOrderedAscending) {
//                
//                [thePottyAttemptMutableArray insertObject:thePottyAttemptDictionary atIndex:idx];
//                *stop = YES;
//            } else if (idx == thePottyAttemptArray.count - 1) {
//                
//                [thePottyAttemptMutableArray addObject:thePottyAttemptDictionary];
//            }
//        }];
//        
//        [thePottyAttemptDayMutableArray replaceObjectAtIndex:theIndexToInsertAttempt withObject:[thePottyAttemptMutableArray copy]];
//        
//    }
//    thePottyAttemptDayArray = [thePottyAttemptDayMutableArray copy];
    
//    // If editing a potty attempt, we've added the new version, so remove the old version.
//    if (self.pottyAttemptToEditDictionary != nil) {
//        __block NSInteger theDayIndex = 0;
//        [thePottyAttemptDayArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSArray *aPottyAttemptArray, NSUInteger idx, BOOL *stop) {
//            NSUInteger theIndex = [aPottyAttemptArray indexOfObject:self.pottyAttemptToEditDictionary];
//            if (theIndex != NSNotFound) {
//                NSLog(@"found the attempt to remove!");
//                theDayIndex = idx;
//                *stop = YES;
//            }
//        }];
//        NSArray *thePottyAttemptArray = thePottyAttemptDayArray[theDayIndex];
//        NSMutableArray *thePottyAttemptMutableArray = [thePottyAttemptArray mutableCopy];
//        [thePottyAttemptMutableArray removeObject:self.pottyAttemptToEditDictionary];
//        [thePottyAttemptDayMutableArray replaceObjectAtIndex:theDayIndex withObject:[thePottyAttemptMutableArray copy]];
//        thePottyAttemptDayArray = [thePottyAttemptDayMutableArray copy];
//    }
//    
//    // Save data and return.
//    self.perfectPottyModel.currentChild.pottyAttemptDayArray = thePottyAttemptDayArray;
//    [self.perfectPottyModel saveChildren];
//    self.pottyAttemptToEditDictionary = nil;
//    self.perfectPottyModel.currentPottyAttemptDictionary = thePottyAttemptDictionary;
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)useCustomSymbolViewControllerDidChooseSymbol:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    // Show symbol on segmented control.
    NSString *theMostRecentCustomSymbolString = self.perfectPottyModel.currentCustomSymbol;
    [self.symbolSegmentedControl setTitle:theMostRecentCustomSymbolString forSegmentAtIndex:4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.symbolSegmentedControl.apportionsSegmentWidthsByContent = YES;
    // Listen for taps on the symbol segmented control. We do this (instead of using the value-changed event) in case the user taps the same segment twice (e.g., the custom segment, to change the symbol).
    UITapGestureRecognizer *aTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSymbolSegmentedControlTapped)];
    [self.symbolSegmentedControl addGestureRecognizer:aTapGestureRecognizer];
    // Set the date picker not to allow future days.
    NSDate *aTodayDate = [NSDate date];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *aDateComponents = [gregorianCalendar components:unitFlags fromDate:aTodayDate];
    [aDateComponents setHour:23];
    [aDateComponents setMinute:59];
    NSDate *anEndOfTodayDate = [gregorianCalendar dateFromComponents:aDateComponents];
    self.datePicker.maximumDate = anEndOfTodayDate;
    // If editing a potty attempt, prepopulate the fields.
    if (self.pottyAttemptToEditDictionary != nil) {
        // Symbol.
        NSInteger theSelectedSegmentIndex;
        NSString *theSymbolString = self.pottyAttemptToEditDictionary[GGKPottyAttemptSymbolStringKeyString];
        if ([theSymbolString isEqualToString:@"p"]) {
            theSelectedSegmentIndex = 0;
        } else if ([theSymbolString isEqualToString:GGKPooSymbolString]) {
            theSelectedSegmentIndex = 1;
        } else if ([theSymbolString isEqualToString:@"B"]) {
            theSelectedSegmentIndex = 2;
        } else if ([theSymbolString isEqualToString:GGKXSymbolString]) {
            theSelectedSegmentIndex = 3;
        } else {
            theSelectedSegmentIndex = 4;
            [self.symbolSegmentedControl setTitle:theSymbolString forSegmentAtIndex:4];
            self.perfectPottyModel.currentCustomSymbol = theSymbolString;
        }
        self.symbolSegmentedControl.selectedSegmentIndex = theSelectedSegmentIndex;
        // Successfulness.
        NSNumber *theAttemptWasSuccessfulBOOLNumber = self.pottyAttemptToEditDictionary[GGKPottyAttemptWasSuccessfulNumberKeyString];
        BOOL theAttemptWasSuccessfulBOOL = [theAttemptWasSuccessfulBOOLNumber boolValue];
        if (theAttemptWasSuccessfulBOOL) {
            theSelectedSegmentIndex = 0;
        } else {
            theSelectedSegmentIndex = 1;
        }
        self.successfulSegmentedControl.selectedSegmentIndex = theSelectedSegmentIndex;
        // Date.
        NSDate *thePottyAttemptDate = self.pottyAttemptToEditDictionary[GGKPottyAttemptDateKeyString];
        self.datePicker.date = thePottyAttemptDate;
    }
}
@end
