//
//  GGKPickBackgroundColorViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/19/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import <UIKit/UIKit.h>

@interface GGKPickBackgroundColorViewController : GGKViewController

// Set the color theme to one for boys.
- (IBAction)useBoyTheme;

// Set the color theme to default (boy/girl neutral).
- (IBAction)useDefaultTheme;

// Set the color theme to one for girls.
- (IBAction)useGirlTheme;

// UIViewController override.
- (void)viewDidLoad;

// UIViewController override.
- (void)viewWillAppear:(BOOL)animated;

@end
