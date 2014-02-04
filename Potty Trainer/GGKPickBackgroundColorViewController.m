//
//  GGKPickBackgroundColorViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/19/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPickBackgroundColorViewController.h"

#import "UIColor+GGKColors.h"

@interface GGKPickBackgroundColorViewController ()

// The color to use for a boy theme.
@property (strong, nonatomic) UIColor *boyColor;

// The color to use for a girl theme.
@property (strong, nonatomic) UIColor *girlColor;

// Update the colors according to the current theme.
- (void)updateColors;

@end

@implementation GGKPickBackgroundColorViewController

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

- (void)updateColors
{
    // Check theme.
//    NSString *theThemeString = [[NSUserDefaults standardUserDefaults] objectForKey:GGKThemeKeyString];
    NSString *theThemeString = self.perfectPottyModel.colorThemeString;
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
    self.perfectPottyModel.colorThemeString = GGKBoyThemeString;
    [self.perfectPottyModel saveColorTheme];
//    [[NSUserDefaults standardUserDefaults] setObject:GGKBoyThemeString forKey:GGKThemeKeyString];
    [self updateColors];
}

- (IBAction)useDefaultTheme
{
    self.perfectPottyModel.colorThemeString = nil;
    [self.perfectPottyModel saveColorTheme];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:GGKThemeKeyString];
    [self updateColors];
}

- (IBAction)useGirlTheme
{
    self.perfectPottyModel.colorThemeString = GGKGirlThemeString;
    [self.perfectPottyModel saveColorTheme];
//    [[NSUserDefaults standardUserDefaults] setObject:GGKGirlThemeString forKey:GGKThemeKeyString];
    [self updateColors];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.boyColor = [UIColor cyanColor];
//    self.girlColor = [UIColor pinkColor];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self updateColors];
}

@end
