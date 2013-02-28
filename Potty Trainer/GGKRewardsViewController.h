//
//  GGKRewardsViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

// The default number of successes needed for reward 1.
extern const NSInteger GGKDefaultNumberOfSuccessesForReward1Integer;

// The default number of successes needed for reward 2.
extern const NSInteger GGKDefaultNumberOfSuccessesForReward2Integer;

// The default number of successes needed for reward 3.
extern const NSInteger GGKDefaultNumberOfSuccessesForReward3Integer;

// Key for storing the number of successes needed for reward 1.
extern NSString *GGKNumberOfSuccessesForReward1KeyString;

// Key for storing the number of successes needed for reward 2.
extern NSString *GGKNumberOfSuccessesForReward2KeyString;

// Key for storing the number of successes needed for reward 3.
extern NSString *GGKNumberOfSuccessesForReward3KeyString;

@interface GGKRewardsViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate>

// For showing/editing the number of successful potties needed to get the first reward.
@property (weak, nonatomic) IBOutlet UITextField *numberOfSuccessesForReward1TextField;

// For showing/editing the number of successful potties needed to get the first reward.
@property (weak, nonatomic) IBOutlet UITextField *numberOfSuccessesForReward2TextField;

// For showing/editing the number of successful potties needed to get the first reward.
@property (weak, nonatomic) IBOutlet UITextField *numberOfSuccessesForReward3TextField;

// "Successful potties: X".
@property (weak, nonatomic) IBOutlet UILabel *successfulPottiesLabel;

// For showing a check mark for each successful potty.
@property (weak, nonatomic) IBOutlet UITextView *successfulPottiesTextView;

- (void)actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)theButtonIndex;
// So, let the user pick a photo, or enter text.

// Let the user add a reward.
- (IBAction)addReward:(UIButton *)theButton;

// UIViewController override.
- (void)dealloc;

// Play sound as aural feedback for pressing button.
- (IBAction)playButtonSound;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
// So, note which text field is being edited. (To know whether to shift the screen up when the keyboard shows.)

- (void)textFieldDidEndEditing:(UITextField *)textField;
// So, if an invalid value was entered, then use the previous value. Also, note that no text field is being edited now.

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
// So, dismiss the keyboard.

// UIViewController override.
- (void)viewDidLoad;

// UIViewController override.
- (void)viewWillAppear:(BOOL)animated;

@end
