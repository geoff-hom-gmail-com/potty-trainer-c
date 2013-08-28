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

- (IBAction)cancel
{
    [self.delegate addRewardTextViewControllerDidCancel:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate addRewardTextViewControllerDidEnterText:self];
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.textField.delegate = self;
}

@end
