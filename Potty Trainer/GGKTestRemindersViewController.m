//
//  GGKTestRemindersViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/30/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKTestRemindersViewController.h"

#import "NSDate+GGKDate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface GGKTestRemindersViewController ()

// The test reminder.
@property (strong, nonatomic) UILocalNotification *localNotification;

// For updating the view at regular intervals.
@property (strong, nonatomic) NSTimer *timer;

// Check if there's a reminder. If so, report on it. Else, stop the timer that checks.
- (void)checkReminderAndUpdate;

// Start a timer to update this view at regular intervals.
- (void)startUpdateTimer;

// Start updates that occur only while this view is visible to the user. E.g., a timer that updates the view. Listen for when the app enters the background.
- (void)startVisibleUpdates;

// Make sure the timer doesn't fire anymore.
- (void)stopTimer;

// Stop anything from -startVisibleUpdates.
- (void)stopVisibleUpdates;

// Update UI for a reminder existing.
- (void)updateForAReminder;

// Update UI for no reminder set yet.
- (void)updateForNoReminder;

@end

@implementation GGKTestRemindersViewController

- (IBAction)cancelReminder
{
    [[UIApplication sharedApplication] cancelLocalNotification:self.localNotification];
    [self updateForNoReminder];
}

- (void)checkReminderAndUpdate
{
    // If no reminder, adjust UI and stop timer. Else, adjust UI and report time remaining.
//    NSArray *theLocalNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
//    if (theLocalNotifications.count >= 1) {
//        
//        [self updateForAReminder:theLocalNotifications[0]];
//    } else {
//        
//        [self updateForNoReminder];
//        [self stopTimer];
//    }
    
    // If no reminder, adjust UI and stop timer. Else, adjust UI and report time remaining.
    NSArray *scheduledLocalNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    NSUInteger indexInteger = [scheduledLocalNotifications indexOfObject:self.localNotification];
    if (indexInteger == NSNotFound) {
        
        [self updateForNoReminder];
        [self stopTimer];
    } else {
        
        [self updateForAReminder];
    }
}
- (void)handleViewWillAppearToUser {
    [super handleViewWillAppearToUser];
    [self startVisibleUpdates];
}
- (IBAction)setTestReminder {
    UILocalNotification *aLocalNotification = [[UILocalNotification alloc] init];
    aLocalNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    aLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
    aLocalNotification.alertBody = @"Potty time? (Wash hands.)";
    aLocalNotification.soundName = [GGKReminderSoundPrefixString stringByAppendingString:@".caf"];
    [[UIApplication sharedApplication] scheduleLocalNotification:aLocalNotification];
    self.localNotification = aLocalNotification;
    [self startUpdateTimer];
    [self updateForAReminder];
}

- (void)startUpdateTimer
{
    // Every second, including now, update the view according to whether there's a reminder, and how much time is left.
    NSDate *aNowDate = [NSDate date];
    NSTimer *aTimer = [[NSTimer alloc] initWithFireDate:aNowDate interval:1.0 target:self selector:@selector(checkReminderAndUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSDefaultRunLoopMode];
    self.timer = aTimer;
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
    NSLog(@"TRVC: timer stopped");
}

- (void)stopVisibleUpdates
{
    [self stopTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)updateForAReminder
{
    self.testReminderButton.enabled = NO;
    
    // Report secs until reminder, and the actual time of the reminder.
    
    NSCalendar *aGregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit aSecCalendarUnit = NSSecondCalendarUnit;
    NSDate *theReminderDate = self.localNotification.fireDate;
    NSDateComponents *theReminderIncrementDateComponents = [aGregorianCalendar components:aSecCalendarUnit fromDate:[NSDate date] toDate:theReminderDate options:0];
    
    self.reminderLabel.text = [NSString stringWithFormat:@"A reminder is set for\n%ld sec\n from now.", (long)theReminderIncrementDateComponents.second];
    
    self.cancelButton.enabled = YES;
}

- (void)updateForNoReminder
{
    self.testReminderButton.enabled = YES;
    self.reminderLabel.text = @"";
    self.cancelButton.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateForNoReminder];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [self startVisibleUpdates];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopVisibleUpdates];
}

@end
