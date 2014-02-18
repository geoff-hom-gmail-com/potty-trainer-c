//
//  GGKPottyTrainerViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/4/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKRootViewController.h"

#import "GGKPickBackgroundColorViewController.h"
#import "UIColor+GGKColors.h"

//BOOL GGKCreateLaunchImages = YES;
BOOL GGKCreateLaunchImages = NO;

@interface GGKRootViewController ()

@property (strong, nonatomic) GGKPickBackgroundColorViewController *pickBackgroundColorViewController;

@end

@implementation GGKRootViewController
- (void)handleViewWillAppearToUser {
    [super handleViewWillAppearToUser];
    NSString *theCurrentChildNameString = self.perfectPottyModel.currentChild.nameString;
    self.currentChildLabel.text = theCurrentChildNameString;
    NSString *theThemeString = self.perfectPottyModel.colorThemeString;
    if ([theThemeString isEqualToString:GGKBoyThemeString]) {
        self.view.backgroundColor = [UIColor cyanColor];
    } else if ([theThemeString isEqualToString:GGKGirlThemeString]) {
        self.view.backgroundColor = [UIColor pinkColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Make UI blank so we can make launch images via screenshot.
    if (GGKCreateLaunchImages) {
        self.navigationItem.title = @"";
        for (UIView *aSubView in self.view.subviews) {
            aSubView.hidden = YES;
        }
    }
}
@end
