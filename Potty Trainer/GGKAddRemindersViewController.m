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
// Date for first reminder. The model's reminder can change over time, so this ensures the reminder matches what the user sees and expects.
@property (strong, nonatomic) NSDate *firstReminderDate;
@property (strong, nonatomic) GGKReminderTableViewDataSource *reminderTableViewDataSourceAndDelegate;
- (void)deleteAllReminders;
- (void)updateUI;
@end

@implementation GGKAddRemindersViewController
- (IBAction)addReminders {
    // Schedule notification(s).
    UILocalNotification *aLocalNotification = [[UILocalNotification alloc] init];
    aLocalNotification.fireDate = self.firstReminderDate;
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
- (IBAction)handleRepeatReminderSwitchValueChanged {
    [self updateUI];
}
- (void)handleViewWillAppearToUser {
    [super handleViewWillAppearToUser];
    [self updateUI];
}
- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender {
    if ([theSegue.identifier isEqualToString:@"SetFirstReminderTimeSegue"]) {
        self.perfectPottyModel.isSettingFirstReminderTime = YES;
    } else if ([theSegue.identifier isEqualToString:@"SetLastReminderTimeSegue"]) {
        self.perfectPottyModel.isSettingFirstReminderTime = NO;
    }
}
- (void)refreshReminders {
    [self updateUI];
}
- (void)reminderTableViewDataSourceDidDeleteRow:(id)sender {
    [self updateUI];
}
//- (void)setReminderTimeViewControllerDidCancel:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)setReminderTimeViewControllerDidFinish:(id)sender {
//    GGKSetReminderTimeViewController *aSetReminderTimeViewController = sender;
//    self.firstReminderDate = aSetReminderTimeViewController.datePicker.date;
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
- (void)updateUI {
    self.firstReminderDate = self.perfectPottyModel.firstReminderDate;
    if ([[UIApplication sharedApplication].scheduledLocalNotifications count] == 0) {
        self.deleteAllRemindersBarButtonItem.enabled = NO;
    } else {
        self.deleteAllRemindersBarButtonItem.enabled = YES;
    }
    [self.reminderTimeButton setTitle:[self.firstReminderDate hourMinuteAMPMString] forState:UIControlStateNormal];
    self.minutesBetweenRemindersTextField.text = [NSString stringWithFormat:@"%d", self.perfectPottyModel.minutesBetweenRemindersInteger];
    NSString *aTimeString = [self.perfectPottyModel.lastReminderDate hourMinuteAMPMString];
    [self.lastReminderTimeButton setTitle:aTimeString forState:UIControlStateNormal];
    [self.lastReminderTimeButton setTitle:aTimeString forState:UIControlStateDisabled];
    NSString *theAddRemindersButtonTitleString;
    if (self.repeatReminderSwitch.on) {
        self.repeatEveryLabel.enabled = YES;
        self.minutesBetweenRemindersTextField.enabled = YES;
        self.minutesBetweenRemindersTextField.textColor = [UIColor blackColor];
        self.minutesUntilLabel.enabled = YES;
        self.lastReminderTimeButton.enabled = YES;
        // # reminders = [(final time - start time) in minutes / repeat interval] + 1
        NSUInteger theNumberOfReminders = ([self.perfectPottyModel.lastReminderDate timeIntervalSinceDate:self.firstReminderDate] / 60 / self.perfectPottyModel.minutesBetweenRemindersInteger) + 1;
        theAddRemindersButtonTitleString = [NSString stringWithFormat:@"Add %d!", theNumberOfReminders];
    } else {
        self.repeatEveryLabel.enabled = NO;
        self.minutesBetweenRemindersTextField.enabled = NO;
        self.minutesBetweenRemindersTextField.textColor = [UIColor lightGrayColor];
        self.minutesUntilLabel.enabled = NO;
        self.lastReminderTimeButton.enabled = NO;
        theAddRemindersButtonTitleString = @"Add it!";
    }
    [self.addRemindersButton setTitle:theAddRemindersButtonTitleString forState:UIControlStateNormal];
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
    [GGKUtilities addBorderToView:self.addRemindersButton];
}
@end
