//
//  GGKSettingsViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKSetReminderViewController.h"
#import <UIKit/UIKit.h>

@interface GGKSettingsViewController : GGKViewController <GGKSetReminderViewControllerDelegate>

// For cancelling the current reminder. If no reminder, disable this.
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
// For toggling background music.
@property (nonatomic, weak) IBOutlet UISwitch *musicSwitch;
// For telling the user if there is a reminder, and when.
@property (nonatomic, weak) IBOutlet UILabel *reminderLabel;

// For setting a reminder. Change label depending on whether a reminder already exists.
@property (nonatomic, weak) IBOutlet UIButton *setOrChangeReminderButton;

// Make sure the existing reminder doesn't go off.
- (IBAction)cancelReminder;

// UIViewController override.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

// sRVC set reminder, so dismiss that view controller.
- (void)setReminderViewControllerDidSetReminder:(id)sender;
// Toggle background music.
- (IBAction)toggleMusic;
// Override.
- (void)viewWillAppear:(BOOL)animated;

// Override.
- (void)viewWillDisappear:(BOOL)animated;

@end
