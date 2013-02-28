//
//  UIView+GGKAdditions.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/27/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "UIView+GGKAdditions.h"

@implementation UIView (GGKAdditions)

- (void)sizeToFitWhileKeepingCenter {
    
//    // Resize, recenter.
//    CGPoint oldCenter = self.center;
//    NSLog(@"old size:%@", NSStringFromCGSize(self.frame.size));
//    CGSize testSize = [self sizeThatFits:self.frame.size];
//    NSLog(@"new size:%@", NSStringFromCGSize(testSize));
//    NSLog(@"old center:%@", NSStringFromCGPoint(self.center));
//    [self sizeToFit];
//    self.center = CGPointMake(oldCenter.x, self.center.y);
//    
//    // Round the origin so text appears sharp. Then adjust the size so the center is the same. We round down for the origin so the size will increase.
//    // alt: I could increase the size such that if I keep the center, the origin will be integers. so adjust the size, then just set the center to be the same. how does one change the size without affecting the origin? (origin without size is center).
//    CGPoint oldOrigin = self.frame.origin;
//    CGPoint newOrigin = CGPointMake( floorf(oldOrigin.x), floorf(oldOrigin.y) );
//    CGSize viewSize = self.frame.size;
//    viewSize.width += 2 * (oldOrigin.x - newOrigin.x);
//    viewSize.height += 2 * (oldOrigin.y - newOrigin.y);
//    self.frame = CGRectMake(newOrigin.x, newOrigin.y, viewSize.width, viewSize.height);
}

@end
