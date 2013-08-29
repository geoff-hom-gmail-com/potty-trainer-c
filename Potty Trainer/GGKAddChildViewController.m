//
//  GGKAddChildViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/28/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAddChildViewController.h"

@interface GGKAddChildViewController ()

@end

@implementation GGKAddChildViewController

- (IBAction)addChild:(id)sender
{
    GGKChild *newChild = [self.perfectPottyModel addChildWithName:self.textField.text];
    [self.perfectPottyModel saveChildren];
    
    self.perfectPottyModel.currentChild = newChild;
    [self.perfectPottyModel saveCurrentChildName];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn;
    NSString *newName = textField.text;
    
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
        
        [textField resignFirstResponder];
        shouldReturn = YES;
    }
    return shouldReturn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Prepopulate text field with a name that could work.
    NSInteger numberOfChildrenAfterAddition = [self.perfectPottyModel.childrenMutableArray count] + 1;
    NSString *genericName = [NSString stringWithFormat:@"Anon%d", numberOfChildrenAfterAddition];
    self.textField.text = genericName;
}

@end
