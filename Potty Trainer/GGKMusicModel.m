//
//  GGKMusicModel.m
//  Perfect Potty
//
//  Created by Geoff Hom on 2/3/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//
#import "GGKMusicModel.h"

NSString *GGKEnableMusicBOOLKeyString = @"Enable music?";

@interface GGKMusicModel ()
// For playing a UI sound when the player presses a button.
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation GGKMusicModel
- (id)init {
    self = [super init];
    if (self) {
        // Load whether user wanted music on or off.
        self.musicIsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:GGKEnableMusicBOOLKeyString];
        // Load intro/main music.
        NSString *soundFilePath = [ [NSBundle mainBundle] pathForResource:@"Perfect Potty - Intro Main Menu Music" ofType:@"m4a" ];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        AVAudioPlayer *anAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        anAudioPlayer.numberOfLoops = -1;
//        anAudioPlayer.delegate = self;
        self.audioPlayer = anAudioPlayer;
        [self.audioPlayer prepareToPlay];
    }
    return self;
}
- (void)playIntroMusic {
    if (self.musicIsEnabled) {
        // Pause before restarting music. Doesn't seem to make aural difference, but avoids AudioQueue warning.
        [self.audioPlayer pause];
        self.audioPlayer.currentTime = 0;
        [self.audioPlayer play];
    }
}
- (void)toggleMusic {
    // If music is on, then stop playing. Else, play.
    if (self.musicIsEnabled) {
        self.musicIsEnabled = NO;
        [self.audioPlayer pause];
    } else {
        self.musicIsEnabled = YES;
        [self playIntroMusic];
    }
    // Save the change.
    [[NSUserDefaults standardUserDefaults] setBool:self.musicIsEnabled forKey:GGKEnableMusicBOOLKeyString];
}
@end
