//
//  GGKSetReminderViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/27/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKSetReminderViewController.h"

#import "GGKPerfectPottyAppDelegate.h"
#import "GGKSavedInfo.h"
#import "NSDate+GGKDate.h"

NSString *GGKReminderWhenPrefixString = @"Remind me at";

NSString *GGKReminderWhenSuffixString = @"which is in:";

@interface GGKSetReminderViewController ()

// For updating the reminder time every minute.
@property (strong, nonatomic) NSTimer *timer;

// Calculate and return the date for the reminder, based on the date picker.
- (NSDate *)reminderDate;

// If time passes while this view is visible, then we need to update the reminder time each minute.
- (void)startUpdateTimer;

// Start updates that occur only while in foreground. E.g., a timer that updates the view. Listen for when the app enters the background.
- (void)startVisibleUpdates;

// Make sure the timer doesn't fire anymore.
- (void)stopTimer;

// Stop anything from -startVisibleUpdates.
- (void)stopVisibleUpdates;

// Show the current reminder time, based on the interval on the date picker.
- (void)updateReminderTime;

@end

@implementation GGKSetReminderViewController

- (IBAction)datePickerTimeChanged:(id)sender
{
    [self updateReminderTime];
}

- (NSDate *)reminderDate
{
    // Get the hour and minute in the date picker. Add to the current time.
    
    NSDate *theReminderIncrementDate = self.datePicker.date;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit aCalendarUnit = NSMinuteCalendarUnit | NSHourCalendarUnit;
    NSDateComponents *theReminderIncrementDateComponents = [gregorianCalendar components:aCalendarUnit fromDate:theReminderIncrementDate];
    
    NSDate *theNowDate = [NSDate date];
    NSDate *theReminderDate = [gregorianCalendar dateByAddingComponents:theReminderIncrementDateComponents toDate:theNowDate options:0];
    return theReminderDate;
}

- (IBAction)setReminder
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *aLocalNotification = [[UILocalNotification alloc] init];
    
    NSDate *theReminderDate = [self reminderDate];

    aLocalNotification.fireDate = theReminderDate;
    aLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
    aLocalNotification.alertBody = @"Potty time? (Wash hands.)";
    aLocalNotification.soundName = GGKReminderSoundFilenameString;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:aLocalNotification];
    
    // Save reminder interval.
    NSDate *theReminderIncrementDate = self.datePicker.date;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit aCalendarUnit = NSMinuteCalendarUnit | NSHourCalendarUnit;
    NSDateComponents *theReminderIncrementDateComponents = [gregorianCalendar components:aCalendarUnit fromDate:theReminderIncrementDate];
    self.perfectPottyModel.reminderIncrementDateComponents = theReminderIncrementDateComponents;
    [self.perfectPottyModel saveReminderInterval];
    
    [self.delegate setReminderViewControllerDidSetReminder:self];
}

- (void)startUpdateTimer
{
    // First, get the number of seconds until the minute changes. Add 1 second to compensate for rounding errors. (Better to fire timer later than sooner.)
    NSDate *aNowDate = [NSDate date];
    NSCalendarUnit aSecondCalendarUnit = NSSecondCalendarUnit;
    NSCalendar *aGregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *aSecondsNowDateComponents = [aGregorianCalendar components:aSecondCalendarUnit fromDate:aNowDate];
    NSInteger theNumberOfSecondsUntilNextMinuteInteger = 60 - aSecondsNowDateComponents.second + 1;
    
    // Wait that number of seconds. Then fire a timer every 60 seconds to update the reminder time.
    NSDate *theFireDate = [NSDate dateWithTimeIntervalSinceNow:theNumberOfSecondsUntilNextMinuteInteger];
//    NSLog(@"SRVC fireDate:%@", [theFireDate description]);
    NSTimer *aTimer = [[NSTimer alloc] initWithFireDate:theFireDate interval:60.0 target:self selector:@selector(updateReminderTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSDefaultRunLoopMode];
    
    self.timer = aTimer;
//    NSLog(@"timer started");
}

- (void)startVisibleUpdates
{
    [self startUpdateTimer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVisibleUpdates) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)stopVisibleUpdates
{
    [self stopTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)updateReminderTime
{
//    NSLog(@"SRVC updateReminderTime");
    NSDate *theReminderDate = [self reminderDate];
    NSString *theReminderDateString = [theReminderDate hourMinuteAMPMString];
    self.whenLabel.text = [NSString stringWithFormat:@"%@ %@, %@", GGKReminderWhenPrefixString, theReminderDateString, GGKReminderWhenSuffixString];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSCalendar *aGregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Set the date picker to the last increment used.
    NSDate *theReminderIncrementDate = [aGregorianCalendar dateFromComponents:self.perfectPottyModel.reminderIncrementDateComponents];
    self.datePicker.date = theReminderIncrementDate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateReminderTime];
    [self startVisibleUpdates];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopVisibleUpdates];
}

@end
