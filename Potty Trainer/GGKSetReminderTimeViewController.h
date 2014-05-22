//
//  GGKSetReminderTimeViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 5/21/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

@protocol GGKSetReminderTimeViewControllerDelegate
// Sent after the user cancelled.
- (void)setReminderTimeViewControllerDidCancel:(id)sender;
// Sent after the user chose the reminder time.
- (void)setReminderTimeViewControllerDidFinish:(id)sender;
@end
@interface GGKSetReminderTimeViewController : GGKViewController <UIToolbarDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *defaultReminderDate;
@property (weak, nonatomic) id <GGKSetReminderTimeViewControllerDelegate> delegate;
- (IBAction)cancelChangeTime:(id)sender;
- (IBAction)changeTime:(id)sender;
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)theBar;
// Override.
- (void)viewDidLoad;
@end
