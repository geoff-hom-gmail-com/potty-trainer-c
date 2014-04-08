//
//  GGKAddChildViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/28/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

@interface GGKAddChildViewController : GGKViewController <UITextFieldDelegate>
// For entering the text.
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
// If not editing textfield, add child. Else, mimic tapping return key.
- (IBAction)handleDoneButtonTapped:(id)sender;
// If current name is valid, then add child. If name is blank/duplicate, alert user.
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField;
// Override.
- (void)viewDidLoad;
@end
