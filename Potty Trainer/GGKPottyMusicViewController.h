//
//  GGKPottyMusicViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 2/17/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//
// Play music to encourage going potty.

#import "GGKViewController.h"

@interface GGKPottyMusicViewController : GGKViewController

// Start/stop button was tapped. Music may start or be stopped.
- (IBAction)handleStartOrStopButtonTapped:(UIButton *)theButton;
// Override.
// This view disappeared, so stop any potty music.
- (void)viewDidDisappear:(BOOL)animated;
// Override.
- (void)viewDidLoad;
@end
