//
//  GGKRewardsViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKAddRewardTextViewController.h"
#import <UIKit/UIKit.h>

// The default number of successes needed for reward 1.
extern const NSInteger GGKDefaultNumberOfSuccessesForReward1Integer;

// The default number of successes needed for reward 2.
extern const NSInteger GGKDefaultNumberOfSuccessesForReward2Integer;

// The default number of successes needed for reward 3.
extern const NSInteger GGKDefaultNumberOfSuccessesForReward3Integer;

// Prefix for reward 1's image filename.
extern NSString *GGKReward1ImageNameString;

// Prefix for reward 2's image filename.
extern NSString *GGKReward2ImageNameString;

// Prefix for reward 3's image filename.
extern NSString *GGKReward3ImageNameString;

// String to identify the button title for choosing a photo (vs. text).
extern NSString *GGKUsePhotoTitleString;

// String to identify the button title for choosing text (vs. a photo).
extern NSString *GGKUseTextTitleString;

@interface GGKRewardsViewController : GGKViewController <GGKAddRewardTextViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

// For showing/editing the number of successful potties needed to get the first reward.
@property (weak, nonatomic) IBOutlet UITextField *numberOfSuccessesForReward1TextField;

// For showing/editing the number of successful potties needed to get the first reward.
@property (weak, nonatomic) IBOutlet UITextField *numberOfSuccessesForReward2TextField;

// For showing/editing the number of successful potties needed to get the first reward.
@property (weak, nonatomic) IBOutlet UITextField *numberOfSuccessesForReward3TextField;

// For showing/editing the first reward.
@property (weak, nonatomic) IBOutlet UIButton *reward1Button;

// For showing/editing the second reward.
@property (weak, nonatomic) IBOutlet UIButton *reward2Button;

// For showing/editing the third reward.
@property (weak, nonatomic) IBOutlet UIButton *reward3Button;

// "Successful potties: X".
@property (weak, nonatomic) IBOutlet UILabel *successfulPottiesLabel;

// For showing a check mark for each successful potty.
@property (weak, nonatomic) IBOutlet UITextView *successfulPottiesTextView;
// Let the user enter text or pick a photo.
- (void)actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)theButtonIndex;
// Let the user add a reward.
- (IBAction)addReward:(UIButton *)theButton;
// Dismiss it.
- (void)addRewardTextViewControllerDidCancel:(id)sender;
// Save data. Update UI.
- (void)addRewardTextViewControllerDidEnterText:(id)sender;
// UIViewController override.
- (void)dealloc;

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
// So, dismiss the picker.

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
// So, show the image on the corresponding reward button.

- (void)textFieldDidBeginEditing:(UITextField *)textField;
// So, note which text field is being edited. (To know whether to shift the screen up when the keyboard shows.)

- (void)textFieldDidEndEditing:(UITextField *)textField;
// So, if an invalid value was entered, then use the previous value. Also, note that no text field is being edited now.

// Dismiss the keyboard.
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
// Override.
- (void)viewDidLoad;
@end
