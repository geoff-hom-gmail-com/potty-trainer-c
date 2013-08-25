//
//  GGKReward.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/24/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGKReward : NSObject

// When the reward uses an image (vs text), this is the filename (prefix) to use. The image is in the user's documents directory, and the suffix is ".png." If the image doesn't exist, use text.
@property (strong, nonatomic) NSString *imageName;

// Successes needed to earn reward. Managed by user.
@property (assign, nonatomic) NSInteger numberOfSuccessesNeededInteger;

// If the reward uses text (vs image), this is it. 
@property (strong, nonatomic) NSString *text;

// Override.
- (id)init;

@end
