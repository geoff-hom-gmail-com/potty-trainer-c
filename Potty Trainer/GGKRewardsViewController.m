//
//  GGKRewardsViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKRewardsViewController.h"

const NSInteger GGKDefaultNumberOfSuccessesForReward1Integer = 5;

const NSInteger GGKDefaultNumberOfSuccessesForReward2Integer = 10;

const NSInteger GGKDefaultNumberOfSuccessesForReward3Integer = 15;

NSString *GGKNumberOfSuccessesForReward1KeyString = @"Number of successes for reward 1";

NSString *GGKNumberOfSuccessesForReward2KeyString = @"Number of successes for reward 2";

NSString *GGKNumberOfSuccessesForReward3KeyString = @"Number of successes for reward 3";

@interface GGKRewardsViewController ()

// The text field currently being edited.
@property (strong, nonatomic) UITextField *activeTextField;

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

- (void)keyboardWillHide:(NSNotification *)theNotification;
// So, shift the view back to normal.

- (void)keyboardWillShow:(NSNotification *)theNotification;
// So, shift the view up, if necessary.

// Display an action sheet so the user can choose whether to use text or a photo to show the reward.
- (void)showActionSheetForAddingReward:(UIButton *)theButton;

// Update labels in case they changed.
- (void)updateLabels;

@end

@implementation GGKRewardsViewController

- (void)actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)theButtonIndex
{
    ;
    // So, let the user pick a photo, or enter text.
    NSString *theButtonTitleString = [theActionSheet buttonTitleAtIndex:theButtonIndex];
    
    // use a string constant here
    if ([theButtonTitleString isEqualToString:@"Use text"]) {
        
        NSLog(@"use text clicked");
        
        // use a string constant here
    } else if ([theButtonTitleString isEqualToString:@"Use photo"]) {
        
        NSLog(@"use photo clicked");
        // call photo picker or something
    }
}

- (IBAction)addReward:(UIButton *)theButton
{
    [self showActionSheetForAddingReward:theButton];
}

- (void)dealloc
{
    // Don't need super.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)showActionSheetForAddingReward:(UIButton *)theButton
{
    UIActionSheet *anActionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Reward" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use text", @"Use photo", nil];
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
    
    NSString *theKey;
    if (theTextField == self.numberOfSuccessesForReward1TextField) {
        
        theKey = GGKNumberOfSuccessesForReward1KeyString;
    } else if (theTextField == self.numberOfSuccessesForReward2TextField) {
        
        theKey = GGKNumberOfSuccessesForReward2KeyString;
    } else if (theTextField == self.numberOfSuccessesForReward3TextField) {
        
        theKey = GGKNumberOfSuccessesForReward3KeyString;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:anOkayValue forKey:theKey];
    [self updateLabels];
    
    self.activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return NO;
}

- (void)updateLabels
{
    // Get number of successful potties.
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
    
    // Unicode check mark: \u2714. (Other check marks: \u2705, \u2713, \u2611.)
    NSString *aCheckMarkString = @"\u2714";
    
    NSMutableString *aCheckMarkForEachSuccessfulPottyMutableString = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < theNumberOfSuccessesInteger; i++) {
        
        [aCheckMarkForEachSuccessfulPottyMutableString appendString:aCheckMarkString];
    }
    self.successfulPottiesTextView.text = aCheckMarkForEachSuccessfulPottyMutableString;
    
    NSNumber *theNumberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:GGKNumberOfSuccessesForReward1KeyString];
    if (theNumberOfSuccessesForRewardNumber == nil) {
        
        theNumberOfSuccessesForRewardNumber = @(GGKDefaultNumberOfSuccessesForReward1Integer);
    }
    self.numberOfSuccessesForReward1TextField.text = [theNumberOfSuccessesForRewardNumber stringValue];
    
    theNumberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:GGKNumberOfSuccessesForReward2KeyString];
    if (theNumberOfSuccessesForRewardNumber == nil) {
        
        theNumberOfSuccessesForRewardNumber = @(GGKDefaultNumberOfSuccessesForReward2Integer);
    }
    self.numberOfSuccessesForReward2TextField.text = [theNumberOfSuccessesForRewardNumber stringValue];
    
    theNumberOfSuccessesForRewardNumber = [[NSUserDefaults standardUserDefaults] objectForKey:GGKNumberOfSuccessesForReward3KeyString];
    if (theNumberOfSuccessesForRewardNumber == nil) {
        
        theNumberOfSuccessesForRewardNumber = @(GGKDefaultNumberOfSuccessesForReward3Integer);
    }
    self.numberOfSuccessesForReward3TextField.text = [theNumberOfSuccessesForRewardNumber stringValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.soundModel = [[GGKSoundModel alloc] init];
    
    // Observe keyboard notifications to shift the screen up/down appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    
    [self updateLabels];
}

@end
