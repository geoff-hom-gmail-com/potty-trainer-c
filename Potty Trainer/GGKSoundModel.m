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
@property (nonatomic) AVAudioPlayer *buttonTapAudioPlayer;

@end

@implementation GGKSoundModel

- (id)init
{    
    self = [super init];
    if (self) {
        
        self.soundIsOn = YES;
        
        // Button-tap sound.
        NSString *soundFilePath = [ [NSBundle mainBundle] pathForResource:@"tap" ofType:@"aif" ];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        AVAudioPlayer *anAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.buttonTapAudioPlayer = anAudioPlayer;
        
        // The button-tap sound will be needed first.
        [self prepareButtonTapSound];
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
