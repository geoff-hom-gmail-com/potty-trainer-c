//
//  GGKSoundModel.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/20/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GGKSoundModel : NSObject <AVAudioPlayerDelegate>

// Whether this app's sound should play or not.
@property (assign, nonatomic) BOOL soundIsOn;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
// So, deactivate the audio session.

// Create the audio player for each sound.
- (id)init;

// Play sound appropriate for a button press.
- (void)playButtonTapSound;

// Prepare the appropriate audio player to play.
- (void)prepareButtonTapSound;

@end
