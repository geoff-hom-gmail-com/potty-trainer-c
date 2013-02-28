//
//  UIView+GGKAdditions.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/27/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GGKAdditions)

// Shrink the view to fit contents, but retain horizontal center. Also makes sure origin is integer, so text looks sharp.
- (void)sizeToFitWhileKeepingCenter;

@end
