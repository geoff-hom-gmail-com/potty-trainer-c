//
//  GGKSoundModel.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/20/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKSoundModel.h"

@interface GGKSoundModel ()

// For playing a UI sound when the player presses a button.
@property (nonatomic, strong) AVAudioPlayer *buttonTapAudioPlayer;

@end

@implementation GGKSoundModel

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    BOOL wasSuccessful = [audioSession setActive:NO error:&error];
    if (!wasSuccessful) {
        
        NSLog(@"SM audioPlayerDidFinishPlaying: audio session deactivation error: %@", error.localizedDescription);
    }
}
- (id)init {
    self = [super init];
    if (self) {
        self.soundIsOn = YES;
        // Button-tap sound.
        NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:@"tap-mono-s16K" withExtension:@"caf"];
        AVAudioPlayer *anAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        anAudioPlayer.delegate = self;
        self.buttonTapAudioPlayer = anAudioPlayer;
        // The button-tap sound will be needed first.
        [self prepareButtonTapSound];
        // Deactivate audio session. The user may have her device set so that the hardware volume buttons control  the "Ringer and Alerts" volume. When our audio session is active, that won't work.
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error;
        BOOL wasSuccessful = [audioSession setActive:NO error:&error];
        if (!wasSuccessful) {
            NSLog(@"SM init: audio session deactivation error: %@", error.localizedDescription);
        }
    }
    return self;
}
- (void)playButtonTapSound
{    
    if (self.soundIsOn) {
        
        [self.buttonTapAudioPlayer play];
    }
}

- (void)prepareButtonTapSound
{    
    [self.buttonTapAudioPlayer prepareToPlay];
}

@end
