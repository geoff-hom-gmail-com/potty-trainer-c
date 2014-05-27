//
//  GGKSetReminderTimeViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 5/21/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKSetReminderTimeViewController.h"

#import "NSDate+GGKDate.h"
@interface GGKSetReminderTimeViewController ()
@end
@implementation GGKSetReminderTimeViewController
- (IBAction)handleDatePickerValueChanged:(id)sender {
    NSDate *theDate = self.datePicker.date;
    if (self.perfectPottyModel.isSettingFirstReminderTimeBOOL) {
        self.perfectPottyModel.firstReminderDate = theDate;
    } else {
        self.perfectPottyModel.lastReminderDate = theDate;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *aMinimumDate;
    NSDate *aDefaultDate;
    if (self.perfectPottyModel.isSettingFirstReminderTimeBOOL) {
        aMinimumDate = [NSDate date];
        aDefaultDate = self.perfectPottyModel.firstReminderDate;
    } else {
        // Minimum date: the first reminder time + the repeat interval.
        aMinimumDate = [self.perfectPottyModel.firstReminderDate dateByAddingTimeInterval:(self.perfectPottyModel.minutesBetweenRemindersInteger * 60)];
        aDefaultDate = self.perfectPottyModel.lastReminderDate;
    }
    // If the reminder date is before the minimum date, then the picker may show a different time than the stored reminder date. If the user immediately dismisses this view, then the stored reminder date will be shown. That's confusing. So we'll set the reminder date.
    NSComparisonResult aComparisonResult = [aDefaultDate compare:aMinimumDate];
    if (aComparisonResult == NSOrderedAscending) {
        if (self.perfectPottyModel.isSettingFirstReminderTimeBOOL) {
            self.perfectPottyModel.firstReminderDate = aMinimumDate;
        } else {
            self.perfectPottyModel.lastReminderDate = aMinimumDate;
        }
    }
    self.datePicker.minimumDate = aMinimumDate;
    self.datePicker.date = aDefaultDate;
    // Just before midnight tonight.
    // 24 h * (60 min / h) * (60 s / min).
    NSInteger theSecondsInADayInteger = 24 * 60 * 60;
    NSDate *aBeforeTomorrowDate = [[NSDate date] dateWithTime:(theSecondsInADayInteger - 1)];
    self.datePicker.maximumDate = aBeforeTomorrowDate;
}
@end
