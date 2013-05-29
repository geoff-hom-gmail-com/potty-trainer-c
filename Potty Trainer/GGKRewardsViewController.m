//
//  GGKRewardsViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAddRewardTextViewController.h"
#import "GGKRewardsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

const NSInteger GGKDefaultNumberOfSuccessesForReward1Integer = 5;

const NSInteger GGKDefaultNumberOfSuccessesForReward2Integer = 10;

const NSInteger GGKDefaultNumberOfSuccessesForReward3Integer = 15;

NSString *GGKReward1ImageNameString = @"reward1";

NSString *GGKReward2ImageNameString = @"reward2";

NSString *GGKReward3ImageNameString = @"reward3";

NSString *GGKUsePhotoTitleString = @"Use photo";

NSString *GGKUseTextTitleString = @"Use text";

@interface GGKRewardsViewController ()

// The reward button that is currently being edited.
@property (strong, nonatomic) UIButton *activeRewardButton;

// The text field currently being edited.
@property (strong, nonatomic) UITextField *activeTextField;

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

- (void)keyboardWillHide:(NSNotification *)theNotification;
// So, shift the view back to normal.

- (void)keyboardWillShow:(NSNotification *)theNotification;
// So, shift the view up, if necessary.

// Save the given image to the filename corresponding to the given reward button.
- (void)saveImage:(UIImage *)theImage forRewardButton:(UIButton *)theRewardButton;

// Save the given text for the given reward button.
- (void)saveText:(NSString *)theRewardText forRewardButton:(UIButton *)theRewardButton;

// Display an action sheet so the user can choose whether to use text or a photo to show the reward.
- (void)showActionSheetForAddingReward:(UIButton *)theButton;

// Update labels in case they changed.
- (void)updateLabels;

@end

@implementation GGKRewardsViewController

