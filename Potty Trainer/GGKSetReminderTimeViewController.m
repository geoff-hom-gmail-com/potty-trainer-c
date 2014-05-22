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
- (IBAction)cancelChangeTime:(id)sender {
    [self playButtonSound];
    [self.delegate setReminderTimeViewControllerDidCancel:self];
}
- (IBAction)changeTime:(id)sender {
    [self playButtonSound];
    [self.delegate setReminderTimeViewControllerDidFinish:self];
}
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)theBar {
    return UIBarPositionTopAttached;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *aNowDate = [NSDate date];
    self.datePicker.minimumDate = aNowDate;
    // 24 h * 60 m * 60 s.
    NSTimeInterval aDayFromNowTimeInterval = 24 * 60 * 60;
    NSDate *aDayFromNowDate = [NSDate dateWithTimeIntervalSinceNow:aDayFromNowTimeInterval];
    self.datePicker.maximumDate = aDayFromNowDate;
    NSDate *theEarlierDate = [aNowDate earlierDate:self.defaultReminderDate];
    if (theEarlierDate != aNowDate) {
        self.defaultReminderDate = aNowDate;
    }
    self.datePicker.date = self.defaultReminderDate;
}
@end
