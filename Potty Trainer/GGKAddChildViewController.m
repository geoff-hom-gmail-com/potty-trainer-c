//
//  GGKAddChildViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/28/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAddChildViewController.h"

@interface GGKAddChildViewController ()
// Add child to database.
- (void)addChild;
@end

@implementation GGKAddChildViewController
- (void)addChild {
    GGKChild *newChild = [self.perfectPottyModel addChildWithName:self.nameTextField.text];
    self.perfectPottyModel.currentChild = newChild;
    [self.perfectPottyModel saveCurrentChildID];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)handleDoneButtonTapped:(id)sender {
    if (!self.nameTextField.isEditing) {
        [self addChild];
    } else {
        [self.nameTextField.delegate textFieldShouldReturn:self.nameTextField];
    }
}

//- (void)textFieldDidBeginEditing:(UITextField *)theTextField {
////    self.doneButton.enabled = NO;
//}
- (void)textFieldDidEndEditing:(UITextField *)theTextField {
    NSLog(@"textFieldDidEndEditing1");

//    [self addChild];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    NSLog(@"textFieldShouldReturn1");
    BOOL shouldReturn;
    NSString *newName = theTextField.text;
    // If duplicate name, or if blank name, alert user.
    __block BOOL isDuplicate = NO;
    [self.perfectPottyModel.childrenMutableArray enumerateObjectsUsingBlock:^(GGKChild *aChild, NSUInteger idx, BOOL *stop) {
        if ([aChild.nameString isEqualToString:newName]) {
            isDuplicate = YES;
            *stop = YES;
        }
    }];
    BOOL isBlank = NO;
    if ([newName isEqualToString:@""]) {
        isBlank = YES;
    }
    if (isDuplicate) {
        NSString *alertMessageString = [NSString stringWithFormat:@"Another child has the name \"%@.\" Please choose a unique name.", newName];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Name Already Exists" message:alertMessageString delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        shouldReturn = NO;
    } else if (isBlank) {
        NSString *alertMessageString = @"Please enter a unique name.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Name Is Blank" message:alertMessageString delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        shouldReturn = NO;
    } else {
        // User has entered a valid name. If user edits this textfield, don't clear. And now show the clear button always.
//        theTextField.clearsOnBeginEditing = NO;
//        theTextField.clearButtonMode = UITextFieldViewModeAlways;
        [theTextField resignFirstResponder];
        [self addChild];
        shouldReturn = YES;
//        self.doneButton.enabled = YES;
    }
    return shouldReturn;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Prepopulate text field with a name that could work. (I.e., not already used.)
    // Try "AnonymousX" for increasing X. If there are X children, we need to try at most X + 1 names.
    for (int i1 = 0; i1 < [self.perfectPottyModel.childrenMutableArray count] + 1; i1++) {
        
        // Start with "Anonymous2."
        NSInteger suffixInteger = i1 + 2;
        NSString *genericName = [NSString stringWithFormat:@"Anonymous%ld", (long)suffixInteger];
        __block BOOL isAlreadyUsed = NO;
        [self.perfectPottyModel.childrenMutableArray enumerateObjectsUsingBlock:^(GGKChild *aChild, NSUInteger idx, BOOL *stop) {
            
            if ([aChild.nameString isEqualToString:genericName]) {
                
                isAlreadyUsed = YES;
                *stop = YES;
            }
        }];
        if (!isAlreadyUsed) {
            
            self.nameTextField.text = genericName;
            break;
        }
    }    
}

@end
