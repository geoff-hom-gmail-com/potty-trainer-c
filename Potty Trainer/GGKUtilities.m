//
//  GGKUtilities.m
//  example Same-Value Segmented Control
//
//  Created by Geoff Hom on 4/1/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKUtilities.h"

@implementation GGKUtilities
+ (void)addBorderToView:(UIView *)theView {
    theView.layer.borderWidth = 1.0f;
    theView.layer.borderColor = theView.tintColor.CGColor;
    theView.layer.cornerRadius = 3.0f;
}
+ (BOOL)iOSisBelow7 {
    // From Apple iOS 7 UI Transition Guide: https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TransitionGuide/SupportingEarlieriOS.html
    return floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1;
}
@end
