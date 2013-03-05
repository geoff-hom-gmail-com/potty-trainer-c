//
//  GGKPottyTrainerViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/4/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPickBackgroundColorViewController.h"
#import "GGKPottyTrainerViewController.h"

@interface GGKPottyTrainerViewController ()

@property (strong, nonatomic) GGKPickBackgroundColorViewController *pickBackgroundColorViewController;

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

@end

@implementation GGKPottyTrainerViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonSound
{
    [self.soundModel playButtonTapSound];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.soundModel = [[GGKSoundModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Check theme.
    NSString *theThemeString = [[NSUserDefaults standardUserDefaults] objectForKey:GGKThemeKeyString];
    if ([theThemeString isEqualToString:GGKBoyThemeString]) {
        
        self.view.backgroundColor = [UIColor cyanColor];
    } else if ([theThemeString isEqualToString:GGKGirlThemeString]) {
        
        self.view.backgroundColor = [UIColor pinkColor];
    } else {
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

@end
