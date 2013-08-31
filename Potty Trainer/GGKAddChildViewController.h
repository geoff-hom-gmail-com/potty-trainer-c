//
//  GGKAddChildViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/28/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

@interface GGKAddChildViewController : GGKViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

// For entering the text.
@property (weak, nonatomic) IBOutlet UITextField *textField;

// Add child to database.
- (IBAction)addChild:(id)sender;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
// So: disable Done button.

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
// So: If name is already taken, alert user.

// Override.
- (void)viewDidLoad;

@end
