//
//  GGKMusicModel.h
//  Perfect Potty
//
//  Created by Geoff Hom on 2/3/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

// Save-data key: whether music is enabled.
extern NSString *GGKEnableMusicBOOLKeyString;

@interface GGKMusicModel : NSObject <AVAudioPlayerDelegate>
// Whether this app's music should play or not.
@property (assign, nonatomic) BOOL musicIsEnabled;
// Create the audio player.
- (id)init;
// Play main/intro/background music, from the start.
- (void)playIntroMusic;
// Toggle background music.
- (void)toggleMusic;
@end
