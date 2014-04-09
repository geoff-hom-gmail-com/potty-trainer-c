//
//  GGKAddRewardTextViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 3/1/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAddRewardTextViewController.h"

@interface GGKAddRewardTextViewController ()

@end

@implementation GGKAddRewardTextViewController

- (IBAction)cancel {
    [self.delegate addRewardTextViewControllerDidCancel:self];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    // Make sure reward name is good.
    NSCharacterSet *aCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *aTrimmedString = [theTextField.text stringByTrimmingCharactersInSet:aCharacterSet];
    if ([aTrimmedString length] == 0) {
        NSString *alertMessageString = @"Please enter a non-blank name.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Name Is Blank" message:alertMessageString delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    } else {
        [self.delegate addRewardTextViewControllerDidEnterText:self];
    }
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.nameTextField.delegate = self;
    self.nameTextField.text = self.previousNameString;
}
@end
