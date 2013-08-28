//
//  GGKEditChildNameViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/28/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

@protocol GGKEditChildNameViewControllerDelegate

// Sent after the user cancelled.
- (void)editChildNameViewControllerDidCancel:(id)sender;

// Sent after the user entered the new name.
- (void)editChildNameViewControllerDidEnterText:(id)sender;

@end

@interface GGKEditChildNameViewController : GGKViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <GGKEditChildNameViewControllerDelegate> delegate;

// For entering the name of the reward.
@property (nonatomic, weak) IBOutlet UITextField *textField;

// Cancel entering the text.
- (IBAction)cancel;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
// So, notify the delegate that the user's done entering text.

@end
