//
//  GGKAddPottyViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAddPottyViewController.h"

#import "GGKSavedInfo.h"

@interface GGKAddPottyViewController ()

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

@end

@implementation GGKAddPottyViewController

- (IBAction)adjustSuccessfulness:(UISegmentedControl *)theSymbolSegmentedControl
{
    
    NSString *theCurrentSegmentTitleString = [theSymbolSegmentedControl titleForSegmentAtIndex:theSymbolSegmentedControl.selectedSegmentIndex];
    
    // Assuming segment 0 = YES, 1 = NO.
    if ([theCurrentSegmentTitleString isEqualToString:GGKXSymbolString]) {
        
        self.successfulSegmentedControl.selectedSegmentIndex = 1;
    } else {
        
        self.successfulSegmentedControl.selectedSegmentIndex = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)playButtonSound
{
    [self.soundModel playButtonTapSound];
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
    NSDictionary *thePottyAttemptDictionary = @{GGKPottyAttemptDateKeyString:thePottyAttemptDate, GGKPottyAttemptWasSuccessfulNumberKeyString:thePottyAttemptWasSuccessfulNumber};
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.soundModel = [[GGKSoundModel alloc] init];    
}

- (void)viewWillAppear:(BOOL)animated
{
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
