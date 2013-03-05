//
//  GGKPickChildViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/19/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPickChildViewController.h"

@class GGKSoundModel;

@interface GGKPickChildViewController ()

// The color to use for a boy theme.
@property (strong, nonatomic) UIColor *boyColor;

// The color to use for a girl theme.
@property (strong, nonatomic) UIColor *girlColor;

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

// Update the colors according to the current theme.
- (void)updateColors;

@end

@implementation GGKPickChildViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)playButtonSound
{
    [self.soundModel playButtonTapSound];
}

- (void)updateColors
{
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

- (IBAction)useBoyTheme
{    
    [[NSUserDefaults standardUserDefaults] setObject:GGKBoyThemeString forKey:GGKThemeKeyString];
    [self updateColors];    
}

- (IBAction)useDefaultTheme
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:GGKThemeKeyString];
    [self updateColors];
}

- (IBAction)useGirlTheme
{    
    [[NSUserDefaults standardUserDefaults] setObject:GGKGirlThemeString forKey:GGKThemeKeyString];
    [self updateColors];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.boyColor = [UIColor cyanColor];
//    self.girlColor = [UIColor pinkColor];
    self.soundModel = [[GGKSoundModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self updateColors];
}

@end
