//
//  GGKSettingsViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 3/24/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//
#import "GGKViewController.h"
@interface GGKSettingsViewController : GGKViewController
// For toggling background music.
@property (nonatomic, weak) IBOutlet UISwitch *musicSwitch;
// Override.
- (void)handleViewWillAppearToUser;
// Toggle background music.
- (IBAction)toggleMusic;
@end
