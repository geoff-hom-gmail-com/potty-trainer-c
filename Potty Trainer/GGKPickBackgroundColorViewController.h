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
// Override.
- (void)handleViewWillAppearToUser;
// Set the color theme to one for boys.
- (IBAction)useBoyTheme;

// Set the color theme to default (boy/girl neutral).
- (IBAction)useDefaultTheme;

// Set the color theme to one for girls.
- (IBAction)useGirlTheme;
@end
