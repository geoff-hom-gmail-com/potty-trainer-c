//
//  GGKAddRemindersViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 5/12/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKSetReminderTimeViewController.h"
@interface GGKAddRemindersViewController : GGKViewController <GGKSetReminderTimeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addRemindersButton;
@property (weak, nonatomic) IBOutlet UIButton *reminderTimeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// Override.
- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender;
// Dismiss with no change.
- (void)setReminderTimeViewControllerDidCancel:(id)sender;
// Change default reminder time.
- (void)setReminderTimeViewControllerDidFinish:(id)sender;
@end
