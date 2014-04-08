//
//  GGKReward.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/24/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGKReward : NSObject
@property (strong, nonatomic) NSData *imageData;
// When the reward uses an image (vs text), this is the filename (prefix) to use. The image is in the user's documents directory, and the suffix is ".png." If the image doesn't exist, use text.
// Note that the filename is not set upon init. The class that creates the reward should set an appropriate filename.
@property (strong, nonatomic) NSString *imageName;
// Successes needed to earn reward. Managed by user.
@property (assign, nonatomic) NSInteger numberOfSuccessesNeededInteger;
// If the reward uses text (vs image), this is it. 
@property (strong, nonatomic) NSString *text;
// Remove reward-image from disk and memory.
- (void)deleteImage;
// Override.
- (void)encodeWithCoder:(NSCoder *)encoder;
// Override.
- (id)init;
// Override.
- (id)initWithCoder:(NSCoder *)decoder;
// Load reward-image from disk and keep in the imageData property.
- (void)loadImage;
// Save reward-image to disk.
- (void)saveImage;
@end
// Return whether the reward is an image (vs text).
//- (BOOL)isImage;
