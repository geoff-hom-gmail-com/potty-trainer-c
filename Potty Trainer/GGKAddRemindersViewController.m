//
//  GGKAddRemindersViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 5/12/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKAddRemindersViewController.h"

#import "GGKReminderTableViewDataSource.h"
#import "GGKUtilities.h"
#import "NSDate+GGKDate.h"
@interface GGKAddRemindersViewController ()
@property (strong, nonatomic) NSDate *defaultReminderDate;
@property (strong, nonatomic) GGKReminderTableViewDataSource *reminderTableViewDataSourceAndDelegate;
- (void)deleteAllReminders;
- (void)updateUI;
@end

@implementation GGKAddRemindersViewController
- (IBAction)addReminders {
    // Schedule notification(s).
    UILocalNotification *aLocalNotification = [[UILocalNotification alloc] init];
    aLocalNotification.fireDate = self.defaultReminderDate;
    aLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
    aLocalNotification.alertBody = @"Potty time? (Wash hands.)";
    aLocalNotification.soundName = [GGKReminderSoundPrefixString stringByAppendingString:@".caf"];
    [[UIApplication sharedApplication] scheduleLocalNotification:aLocalNotification];
    [self updateUI];
}
- (void)alertView:(UIAlertView *)theAlertView clickedButtonAtIndex:(NSInteger)theButtonIndex {
    if ([[theAlertView buttonTitleAtIndex:theButtonIndex] isEqualToString:@"OK"]) {
        [self deleteAllReminders];
    }
}
- (void)deleteAllReminders {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self updateUI];
}
- (IBAction)handleDeleteAllRemindersTapped:(id)sender {
    [self playButtonSound];
    UIAlertView *anAlertView = [[UIAlertView alloc] initWithTitle:@"Delete All Reminders?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [anAlertView show];
}
- (void)handleViewWillAppearToUser {
    [super handleViewWillAppearToUser];
    [self updateUI];
}
- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender {
    if ([theSegue.identifier isEqualToString:@"ShowSetReminderTimeSegue"]) {
        GGKSetReminderTimeViewController *aSetReminderTimeViewController = theSegue.destinationViewController;
        aSetReminderTimeViewController.delegate = self;
        aSetReminderTimeViewController.defaultReminderDate = self.defaultReminderDate;
    }
}
- (void)refreshReminders {
    [self updateUI];
}
- (void)reminderTableViewDataSourceDidDeleteRow:(id)sender {
    [self updateUI];
}
- (void)setReminderTimeViewControllerDidCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setReminderTimeViewControllerDidFinish:(id)sender {
    GGKSetReminderTimeViewController *aSetReminderTimeViewController = sender;
    self.defaultReminderDate = aSetReminderTimeViewController.datePicker.date;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)updateUI {
    if ([[UIApplication sharedApplication].scheduledLocalNotifications count] == 0) {
        self.deleteAllRemindersBarButtonItem.enabled = NO;
    } else {
        self.deleteAllRemindersBarButtonItem.enabled = YES;
    }
    [self.reminderTimeButton setTitle:[self.defaultReminderDate hourMinuteAMPMString] forState:UIControlStateNormal];
    // if switch is off, just 1 reminder
    NSString *aTitleString = @"Add it!";
    [self.addRemindersButton setTitle:aTitleString forState:UIControlStateNormal];
    // If reminders, then allow editing.
    NSArray *theLocalNotificationsArray = [UIApplication sharedApplication].scheduledLocalNotifications;
    self.tableView.editing = ([theLocalNotificationsArray count] > 0);
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reminderTableViewDataSourceAndDelegate = [[GGKReminderTableViewDataSource alloc] initWithTableView:self.tableView];
    self.reminderTableViewDataSourceAndDelegate.delegate = self;
    // Default reminder time: 20' from now.
    NSTimeInterval aTwentyMinutesFromNowTimeInterval = 20 * 60;
    self.defaultReminderDate = [NSDate dateWithTimeIntervalSinceNow:aTwentyMinutesFromNowTimeInterval];
    [GGKUtilities addBorderToView:self.addRemindersButton];
}
@end
