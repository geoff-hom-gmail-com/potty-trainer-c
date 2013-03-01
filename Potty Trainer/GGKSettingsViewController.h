//
//  GGKSettingsViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKSetReminderViewController.h"
#import <UIKit/UIKit.h>

@interface GGKSettingsViewController : UIViewController <UIAlertViewDelegate, GGKSetReminderViewControllerDelegate>

// For cancelling the current reminder. If no reminder, disable this.
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

// For telling the user if there is a reminder, and when.
@property (nonatomic, weak) IBOutlet UILabel *reminderLabel;

// For setting a reminder. Change label depending on whether a reminder already exists.
@property (nonatomic, weak) IBOutlet UIButton *setOrChangeReminderButton;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
// So, if user confirmed she wants to reset the history, do so.

// Make sure the existing reminder doesn't go off.
- (IBAction)cancelReminder;

// UIViewController override.
//- (void)dealloc;

// Play sound as aural feedback for pressing button.
- (IBAction)playButtonSound;

// UIViewController override.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (IBAction)resetHistory;
// So, ask the user to confirm she wants to reset the history of potty attempts.

- (void)setReminderViewControllerDidSetReminder:(id)sender;
// So, dismiss the view controller.

// UIViewController override.
- (void)viewDidLoad;

// UIViewController override. Start visible updates. Check for app coming from background/lock.
- (void)viewWillAppear:(BOOL)animated;

// UIViewController override. Stop anything from -viewWillAppear.
- (void)viewWillDisappear:(BOOL)animated;

@end
