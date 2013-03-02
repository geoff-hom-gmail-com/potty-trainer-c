//
//  GGKAddRewardTextViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 3/1/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGKAddRewardTextViewControllerDelegate

// Sent after the user cancelled.
- (void)addRewardTextViewControllerDidCancel:(id)sender;

// Sent after the user entered the reward text.
- (void)addRewardTextViewControllerDidEnterText:(id)sender;

@end

@interface GGKAddRewardTextViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <GGKAddRewardTextViewControllerDelegate> delegate;

// For entering the name of the reward.
@property (nonatomic, weak) IBOutlet UITextField *textField;

// Cancel entering the text.
- (IBAction)cancel;

//- (void)textFieldDidBeginEditing:(UITextField *)textField;
//// So, note which text field is being edited. (To know whether to shift the screen up when the keyboard shows.)
//
//- (void)textFieldDidEndEditing:(UITextField *)textField;
// So, if an invalid value was entered, then use the previous value. Also, note that no text field is being edited now.

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
// So, notify the delegate that the user's done entering text.

@end