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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldDidEndEditing called");
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"textFieldShouldReturn called");
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