- (void)actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)theButtonIndex
{
    // So, let the user pick a photo, or enter text.
    NSString *theButtonTitleString = [theActionSheet buttonTitleAtIndex:theButtonIndex];
    
    if ([theButtonTitleString isEqualToString:GGKUseTextTitleString]) {
        
        GGKAddRewardTextViewController *anAddRewardTextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GGKAddRewardTextViewController"];
        anAddRewardTextViewController.delegate = self;
        [self presentViewController:anAddRewardTextViewController animated:YES completion:nil];
    } else if ([theButtonTitleString isEqualToString:GGKUsePhotoTitleString]) {
        
//        NSLog(@"RVC aS cBAI 1");
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

- (IBAction)addReward:(UIButton *)theButton
{
    [self showActionSheetForAddingReward:theButton];
}

- (void)addRewardTextViewControllerDidCancel:(id)sender
{
    [sender dismissViewControllerAnimated:YES completion:nil];
}

- (void)addRewardTextViewControllerDidEnterText:(id)sender
{
    // Show the text on the button.
    GGKAddRewardTextViewController *anAddRewardTextViewController = (GGKAddRewardTextViewController *)sender;
    NSString *theRewardText = anAddRewardTextViewController.textField.text;
    [self.activeRewardButton setTitle:theRewardText forState:UIControlStateNormal];
    
    // If there was an image before, it will still be present over the title. (Setting an image when there is a title shows the image over the title, so setting an image is okay.)
    [self.activeRewardButton setImage:nil forState:UIControlStateNormal];

    [self saveText:theRewardText forRewardButton:self.activeRewardButton];

    self.activeRewardButton = nil;
    [sender dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    // Don't need super.
//    NSLog(@"RVC dealloc called");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)thePicker
{
    [thePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)thePicker didFinishPickingMediaWithInfo:(NSDictionary *)theInfoDictionary
{
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
    
    // Show the image on the button.
    [self.activeRewardButton setImage:theImageToUse forState:UIControlStateNormal];
    
//    UIImage *anImage = self.activeRewardButton.currentImage;
//    NSLog(@"anImage size:%@, scale:%f", NSStringFromCGSize(anImage.size), anImage.scale);
    
    [self saveImage:theImageToUse forRewardButton:self.activeRewardButton];
        
    self.activeRewardButton = nil;
    [thePicker dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)keyboardWillHide:(NSNotification *)theNotification {
	
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = 0;
    
    NSDictionary* theUserInfo = [theNotification userInfo];
    NSTimeInterval keyboardAnimationDurationTimeInterval = [ theUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue ];
    [UIView animateWithDuration:keyboardAnimationDurationTimeInterval animations:^{
        
        self.view.frame = newFrame;
    }];
}

- (void)keyboardWillShow:(NSNotification *)theNotification
{    
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
    }
}

- (IBAction)playButtonSound
{
    [self.soundModel playButtonTapSound];
}

- (void)saveImage:(UIImage *)theImage forRewardButton:(UIButton *)theRewardButton {
    
    NSData *theImageToUseData = UIImagePNGRepresentation(theImage);
    NSFileManager *aFileManager = [[NSFileManager alloc] init];
    
    // Not sure why not using NSApplicationSupportDirectory. But below should work.
    NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
    NSString *theRewardImagePrefixString;
    NSString *theRewardIsTextBOOLNumberKeyString;
    if (self.activeRewardButton == self.reward1Button) {
        
        theRewardImagePrefixString = GGKReward1ImageNameString;
        theRewardIsTextBOOLNumberKeyString = GGKReward1IsTextBOOLNumberKeyString;
    } else if (self.activeRewardButton == self.reward2Button) {
        
        theRewardImagePrefixString = GGKReward2ImageNameString;
        theRewardIsTextBOOLNumberKeyString = GGKReward2IsTextBOOLNumberKeyString;
    } else if (self.activeRewardButton == self.reward3Button) {
        
        theRewardImagePrefixString = GGKReward3ImageNameString;
        theRewardIsTextBOOLNumberKeyString = GGKReward3IsTextBOOLNumberKeyString;
    }
    NSString *theImagePathComponentString = [NSString stringWithFormat:@"/%@.png", theRewardImagePrefixString];
    NSURL *theFileURL = [aDirectoryURL URLByAppendingPathComponent:theImagePathComponentString];
    [theImageToUseData writeToURL:theFileURL atomically:YES];
    
    NSNumber *aBOOLNumber = [NSNumber numberWithBool:NO];
    [[NSUserDefaults standardUserDefaults] setObject:aBOOLNumber forKey:theRewardIsTextBOOLNumberKeyString];
}

- (void)saveText:(NSString *)theRewardText forRewardButton:(UIButton *)theRewardButton {

    NSString *theRewardTextKeyString;
    NSString *theRewardIsTextBOOLNumberKeyString;
    if (self.activeRewardButton == self.reward1Button) {
        
        theRewardTextKeyString = GGKReward1TextKeyString;
        theRewardIsTextBOOLNumberKeyString = GGKReward1IsTextBOOLNumberKeyString;
    } else if (self.activeRewardButton == self.reward2Button) {
        
        theRewardTextKeyString = GGKReward2TextKeyString;
        theRewardIsTextBOOLNumberKeyString = GGKReward2IsTextBOOLNumberKeyString;
    } else if (self.activeRewardButton == self.reward3Button) {
        
        theRewardTextKeyString = GGKReward3TextKeyString;
        theRewardIsTextBOOLNumberKeyString = GGKReward3IsTextBOOLNumberKeyString;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:theRewardText forKey:theRewardTextKeyString];
    
    NSNumber *aBOOLNumber = [NSNumber numberWithBool:YES];
    [[NSUserDefaults standardUserDefaults] setObject:aBOOLNumber forKey:theRewardIsTextBOOLNumberKeyString];
}

- (void)showActionSheetForAddingReward:(UIButton *)theButton
{
    self.activeRewardButton = theButton;
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
    
    NSString *theKey;
    if (theTextField == self.numberOfSuccessesForReward1TextField) {
        
        theKey = GGKNumberOfSuccessesForReward1KeyString;
    } else if (theTextField == self.numberOfSuccessesForReward2TextField) {
        
        theKey = GGKNumberOfSuccessesForReward2KeyString;
    } else if (theTextField == self.numberOfSuccessesForReward3TextField) {
        
        theKey = GGKNumberOfSuccessesForReward3KeyString;
    }
    [[NSUserDefaults standardUserDefaults] setObject:anOkayValue forKey:theKey];
    
    self.activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return NO;
}

- (void)updateLabels
{
    // Show number of successful potties.
    // Note: Wanted to show star emoji at arbitrarily large font size. However, couldn't get it to work in the text view. Perhaps under iOS 6+, especially with attributed text, it might work. Also, if we just want a bigger star, it works for non-emoji Unicode stars, such as \u2605.
    
    // Does not work. Emoji are not bigger and are cut off.
//    self.successfulPottiesTextView.font = [UIFont fontWithName:@"AppleColorEmoji" size:40.0];
//    self.successfulPottiesTextView.text = @"\u2B50";
    
    NSArray *aPottyAttemptDayArray = [[NSUserDefaults standardUserDefaults] objectForKey:GGKPottyAttemptsKeyString];
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
        
        theNumberOfSuccessfulPottiesString = [NSString stringWithFormat:@"%d", theNumberOfSuccessesInteger];
    }
    self.successfulPottiesLabel.text = [NSString stringWithFormat:@"Successful potties: %@", theNumberOfSuccessfulPottiesString];
    
    NSMutableString *aCheckMarkForEachSuccessfulPottyMutableString = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < theNumberOfSuccessesInteger; i++) {
        
        [aCheckMarkForEachSuccessfulPottyMutableString appendString:GGKStarRewardString];
    }
    self.successfulPottiesTextView.text = aCheckMarkForEachSuccessfulPottyMutableString;
    
    // Show each reward: The number of successes needed, and the text or image describing the reward.
    NSArray *theRewardButtonsArray = @[self.reward1Button, self.reward2Button, self.reward3Button];
    [theRewardButtonsArray enumerateObjectsUsingBlock:^(UIButton *theRewardButton, NSUInteger idx, BOOL *stop) {
        
        NSString *theNumberOfSuccessesForRewardKeyString;
        NSInteger theDefaultNumberOfSuccessesForRewardInteger;
        UITextField *theTextField;
        NSString *theRewardIsTextBOOLNumberKeyString;
        NSString *theRewardTextKeyString;
        NSString *theRewardImageNameString;
        if (theRewardButton == self.reward1Button) {
            
            theNumberOfSuccessesForRewardKeyString = GGKNumberOfSuccessesForReward1KeyString;
            theDefaultNumberOfSuccessesForRewardInteger = GGKDefaultNumberOfSuccessesForReward1Integer;
            theTextField = self.numberOfSuccessesForReward1TextField;
            theRewardIsTextBOOLNumberKeyString = GGKReward1IsTextBOOLNumberKeyString;
            theRewardTextKeyString = GGKReward1TextKeyString;
            theRewardImageNameString = GGKReward1ImageNameString;
        } else if (theRewardButton == self.reward2Button) {
            
            theNumberOfSuccessesForRewardKeyString = GGKNumberOfSuccessesForReward2KeyString;
            theDefaultNumberOfSuccessesForRewardInteger = GGKDefaultNumberOfSuccessesForReward2Integer;
            theTextField = self.numberOfSuccessesForReward2TextField;
            theRewardIsTextBOOLNumberKeyString = GGKReward2IsTextBOOLNumberKeyString;
            theRewardTextKeyString = GGKReward2TextKeyString;
            theRewardImageNameString = GGKReward2ImageNameString;
        } else if (theRewardButton == self.reward3Button) {
            
            theNumberOfSuccessesForRewardKeyString = GGKNumberOfSuccessesForReward3KeyString;
            theDefaultNumberOfSuccessesForRewardInteger = GGKDefaultNumberOfSuccessesForReward3Integer;
            theTextField = self.numberOfSuccessesForReward3TextField;
            theRewardIsTextBOOLNumberKeyString = GGKReward3IsTextBOOLNumberKeyString;
            theRewardTextKeyString = GGKReward3TextKeyString;
            theRewardImageNameString = GGKReward3ImageNameString;
        }
        
        NSNumber *theNumberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:theNumberOfSuccessesForRewardKeyString];
        if (theNumberOfSuccessesForRewardNumber == nil) {
            
            theNumberOfSuccessesForRewardNumber = @(theDefaultNumberOfSuccessesForRewardInteger);
        }
        theTextField.text = [theNumberOfSuccessesForRewardNumber stringValue];
        
        // Check whether the reward is text or an image. If neither (nil), then use the default in the storyboard.
        NSNumber *theRewardIsTextBOOLNumber = [[NSUserDefaults standardUserDefaults] objectForKey:theRewardIsTextBOOLNumberKeyString];
        if (theRewardIsTextBOOLNumber != nil) {
            
            BOOL theRewardIsTextBOOL = [theRewardIsTextBOOLNumber boolValue];
            if (theRewardIsTextBOOL) {
                
                // Load the text and show it in the button.
                NSString *theRewardString = [[NSUserDefaults standardUserDefaults] objectForKey:theRewardTextKeyString];
                [theRewardButton setTitle:theRewardString forState:UIControlStateNormal];
            } else {
                
                // Load the image and show it in the button.
                NSFileManager *aFileManager = [[NSFileManager alloc] init];
                NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
                NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
                NSString *theImagePathComponentString = [NSString stringWithFormat:@"/%@.png", theRewardImageNameString];
                NSURL *theFileURL = [aDirectoryURL URLByAppendingPathComponent:theImagePathComponentString];
                NSData *theImageData = [NSData dataWithContentsOfURL:theFileURL];
                UIImage *theImage = [[UIImage alloc] initWithData:theImageData];
                [theRewardButton setImage:theImage forState:UIControlStateNormal];
            }
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.soundModel = [[GGKSoundModel alloc] init];
    
    // Observe keyboard notifications to shift the screen up/down appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.successfulPottiesTextView.backgroundColor = [UIColor clearColor];
    self.successfulPottiesTextView.textColor = [UIColor greenColor];
    
    [self updateLabels];
}

//- (void)viewWillAppear:(BOOL)animated
//{    
//    [super viewWillAppear:animated];
//    
//    
//}

@end
