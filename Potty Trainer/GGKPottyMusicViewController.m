//
//  GGKPottyMusicViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 2/17/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKPottyMusicViewController.h"

@interface GGKPottyMusicViewController ()

@end

@implementation GGKPottyMusicViewController
- (IBAction)handleStartOrStopButtonTapped:(UIButton *)theButton {
    if ([self.musicModel.pottyMusicStateString isEqualToString:GGKPottyMusicStoppedStateString]) {
        [self.musicModel playPottyMusic];
        [theButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else if ([self.musicModel.pottyMusicStateString isEqualToString:GGKPottyMusicStartedStateString]) {
        [self.musicModel stopPottyMusic];
        [theButton setTitle:@"Start" forState:UIControlStateNormal];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.musicModel.pottyMusicStateString isEqualToString:GGKPottyMusicStartedStateString]) {
        [self.musicModel stopPottyMusic];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
@end
