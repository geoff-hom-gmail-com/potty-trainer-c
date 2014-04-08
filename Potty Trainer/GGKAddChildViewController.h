//
//  GGKAddChildViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/28/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

@interface GGKAddChildViewController : GGKViewController <UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UIButton *doneButton;
// For entering the text.
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
// If not editing textfield, add child. Else, mimic tapping return key.
- (IBAction)handleDoneButtonTapped:(id)sender;
// Add child.
- (void)textFieldDidEndEditing:(UITextField *)theTextField;
// If current name is valid, then return. If name is blank/duplicate, alert user.
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField;
// Override.
- (void)viewDidLoad;
@end
//- (void)textFieldDidBeginEditing:(UITextField *)textField;
// So: disable Done button.
