//
//  GGKSetReminderViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/27/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

// String for the first part of label showing when the reminder will be.
extern NSString *GGKReminderWhenPrefixString;

@protocol GGKSetReminderViewControllerDelegate

// Sent after a reminder has been set (i.e., local notification sent). Assume any other reminders were removed.
- (void)setReminderViewControllerDidSetReminder:(id)sender;

@end

@interface GGKSetReminderViewController : UIViewController

// For choosing the time until the next reminder.
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) id <GGKSetReminderViewControllerDelegate> delegate;

// For showing the user the time of the next reminder (e.g., "3:35 PM," not "in 1 hour, 30 min").
@property (nonatomic, weak) IBOutlet UILabel *whenLabel;

- (IBAction)datePickerTimeChanged:(id)sender;
// So, update the label showing the reminder time.

// UIViewController override.
- (void)dealloc;

// Play sound as aural feedback for pressing button.
- (IBAction)playButtonSound;

// (For testing.) Cancel any previous reminders. Set a reminder that goes off in 8 seconds.
- (IBAction)setQuickReminder;

// Cancel any previous reminders. Set this reminder.
- (IBAction)setReminder;

// UIViewController override.
- (void)viewDidLoad;

// UIViewController override.
- (void)viewWillAppear:(BOOL)animated;

// UIViewController override. Using this since -dealloc wasn't being called for some reason. Stop anything from -viewWillAppear.
- (void)viewWillDisappear:(BOOL)animated;

@end
