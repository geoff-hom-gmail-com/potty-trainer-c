//
//  GGKSetReminderTimeViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 5/21/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"
@interface GGKSetReminderTimeViewController : GGKViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
//@property (strong, nonatomic) NSDate *reminderDate;
- (IBAction)handleDatePickerValueChanged:(id)sender;
// Override.
- (void)viewDidLoad;
@end
