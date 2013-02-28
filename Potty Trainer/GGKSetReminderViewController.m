//
//  GGKSetReminderViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/27/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKSetReminderViewController.h"

NSString *GGKReminderWhenPrefixString = @"which is";

@interface GGKSetReminderViewController ()

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

// Calculate and return the date for the reminder, based on the date picker.
- (NSDate *)reminderDate;

@end

@implementation GGKSetReminderViewController

- (IBAction)datePickerTimeChanged:(id)sender
{    
    // Show the user the new reminder time.
    NSDate *theReminderDate = [self reminderDate];
    NSString *theReminderDateString = [theReminderDate hourMinuteAMPMString];
    self.whenLabel.text = [NSString stringWithFormat:@"%@ %@", GGKReminderWhenPrefixString, theReminderDateString];    
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
    // WILO
    NSLog(@"SRVC sR");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *aLocalNotification = [[UILocalNotification alloc] init];
    
    NSDate *theReminderDate = [self reminderDate];
    
    //testing
    theReminderDate = [NSDate date];
    theReminderDate = [NSDate dateWithTimeIntervalSinceNow:6];
    
    aLocalNotification.fireDate = theReminderDate;
    
    aLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
    aLocalNotification.alertBody = @"alertBody";
    aLocalNotification.soundName = UILocalNotificationDefaultSoundName;
    
//    [[UIApplication sharedApplication] presentLocalNotificationNow:aLocalNotification];
    [[UIApplication sharedApplication] scheduleLocalNotification:aLocalNotification];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.soundModel = [[GGKSoundModel alloc] init];
    
    // Set the date picker to an appropriate reminder increment. If there is no current reminder, use the default increment. Else, use the remaining time on the current reminder, rounded up.

    NSCalendar *aGregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *theReminderIncrementDateComponents;
    
    NSArray *theLocalNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    if (theLocalNotifications.count == 0) {
        
        theReminderIncrementDateComponents = [[NSDateComponents alloc] init];
        [theReminderIncrementDateComponents setHour:1];
        [theReminderIncrementDateComponents setMinute:30];
    } else {
        
        UILocalNotification *aLocalNotification = theLocalNotifications[0];
        NSDate *theReminderDate = aLocalNotification.fireDate;
        NSCalendarUnit aHourMinuteCalendarUnit = NSMinuteCalendarUnit | NSHourCalendarUnit;
        theReminderIncrementDateComponents = [aGregorianCalendar components:aHourMinuteCalendarUnit fromDate:theReminderDate toDate:[NSDate date] options:0];
    }
    NSDate *theReminderIncrementDate = [aGregorianCalendar dateFromComponents:theReminderIncrementDateComponents];
    self.datePicker.date = theReminderIncrementDate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show the current reminder time.
    NSDate *theReminderDate = [self reminderDate];
    NSString *theReminderDateString = [theReminderDate hourMinuteAMPMString];
    self.whenLabel.text = [NSString stringWithFormat:@"%@ %@", GGKReminderWhenPrefixString, theReminderDateString];
}

@end
