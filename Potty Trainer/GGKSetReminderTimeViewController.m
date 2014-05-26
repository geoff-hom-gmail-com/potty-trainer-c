//
//  GGKSetReminderTimeViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 5/21/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKSetReminderTimeViewController.h"

@interface GGKSetReminderTimeViewController ()

@end

@implementation GGKSetReminderTimeViewController
- (IBAction)handleDatePickerValueChanged:(id)sender {
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *aMinimumDate;
    NSDate *aDefaultDate;
    if (self.perfectPottyModel.isSettingFirstReminderTime) {
        // A minute from now.
        aMinimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
        
    } else {
        // The first reminder time + the repeat interval.
    }
    self.datePicker.minimumDate = aMinimumDate;
    self.datePicker.date = aDefaultDate;
    // Just before midnight tonight.
    NSCalendar *aCalendar = [NSCalendar autoupdatingCurrentCalendar];
    NSCalendarUnit aCalendarUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *aDateComponents = [aCalendar components:aCalendarUnit fromDate:[NSDate date]];
    aDateComponents.hour = 23;
    aDateComponents.minute = 59;
    aDateComponents.second = 59;
    NSDate *aBeforeTomorrowDate = [aCalendar dateFromComponents:aDateComponents];
    self.datePicker.maximumDate = aBeforeTomorrowDate;
    
    self.datePicker.date = self.reminderDate;
}
@end
