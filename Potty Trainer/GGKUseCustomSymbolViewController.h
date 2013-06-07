//
//  GGKUseCustomSymbolViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 6/6/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

@interface GGKUseCustomSymbolViewController : GGKViewController <UITextFieldDelegate>

// For entering the symbol.
@property (nonatomic, weak) IBOutlet UITextField *symbolTextField;

- (void)textFieldDidEndEditing:(UITextField *)textField;
// So, if an invalid value was entered, then use the previous value.

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
// So, dismiss the keyboard.

// Override.
- (void)viewDidLoad;

@end
