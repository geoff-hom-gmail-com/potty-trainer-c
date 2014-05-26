//
//  GGKAddRemindersViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 5/12/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKReminderTableViewDataSource.h"
#import "GGKSetReminderTimeViewController.h"
@interface GGKAddRemindersViewController : GGKViewController <GGKReminderTableViewDataSourceDelegate, GGKSetReminderTimeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addRemindersButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteAllRemindersBarButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *reminderTimeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addReminders;
- (void)alertView:(UIAlertView *)theAlertView clickedButtonAtIndex:(NSInteger)theButtonIndex;
// Confirm with user.
- (IBAction)handleDeleteAllRemindersTapped:(id)sender;
// Override.
- (void)handleViewWillAppearToUser;
// Override.
- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender;
// For app delegate to know this VC lists reminders.
- (void)refreshReminders;
// Update UI.
- (void)reminderTableViewDataSourceDidDeleteRow:(id)sender;
// Dismiss with no change.
- (void)setReminderTimeViewControllerDidCancel:(id)sender;
// Change default reminder time.
- (void)setReminderTimeViewControllerDidFinish:(id)sender;
@end
