//
//  GGKPickChildViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/19/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGKPickChildViewController : UIViewController

// Play sound as aural feedback for pressing button.
- (IBAction)playButtonSound;

// Set the color theme to one for boys.
- (IBAction)useBoyTheme;

// Set the color theme to one for girls.
- (IBAction)useGirlTheme;

// UIViewController override.
- (void)viewDidLoad;

// UIViewController override.
- (void)viewWillAppear:(BOOL)animated;

@end
