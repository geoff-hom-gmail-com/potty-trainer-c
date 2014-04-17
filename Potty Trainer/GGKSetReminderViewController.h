//
//  GGKSetReminderViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/27/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import <UIKit/UIKit.h>

// String for the first part of label showing when the reminder will be.
extern NSString *GGKReminderWhenPrefixString;

@protocol GGKSetReminderViewControllerDelegate

// Sent after a reminder has been set (i.e., local notification sent). Assume any other reminders were removed.
- (void)setReminderViewControllerDidSetReminder:(id)sender;

@end

@interface GGKSetReminderViewController : GGKViewController

// For choosing the time until the next reminder.
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) id <GGKSetReminderViewControllerDelegate> delegate;
// For showing the user the time of the next reminder (e.g., "3:35 PM," not "in 1 hour, 30 min").
@property (weak, nonatomic) IBOutlet UILabel *whenLabel;
// So, update the label showing the reminder time.
- (IBAction)datePickerTimeChanged:(id)sender;
// Override.
- (void)handleViewWillAppearToUser;
// Cancel any previous reminders. Set this reminder.
- (IBAction)setReminder;
// Override.
- (void)viewDidLoad;
// Override. Stop anything from -viewWillAppear.
- (void)viewWillDisappear:(BOOL)animated;
@end
