//
//  GGKSettingsViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 3/24/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//
#import "GGKSettingsViewController.h"

#import "GGKPerfectPottyAppDelegate.h"
@interface GGKSettingsViewController ()
@end
@implementation GGKSettingsViewController
- (void)handleViewWillAppearToUser {
    [super handleViewWillAppearToUser];
    GGKPerfectPottyAppDelegate *aPottyTrainerAppDelegate = (GGKPerfectPottyAppDelegate *)[UIApplication sharedApplication].delegate;
    self.musicSwitch.on = aPottyTrainerAppDelegate.musicModel.musicIsEnabled;
}
- (IBAction)toggleMusic {
    GGKPerfectPottyAppDelegate *aPottyTrainerAppDelegate = (GGKPerfectPottyAppDelegate *)[UIApplication sharedApplication].delegate;
    [aPottyTrainerAppDelegate.musicModel toggleMusic];
}
@end
