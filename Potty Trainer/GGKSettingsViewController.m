//
//  GGKSettingsViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKSettingsViewController.h"

#import "GGKSavedInfo.h"
#import "NSDate+GGKDate.h"

@interface GGKSettingsViewController ()

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

// Update UI for a reminder existing already.
- (void)updateForAReminder:(UILocalNotification *)theLocalNotification;

// Update UI for no reminder set yet.
- (void)updateForNoReminder;

@end

@implementation GGKSettingsViewController

- (void)alertView:(UIAlertView *)theAlertView clickedButtonAtIndex:(NSInteger)theButtonIndex
{
    if ([[theAlertView buttonTitleAtIndex:theButtonIndex] isEqualToString:@"OK"]) {
        
        // deprecated? will be done in "pick child" vc now
//        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:GGKPottyAttemptsKeyString];
    }
}

- (IBAction)cancelReminder
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self updateForNoReminder];
}

- (void)checkReminderAndUpdate
{
//    NSLog(@"SVC checkReminderAndUpdate called");
    
    // If no reminder, adjust UI and stop timer. Else, adjust UI and report time remaining.
    NSArray *theLocalNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    if (theLocalNotifications.count >= 1) {
        
        [self updateForAReminder:theLocalNotifications[0]];
    } else {
        
        [self updateForNoReminder];
        [self stopTimer];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSetReminderView"]) {
        
        [segue.destinationViewController setDelegate:self];
    }
}

- (IBAction)resetHistory
{
    // Put the cancel button on the right, since this is a potentially risky action.
    UIAlertView *anAlertView = [[UIAlertView alloc] initWithTitle:@"Delete potty history?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", @"Cancel", nil];
    anAlertView.cancelButtonIndex = 1;
    [anAlertView show];
}

- (void)setReminderViewControllerDidSetReminder:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startUpdateTimer
{
    // Every second, including now, update the view according to whether there's a reminder, and how much time is left.
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkReminderAndUpdate) userInfo:nil repeats:YES];
    
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
    NSLog(@"timer stopped");
}

- (void)stopVisibleUpdates
{
    [self stopTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)updateForAReminder:(UILocalNotification *)theLocalNotification
{
    // Report hours/mins/secs until reminder, and the actual time of the reminder.
    
    NSCalendar *aGregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit anHourMinSecCalendarUnit = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *theReminderDate = theLocalNotification.fireDate;
    NSDateComponents *theReminderIncrementDateComponents = [aGregorianCalendar components:anHourMinSecCalendarUnit fromDate:[NSDate date] toDate:theReminderDate options:0];
    
    // Adjust words for singular/plural.
    NSString *thePluralHourString;
    if (theReminderIncrementDateComponents.hour == 1) {
        
        thePluralHourString = @"";
    } else {
        
        thePluralHourString = @"s";
    }
    
    self.reminderLabel.text = [NSString stringWithFormat:@"A reminder is set for\n%d hour%@, %d min, %d sec\n from now (%@).", theReminderIncrementDateComponents.hour, thePluralHourString, theReminderIncrementDateComponents.minute, theReminderIncrementDateComponents.second, [theReminderDate hourMinuteAMPMString]];
    
    self.cancelButton.enabled = YES;
    [self.setOrChangeReminderButton setTitle:@"Change Reminder" forState:UIControlStateNormal];
}

- (void)updateForNoReminder
{
    self.reminderLabel.text = @"There is currently\nno reminder.";
    self.cancelButton.enabled = NO;
    [self.setOrChangeReminderButton setTitle:@"Set Reminder" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    [self startVisibleUpdates];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopVisibleUpdates];
}

@end
