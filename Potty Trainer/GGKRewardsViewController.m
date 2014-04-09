//
//  GGKRewardsViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//


#import "GGKRewardsViewController.h"

#import "GGKAddRewardTextViewController.h"
#import "GGKReward.h"
#import "GGKUtilities.h"
#import <MobileCoreServices/MobileCoreServices.h>

NSString *GGKUsePhotoTitleString = @"Use photo";

NSString *GGKUseTextTitleString = @"Use text";

@interface GGKRewardsViewController ()
// The reward button that is currently being edited.
//@property (strong, nonatomic) UIButton *activeRewardButton;
// The amount the view was shifted to account for keyboard. Used to shift back.
@property (assign, nonatomic) CGFloat amountShiftedFloat;
// The text field currently being edited.
@property (strong, nonatomic) UITextField *activeTextField;
// Index of the reward currently being changed.
@property (assign, nonatomic) NSInteger rewardIndex;
// Shift the view back to normal.
- (void)keyboardWillHide:(NSNotification *)theNotification;
// Shift the view up, if necessary.
- (void)keyboardWillShow:(NSNotification *)theNotification;
// Return the reward corresponding to the given reward button.
//- (GGKReward *)rewardForButton:(UIButton *)theButton;
// Save the given image to the filename corresponding to the given reward button.
//- (void)saveImage:(UIImage *)theImage forRewardButton:(UIButton *)theRewardButton;
// Save the given reward to disk.
- (void)saveReward:(GGKReward *)theReward;
// Save the given text for the given reward button.
//- (void)saveText:(NSString *)theRewardText forRewardButton:(UIButton *)theRewardButton;
// Display an action sheet so the user can choose whether to use text or a photo to show the reward.
- (void)showActionSheetForAddingReward:(UIButton *)theButton;
// For the given reward index, show the proper info (successes needed, image/text).
- (void)updateLabelsForRewardIndex:(NSInteger)theIndex;
// Update entire UI.
- (void)updateLabels;
@end

