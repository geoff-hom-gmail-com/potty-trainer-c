//
//  GGKSoundModel.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/20/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKSoundModel.h"

#import "GGKPerfectPottyAppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface GGKSoundModel ()

// For playing a UI sound to get the user's attention, in a positive way.
@property (nonatomic, strong) AVAudioPlayer *alert2AudioPlayer;

// For playing a UI sound when the player presses a button.
@property (nonatomic, strong) AVAudioPlayer *buttonTapAudioPlayer;

// For playing a UI sound to get the user's attention, in a positive way.
@property (nonatomic, strong) AVAudioPlayer *dingAudioPlayer;

@end

@implementation GGKSoundModel

- (id)init
{    
    self = [super init];
    if (self) {
        
        self.soundIsOn = YES;
        
        // Implicitly initialize audio session. Default settings seem fine, though.
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        NSString *soundFilePath;
        NSURL *soundFileURL;
        AVAudioPlayer *anAudioPlayer;
        
        // Alert2 sound.
        soundFilePath = [ [NSBundle mainBundle] pathForResource:@"alert2" ofType:@"aiff" ];
        soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        anAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.alert2AudioPlayer = anAudioPlayer;
        
        // Ding sound.
        soundFilePath = [ [NSBundle mainBundle] pathForResource:@"scoreIncrease" ofType:@"aiff" ];
        soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        anAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.dingAudioPlayer = anAudioPlayer;
        
        // Button-tap sound.
        soundFilePath = [ [NSBundle mainBundle] pathForResource:@"tap" ofType:@"aif" ];
        soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        anAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.buttonTapAudioPlayer = anAudioPlayer;
        
        // The button-tap sound will be needed first.
        [self prepareButtonTapSound];
    }
    return self;
}

- (void)playAlert2Sound
{
    if (self.soundIsOn) {
        
        // Volume = max.
        self.alert2AudioPlayer.volume = 1;
        [self.alert2AudioPlayer play];
    }
}

- (void)playButtonTapSound
{    
    if (self.soundIsOn) {
        
        [self.buttonTapAudioPlayer play];
    }
}

- (void)playDingSound
{
    if (self.soundIsOn) {
        
        // Volume = max.
        self.dingAudioPlayer.volume = 1;
        [self.dingAudioPlayer play];
    }
}

- (void)prepareButtonTapSound
{    
    [self.buttonTapAudioPlayer prepareToPlay];
}

@end
