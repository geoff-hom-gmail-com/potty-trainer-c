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
@property (nonatomic, weak) IBOutlet UITextField *textField;

// Add child to database.
- (IBAction)addChild:(id)sender;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
// So: If name is already taken, alert user.

// Override.
- (void)viewDidLoad;

@end
