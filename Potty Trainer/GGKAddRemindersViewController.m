//
//  GGKAddRemindersViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 5/12/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKAddRemindersViewController.h"

#import "GGKReminderTableViewDataSourceAndDelegate.h"
#import "NSDate+GGKDate.h"
@interface GGKAddRemindersViewController ()
@property (strong, nonatomic) NSDate *defaultReminderDate;
@property (strong, nonatomic) GGKReminderTableViewDataSourceAndDelegate *reminderTableViewDataSourceAndDelegate;
@end

@implementation GGKAddRemindersViewController
- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender {
    if ([theSegue.identifier isEqualToString:@"ShowSetReminderTimeSegue"]) {
        GGKSetReminderTimeViewController *aSetReminderTimeViewController = theSegue.destinationViewController;
        aSetReminderTimeViewController.delegate = self;
        aSetReminderTimeViewController.defaultReminderDate = self.defaultReminderDate;
    }
}
- (void)setReminderTimeViewControllerDidCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setReminderTimeViewControllerDidFinish:(id)sender {
    GGKSetReminderTimeViewController *aSetReminderTimeViewController = sender;
    self.defaultReminderDate = aSetReminderTimeViewController.datePicker.date;
    [self.reminderTimeButton setTitle:[self.defaultReminderDate hourMinuteAMPMString] forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reminderTableViewDataSourceAndDelegate = [[GGKReminderTableViewDataSourceAndDelegate alloc] initWithTableView:self.tableView];
    // Default reminder time: 20' from now.
    NSTimeInterval aTwentyMinutesFromNowTimeInterval = 20 * 60;
    NSDate *aLaterDate = [NSDate dateWithTimeIntervalSinceNow:aTwentyMinutesFromNowTimeInterval];
    NSString *aDateString = [aLaterDate hourMinuteAMPMString];
    self.defaultReminderDate = aLaterDate;
    [self.reminderTimeButton setTitle:aDateString forState:UIControlStateNormal];
}
@end