@implementation GGKRewardsViewController
- (void)actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)theButtonIndex {
    NSString *theButtonTitleString = [theActionSheet buttonTitleAtIndex:theButtonIndex];
    if ([theButtonTitleString isEqualToString:GGKUseTextTitleString]) {
        GGKAddRewardTextViewController *anAddRewardTextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GGKAddRewardTextViewController"];
        anAddRewardTextViewController.delegate = self;
        GGKReward *theReward = self.perfectPottyModel.currentChild.rewardArray[self.rewardIndex];
        anAddRewardTextViewController.previousNameString = theReward.text;
        [self presentViewController:anAddRewardTextViewController animated:YES completion:nil];
    } else if ([theButtonTitleString isEqualToString:GGKUsePhotoTitleString]) {
        BOOL thePhotoLibraryIsAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        if (thePhotoLibraryIsAvailable) {
            UIImagePickerController *anImagePickerController = [[UIImagePickerController alloc] init];
            anImagePickerController.delegate = self;
            anImagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSArray *theAvailableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:anImagePickerController.sourceType];
            if ([theAvailableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
                anImagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            }
            // Having editing forces the image to be cropped to square and 320 x 320 (640 x 640 on Retina).
//            anImagePickerController.allowsEditing = NO;
            anImagePickerController.allowsEditing = YES;
            [self presentViewController:anImagePickerController animated:YES completion:nil];
        }
    }
}
- (IBAction)addReward:(UIButton *)theButton {
    [self showActionSheetForAddingReward:theButton];
}
- (void)addRewardTextViewControllerDidCancel:(id)sender {
    [sender dismissViewControllerAnimated:YES completion:nil];
}
- (void)addRewardTextViewControllerDidEnterText:(id)sender {
    GGKAddRewardTextViewController *anAddRewardTextViewController = (GGKAddRewardTextViewController *)sender;
    GGKReward *theReward = self.perfectPottyModel.currentChild.rewardArray[self.rewardIndex];
    theReward.text = anAddRewardTextViewController.nameTextField.text;
    // Since we are using text, remove any image for this reward. (VC checks whether an image when deciding whether to show text or image.)
    [theReward deleteImage];
    [self saveReward:theReward];
    [self updateLabelsForRewardIndex:self.rewardIndex];
    [sender dismissViewControllerAnimated:YES completion:nil];
    
    // Show the text on the button.
//    GGKAddRewardTextViewController *anAddRewardTextViewController = (GGKAddRewardTextViewController *)sender;
//    NSString *theRewardText = anAddRewardTextViewController.nameTextField.text;
//    [self.activeRewardButton setTitle:theRewardText forState:UIControlStateNormal];
    // If there was an image before, it will still be present over the title. (Setting an image when there is a title shows the image over the title, so setting an image is okay.)
//    [self.activeRewardButton setImage:nil forState:UIControlStateNormal];
    // Since we are using text, remove any image for this reward. (VC checks whether an image when deciding whether to show text or image.)
//    GGKReward *reward;
//    NSArray *rewardArray = self.perfectPottyModel.currentChild.rewardArray;
//    if (self.activeRewardButton == self.reward1Button) {
//        
//        reward = rewardArray[0];
//    } else if (self.activeRewardButton == self.reward2Button) {
//        
//        reward = rewardArray[1];
//    } else if (self.activeRewardButton == self.reward3Button) {
//        
//        reward = rewardArray[2];
//    }
//    [reward deleteImage];
    
    
//    NSFileManager *aFileManager = [[NSFileManager alloc] init];
//    NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
//    NSString *theImagePathComponentString = [NSString stringWithFormat:@"/%@.png", reward.imageName];
//    NSURL *theFileURL = [aDirectoryURL URLByAppendingPathComponent:theImagePathComponentString];
//    [aFileManager removeItemAtURL:theFileURL error:nil];
    
//    [self saveText:theRewardText forRewardButton:self.activeRewardButton];
//
//    self.activeRewardButton = nil;
//    [sender dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    // Don't need super.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)thePicker {
    [thePicker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)thePicker didFinishPickingMediaWithInfo:(NSDictionary *)theInfoDictionary {
    // Save data. Update button label.
    // Can assume only still images, no movies.
    UIImage *theEditedImage = (UIImage *)theInfoDictionary[UIImagePickerControllerEditedImage];
    UIImage *theOriginalImage = (UIImage *)theInfoDictionary[UIImagePickerControllerOriginalImage];
    UIImage *theImageToUse;
    if (theEditedImage != nil) {
        theImageToUse = theEditedImage;
    } else {
        theImageToUse = theOriginalImage;
    }
    // If slow loading from disk later, can scale-down image here before saving.
    //    NSLog(@"theImageToUse size:%@, scale:%f", NSStringFromCGSize(theImageToUse.size), theImageToUse.scale);
    NSData *theImageData = UIImagePNGRepresentation(theImageToUse);
    GGKReward *theReward = self.perfectPottyModel.currentChild.rewardArray[self.rewardIndex];
    theReward.imageData = theImageData;
    [self saveReward:theReward];
    [self updateLabelsForRewardIndex:self.rewardIndex];
    [thePicker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    // Show the image on the button.
//    [self.activeRewardButton setImage:theImageToUse forState:UIControlStateNormal];
    
//    UIImage *anImage = self.activeRewardButton.currentImage;
//    NSLog(@"anImage size:%@, scale:%f", NSStringFromCGSize(anImage.size), anImage.scale);
    
//    [self saveImage:theImageToUse forRewardButton:self.activeRewardButton];
    
//    self.activeRewardButton = nil;
//    [thePicker dismissViewControllerAnimated:YES completion:nil];
}
- (void)keyboardWillHide:(NSNotification *)theNotification {
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = newFrame.origin.y + self.amountShiftedFloat;
    NSDictionary* theUserInfo = [theNotification userInfo];
    NSTimeInterval keyboardAnimationDurationTimeInterval = [ theUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue ];
    [UIView animateWithDuration:keyboardAnimationDurationTimeInterval animations:^{
        self.view.frame = newFrame;
    }];
}
- (void)keyboardWillShow:(NSNotification *)theNotification {
    // could make the code below a category in VC, and call via
    // self shiftViewToSeeEditing:(CGRect)self.activeTextField.frame
    
    // Shift the view so that the active text field can be seen above the keyboard. We do this by comparing where the keyboard will end up vs. where the text field is. If a shift is needed, we shift the entire view up, synced with the keyboard shifting into place.
    NSDictionary *theUserInfo = [theNotification userInfo];
    CGRect keyboardFrameEndRect = [theUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardFrameEndRect = [self.view convertRect:keyboardFrameEndRect fromView:nil];
	CGFloat keyboardTop = keyboardFrameEndRect.origin.y;
    CGFloat activeTextFieldBottom = CGRectGetMaxY(self.activeTextField.frame);
    CGFloat overlap = activeTextFieldBottom - keyboardTop;
    CGFloat margin = 10;
    CGFloat amountToShift = overlap + margin;
    if (amountToShift > 0) {
        CGRect newFrame = self.view.frame;
        newFrame.origin.y = newFrame.origin.y - amountToShift;
        NSTimeInterval keyboardAnimationDurationTimeInterval = [ theUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue ];
        [UIView animateWithDuration:keyboardAnimationDurationTimeInterval animations:^{
            self.view.frame = newFrame;
        }];
        self.amountShiftedFloat = amountToShift;
    }
}
//- (GGKReward *)rewardForButton:(UIButton *)theButton {
//    NSArray *theRewardArray = self.perfectPottyModel.currentChild.rewardArray;
//    GGKReward *theReward;
//    if (theButton == self.reward1Button) {
//        theReward = theRewardArray[0];
//    } else if (theButton == self.reward2Button) {
//        theReward = theRewardArray[1];
//    } else if (theButton == self.reward3Button) {
//        theReward = theRewardArray[2];
//    }
//    return theReward;
//}
//- (void)saveImage:(UIImage *)theImage forRewardButton:(UIButton *)theRewardButton {
//    
//    NSData *theImageToUseData = UIImagePNGRepresentation(theImage);
//    NSFileManager *aFileManager = [[NSFileManager alloc] init];
//    
//    // Not sure why not using NSApplicationSupportDirectory. But below should work.
//    NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    
//    NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
//    NSArray *rewardArray = self.perfectPottyModel.currentChild.rewardArray;
//    GGKReward *reward;
//    if (self.activeRewardButton == self.reward1Button) {
//        
//        reward = rewardArray[0];
//    } else if (self.activeRewardButton == self.reward2Button) {
//        
//        reward = rewardArray[1];
//    } else if (self.activeRewardButton == self.reward3Button) {
//        
//        reward = rewardArray[2];
//    }
//    NSString *theImagePathComponentString = [NSString stringWithFormat:@"/%@.png", reward.imageName];
//    NSURL *theFileURL = [aDirectoryURL URLByAppendingPathComponent:theImagePathComponentString];
//    [theImageToUseData writeToURL:theFileURL atomically:YES];
//    
////    NSNumber *aBOOLNumber = [NSNumber numberWithBool:NO];
////    [[NSUserDefaults standardUserDefaults] setObject:aBOOLNumber forKey:theRewardIsTextBOOLNumberKeyString];
//}
- (void)saveReward:(GGKReward *)theReward {
    // All reward info, except image data, are saved with the children. So we'll save any image data, then the children.
    [theReward saveImage];
    [self.perfectPottyModel saveChildren];
}
//- (void)saveText:(NSString *)theRewardText forRewardButton:(UIButton *)theRewardButton {
//
//    NSArray *rewardArray = self.perfectPottyModel.currentChild.rewardArray;
//    GGKReward *reward;
//    if (self.activeRewardButton == self.reward1Button) {
//        
//        reward = rewardArray[0];
//    } else if (self.activeRewardButton == self.reward2Button) {
//        
//        reward = rewardArray[1];
//    } else if (self.activeRewardButton == self.reward3Button) {
//        
//        reward = rewardArray[2];
//    }
//    reward.text = theRewardText;
//    [self.perfectPottyModel saveChildren];
//}
- (void)showActionSheetForAddingReward:(UIButton *)theButton {
    NSInteger theRewardIndex;
    if (theButton == self.reward1Button) {
        theRewardIndex = 0;
    } else if (theButton == self.reward2Button) {
        theRewardIndex = 1;
    } else if (theButton == self.reward3Button) {
        theRewardIndex = 2;
    }
    self.rewardIndex = theRewardIndex;
//    self.activeRewardButton = theButton;
    UIActionSheet *anActionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Reward" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:GGKUseTextTitleString, GGKUsePhotoTitleString, nil];
    [anActionSheet showFromRect:theButton.frame inView:theButton animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)theTextField
{    
    self.activeTextField = theTextField;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    // Behavior depends on which text field was edited. Regardless, check the entered value. If not okay, set to an appropriate value. Store the value.
    
    id anOkayValue;
        
    // Should be an integer, 0 to 99.
    anOkayValue = @([theTextField.text integerValue]);
    NSInteger anOkayValueInteger = [anOkayValue integerValue];
    if (anOkayValueInteger < 0) {
        
        anOkayValue = @0;
    } else if (anOkayValueInteger > 99) {
        
        anOkayValue = @99;
    }
    theTextField.text = [anOkayValue stringValue];
    
    GGKReward *theReward;
    NSArray *rewardArray = self.perfectPottyModel.currentChild.rewardArray;
    if (theTextField == self.numberOfSuccessesForReward1TextField) {
        
        theReward = rewardArray[0];
    } else if (theTextField == self.numberOfSuccessesForReward2TextField) {
        
        theReward = rewardArray[1];
    } else if (theTextField == self.numberOfSuccessesForReward3TextField) {
        
        theReward = rewardArray[2];
    }
    theReward.numberOfSuccessesNeededInteger = anOkayValueInteger;
    [self.perfectPottyModel saveChildren];
    
    self.activeTextField = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return NO;
}
- (void)updateLabelsForRewardIndex:(NSInteger)theIndex {
    GGKReward *theReward = self.perfectPottyModel.currentChild.rewardArray[theIndex];
    UITextField *theTextField;
    UIButton *theButton;
    switch (theIndex) {
        case 0:
            theTextField = self.numberOfSuccessesForReward1TextField;
            theButton = self.reward1Button;
            break;
        case 1:
            theTextField = self.numberOfSuccessesForReward2TextField;
            theButton = self.reward2Button;
            break;
        case 2:
            theTextField = self.numberOfSuccessesForReward3TextField;
            theButton = self.reward3Button;
            break;
        default:
            break;
    }
    theTextField.text = [NSString stringWithFormat:@"%ld", (long)theReward.numberOfSuccessesNeededInteger];
    NSData *theImageData = theReward.imageData;
    if (theImageData == nil) {
        NSString *theTitleString;
        if (theReward.text == nil) {
            theTitleString = @"Add Reward";
        } else {
            theTitleString = theReward.text;
        }
//        [theButton setTitle:theTitleString forState:UIControlStateNormal];
//        theImage = nil;
        
        [theButton setTitle:theTitleString forState:UIControlStateNormal];
        [theButton setImage:nil forState:UIControlStateNormal];
        [theButton setBackgroundImage:nil forState:UIControlStateNormal];

//        if ([GGKUtilities iOSisBelow7]) {
//            [theButton setImage:nil forState:UIControlStateNormal];
//        } else {
//            [theButton setTitle:theTitleString forState:UIControlStateNormal];
//            [theButton setImage:nil forState:UIControlStateNormal];
//            [theButton setBackgroundImage:nil forState:UIControlStateNormal];
//        }
    } else {
        UIImage *theImage = [[UIImage alloc] initWithData:theImageData];
        if ([GGKUtilities iOSisBelow7]) {
            [theButton setImage:theImage forState:UIControlStateNormal];
        } else {
            [theButton setTitle:nil forState:UIControlStateNormal];
            [theButton setImage:nil forState:UIControlStateNormal];
            [theButton setBackgroundImage:theImage forState:UIControlStateNormal];
        }
    }
//    if ([GGKUtilities iOSisBelow7]) {
//        [theButton setTitle:theTitleString forState:UIControlStateNormal];
//        [theButton setImage:theImage forState:UIControlStateNormal];
//    } else {
//        // and need to set text to none.
//        [theButton setTitle:nil forState:UIControlStateNormal];
//        [theButton setImage:nil forState:UIControlStateNormal];
//        [theButton setBackgroundImage:theImage forState:UIControlStateNormal];
//    }
}
- (void)updateLabels {
    // Show number of successful potties.
    // Note: Wanted to show star emoji at arbitrarily large font size. However, couldn't get it to work in the text view. Perhaps under iOS 6+, especially with attributed text, it might work. Also, if we just want a bigger star, it works for non-emoji Unicode stars, such as \u2605.
    // Does not work. Emoji are not bigger and are cut off.
//    self.successfulPottiesTextView.font = [UIFont fontWithName:@"AppleColorEmoji" size:40.0];
//    self.successfulPottiesTextView.text = @"\u2B50";
    NSArray *aPottyAttemptDayArray = self.perfectPottyModel.currentChild.pottyAttemptDayArray;
    __block NSInteger theNumberOfSuccessesInteger = 0;
    [aPottyAttemptDayArray enumerateObjectsUsingBlock:^(NSArray *anAttemptArray, NSUInteger idx1, BOOL *stop1) {
        [anAttemptArray enumerateObjectsUsingBlock:^(NSDictionary *anAttemptDictionary, NSUInteger idx2, BOOL *stop2) {
            NSNumber *anAttemptWasSuccessfulBOOLNumber = anAttemptDictionary[GGKPottyAttemptWasSuccessfulNumberKeyString];
            BOOL anAttemptWasSuccessfulBOOL = [anAttemptWasSuccessfulBOOLNumber boolValue];
            if (anAttemptWasSuccessfulBOOL) {
                theNumberOfSuccessesInteger++;
            }
        }];
    }];
    NSString *theNumberOfSuccessfulPottiesString = @"None, yet";
    if (theNumberOfSuccessesInteger >= 1) {
        theNumberOfSuccessfulPottiesString = [NSString stringWithFormat:@"%ld", (long)theNumberOfSuccessesInteger];
    }
    self.successfulPottiesLabel.text = [NSString stringWithFormat:@"Successful potties: %@", theNumberOfSuccessfulPottiesString];
    NSMutableString *aCheckMarkForEachSuccessfulPottyMutableString = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < theNumberOfSuccessesInteger; i++) {
        [aCheckMarkForEachSuccessfulPottyMutableString appendString:GGKStarRewardString];
    }
    self.successfulPottiesTextView.text = aCheckMarkForEachSuccessfulPottyMutableString;
    
    // Show each reward: The number of successes needed, and the text or image describing the reward.
    for (int i = 0; i < 3; i++) {
        [self updateLabelsForRewardIndex:i];
    }
    
//    NSArray *theRewardButtonsArray = @[self.reward1Button, self.reward2Button, self.reward3Button];
//    NSArray *rewardArray = self.perfectPottyModel.currentChild.rewardArray;
//    [theRewardButtonsArray enumerateObjectsUsingBlock:^(UIButton *theRewardButton, NSUInteger idx, BOOL *stop) {
//        
//        GGKReward *theReward;
//        UITextField *theTextField;
//        if (theRewardButton == self.reward1Button) {
//            
//            theReward = rewardArray[0];
//            theTextField = self.numberOfSuccessesForReward1TextField;
//        } else if (theRewardButton == self.reward2Button) {
//            
//            theReward = rewardArray[1];
//            theTextField = self.numberOfSuccessesForReward2TextField;
//        } else if (theRewardButton == self.reward3Button) {
//            
//            theReward = rewardArray[2];
//            theTextField = self.numberOfSuccessesForReward3TextField;
//        }
//        theTextField.text = [NSString stringWithFormat:@"%ld", (long)theReward.numberOfSuccessesNeededInteger];
//        
//        // Check whether the reward has an image. If not, show text. If so, show the image.
//        
////        NSFileManager *aFileManager = [[NSFileManager alloc] init];
////        NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
////        NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
////        NSString *theImagePathComponentString = [NSString stringWithFormat:@"/%@.png", theReward.imageName];
////        NSURL *theFileURL = [aDirectoryURL URLByAppendingPathComponent:theImagePathComponentString];
////        [aFileManager fileExistsAtPath:[theFileURL path]];
////        NSData *theImageData = [NSData dataWithContentsOfURL:theFileURL];
//        
//        NSData *theImageData = theReward.imageData;
//        if (theImageData == nil) {
//            [theRewardButton setTitle:theReward.text forState:UIControlStateNormal];
//        } else {
//            UIImage *theImage = [[UIImage alloc] initWithData:theImageData];
//            [theRewardButton setImage:theImage forState:UIControlStateNormal];
//        }
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Observe keyboard notifications to shift the screen up/down appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.successfulPottiesTextView.backgroundColor = [UIColor clearColor];
    self.successfulPottiesTextView.textColor = [UIColor greenColor];
    [self.perfectPottyModel.currentChild.rewardArray makeObjectsPerformSelector:@selector(loadImage)];
    [self updateLabels];
}
@end
