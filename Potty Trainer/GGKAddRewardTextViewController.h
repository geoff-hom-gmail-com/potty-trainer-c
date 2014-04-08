//
//  GGKAddRewardTextViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 3/1/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import <UIKit/UIKit.h>

@protocol GGKAddRewardTextViewControllerDelegate
// Sent after the user cancelled.
- (void)addRewardTextViewControllerDidCancel:(id)sender;
// Sent after the user entered the reward text.
- (void)addRewardTextViewControllerDidEnterText:(id)sender;
@end

@interface GGKAddRewardTextViewController : GGKViewController <UITextFieldDelegate>
@property (weak, nonatomic) id <GGKAddRewardTextViewControllerDelegate> delegate;
// For entering the name of the reward.
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
// Name of previous reward.
@property (strong, nonatomic) NSString *previousNameString;
// Cancel entering the text.
- (IBAction)cancel;
// If blank name, alert user. Else, notify the delegate that the user entered text.
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField;
// Override.
- (void)viewDidLoad;
@end