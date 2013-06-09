//
//  GGKAddPottyViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAddPottyViewController.h"

#import "GGKSavedInfo.h"
#import "NSDate+GGKDate.h"

@interface GGKAddPottyViewController ()

- (void)handleSymbolSegmentedControlTapped;
// So, play the button sound. Adjust successfulness. If it was the last segment, let the user choose a custom symbol.

@end

@implementation GGKAddPottyViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    NSString *thePottyAttemptSymbolString = [self.symbolSegmentedControl titleForSegmentAtIndex:self.symbolSegmentedControl.selectedSegmentIndex];
    NSDictionary *thePottyAttemptDictionary = @{GGKPottyAttemptDateKeyString:thePottyAttemptDate, GGKPottyAttemptWasSuccessfulNumberKeyString:thePottyAttemptWasSuccessfulNumber, GGKPottyAttemptSymbolStringKeyString:thePottyAttemptSymbolString};

    // Get saved data.
    NSArray *thePottyAttemptDayArray = [[NSUserDefaults standardUserDefaults] objectForKey:GGKPottyAttemptsKeyString];
    if (thePottyAttemptDayArray == nil) {
        
        thePottyAttemptDayArray = [NSArray array];
    }
    
    // Add data. To find where to add the data, check previous attempts until we find the same date or a previous date (searching backward through the attempts). We search backward because the user is probably adding a recent attempt.
    
    // By default, add the attempt as a new date at the start of the array. (Works if there was no data before.)
    __block BOOL theAttemptDateIsNew = YES;
    __block NSInteger theIndexToInsertAttempt = 0;
    
    [thePottyAttemptDayArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSArray *aPottyAttemptArray, NSUInteger idx, BOOL *stop) {
        
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
    
    NSMutableArray *thePottyAttemptDayMutableArray = [thePottyAttemptDayArray mutableCopy];
    if (theAttemptDateIsNew) {
        
        [thePottyAttemptDayMutableArray insertObject:@[thePottyAttemptDictionary] atIndex:theIndexToInsertAttempt];
    } else {
        
        NSArray *thePottyAttemptArray = thePottyAttemptDayArray[theIndexToInsertAttempt];
        
        // Search forward until finding a later date (or the end). Insert the attempt there.
        
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
    thePottyAttemptDayArray = [thePottyAttemptDayMutableArray copy];
    
    // Save data and notify.
    [[NSUserDefaults standardUserDefaults] setObject:thePottyAttemptDayArray forKey:GGKPottyAttemptsKeyString];
    [self.delegate addPottyViewControllerDidAddPottyAttempt:self];
}

- (void)useCustomSymbolViewControllerDidChooseSymbol:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    // Show symbol on segmented control.
    NSString *theMostRecentCustomSymbolString = [[NSUserDefaults standardUserDefaults] stringForKey:GGKMostRecentCustomSymbolStringKeyString];
    [self.symbolSegmentedControl setTitle:theMostRecentCustomSymbolString forSegmentAtIndex:4];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Listen for taps on the symbol segmented control. We do this (instead of using the value-changed event) in case the user taps the same segment twice (e.g., the custom segment, to change the symbol).
    UITapGestureRecognizer *aTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSymbolSegmentedControlTapped)];
    [self.symbolSegmentedControl addGestureRecognizer:aTapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Set the date picker to allow only dates up to 11:59 PM today.
    NSDate *aTodayDate = [NSDate date];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *aDateComponents = [gregorianCalendar components:unitFlags fromDate:aTodayDate];
    [aDateComponents setHour:23];
    [aDateComponents setMinute:59];
    NSDate *anEndOfTodayDate = [gregorianCalendar dateFromComponents:aDateComponents];
    self.datePicker.maximumDate = anEndOfTodayDate;
}

@end
