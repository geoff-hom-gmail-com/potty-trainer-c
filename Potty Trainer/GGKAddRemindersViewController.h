//
//  GGKAddRemindersViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 5/12/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKReminderTableViewDataSource.h"
@interface GGKAddRemindersViewController : GGKViewController <GGKReminderTableViewDataSourceDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addRemindersButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteAllRemindersBarButtonItem;
// To set last possible time for a reminder. (May be earlier if interval doesn't fit evenly.)
@property (weak, nonatomic) IBOutlet UIButton *lastReminderTimeButton;
// To enter minutes between repeating reminders.
@property (weak, nonatomic) IBOutlet UITextField *minutesBetweenRemindersTextField;
// Says "minutes until." To enable/disable label.
@property (weak, nonatomic) IBOutlet UILabel *minutesUntilLabel;
// To set time for first reminder.
@property (weak, nonatomic) IBOutlet UIButton *reminderTimeButton;
// Says "repeat every." To enable/disable label.
@property (weak, nonatomic) IBOutlet UILabel *repeatEveryLabel;
// Whether to add repeating reminders.
@property (weak, nonatomic) IBOutlet UISwitch *repeatReminderSwitch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addReminders;
- (void)alertView:(UIAlertView *)theAlertView clickedButtonAtIndex:(NSInteger)theButtonIndex;
// Confirm with user.
- (IBAction)handleDeleteAllRemindersTapped:(id)sender;
// Update UI.
- (IBAction)handleRepeatReminderSwitchValueChanged;
// Override.
- (void)handleViewWillAppearToUser;
// Override.
- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender;
// For app delegate to know this VC lists reminders.
- (void)refreshReminders;
// Update UI.
- (void)reminderTableViewDataSourceDidDeleteRow:(id)sender;
// Update model. Dismiss keyboard.
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField;
@end
