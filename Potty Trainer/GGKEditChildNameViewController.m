//
//  GGKEditChildNameViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/28/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKEditChildNameViewController.h"

@interface GGKEditChildNameViewController ()

@end

@implementation GGKEditChildNameViewController

- (IBAction)cancel
{
    [self.delegate editChildNameViewControllerDidCancel:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate editChildNameViewControllerDidEnterText:self];
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textField.text = self.childToEdit.nameString;
}

@end
