//
//  GGKUseCustomSymbolViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 6/6/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

@protocol GGKUseCustomSymbolViewControllerDelegate

// Sent after the user chose a custom symbol.
- (void)useCustomSymbolViewControllerDidChooseSymbol:(id)sender;

@end

@interface GGKUseCustomSymbolViewController : GGKViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <GGKUseCustomSymbolViewControllerDelegate> delegate;

// For entering the symbol.
@property (nonatomic, weak) IBOutlet UITextField *symbolTextField;

// Save the symbol. Notify delegate.
- (IBAction)saveSymbol;

//- (void)textFieldDidEndEditing:(UITextField *)textField;
// So, if an invalid value was entered, then use the previous value.

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
// So, dismiss the keyboard.

// Override.
- (void)viewDidLoad;

@end
