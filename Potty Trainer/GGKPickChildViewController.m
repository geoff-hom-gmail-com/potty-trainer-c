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

- (IBAction)useBoyTheme {
    
    self.view.backgroundColor = self.boyColor;
    [[NSUserDefaults standardUserDefaults] setObject:GGKBoyThemeString forKey:GGKThemeKeyString];
}

- (IBAction)useGirlTheme {
    
    self.view.backgroundColor = self.girlColor;
    [[NSUserDefaults standardUserDefaults] setObject:GGKGirlThemeString forKey:GGKThemeKeyString];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.boyColor = [UIColor cyanColor];
    self.girlColor = [UIColor pinkColor];
    self.soundModel = [[GGKSoundModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Check theme.
    NSString *theThemeString = [[NSUserDefaults standardUserDefaults] objectForKey:GGKThemeKeyString];
    if ([theThemeString isEqualToString:GGKBoyThemeString]) {
        
        self.view.backgroundColor = self.boyColor;
    } else if ([theThemeString isEqualToString:GGKGirlThemeString]) {
        
        self.view.backgroundColor = self.girlColor;
    }
}

@end
