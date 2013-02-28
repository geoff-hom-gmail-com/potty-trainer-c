//
//  GGKPottyTrainerViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/4/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GGKPottyTrainerViewController : UIViewController

// Play sound as aural feedback for pressing button.
- (IBAction)playButtonSound;

// UIViewController override.
- (void)viewDidLoad;

// UIViewController override.
- (void)viewWillAppear:(BOOL)animated;

@end
