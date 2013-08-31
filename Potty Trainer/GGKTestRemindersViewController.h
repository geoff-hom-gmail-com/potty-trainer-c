//
//  GGKTestRemindersViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/30/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

@interface GGKTestRemindersViewController : GGKViewController

// For cancelling the current reminder. If no reminder, disable this.
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

// For telling the user if there is a reminder, and when.
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

// For setting a test reminder.
@property (weak, nonatomic) IBOutlet UIButton *testReminderButton;

// Make sure the existing reminder doesn't go off.
- (IBAction)cancelReminder;

// Set a reminder to go off in a few seconds.
- (IBAction)setTestReminder;

// Override.
- (void)viewDidLoad;

// Override.
- (void)viewWillAppear:(BOOL)animated;

// Override.
- (void)viewWillDisappear:(BOOL)animated;

@end
