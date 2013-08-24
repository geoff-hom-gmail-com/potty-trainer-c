//
//  GGKViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 6/6/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKPerfectPottyAppDelegate.h"
#import "GGKSoundModel.h"

@interface GGKViewController ()

// For removing the observer later.
@property (strong, nonatomic) id appWillEnterForegroundObserver;

// Story: The overall orientation (device/status-bar) is checked against the orientation of this app's UI. The user sees the UI in the correct orientation.
// Whether the landscape view is currently showing.
@property (nonatomic, assign) BOOL isShowingLandscapeView;

@end

@implementation GGKViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.isShowingLandscapeView = NO;
}

- (IBAction)playButtonSound
{
    [GGKSoundModel playButtonTapSound];
}

- (void)updateLayoutForLandscape
{
    //    NSLog(@"updateLayoutForLandscape");
}

- (void)updateLayoutForPortrait
{
    //    NSLog(@"updateLayoutForPortrait");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    GGKPerfectPottyAppDelegate *theAppDelegate = (GGKPerfectPottyAppDelegate *)[UIApplication sharedApplication].delegate;
    self.perfectPottyModel = theAppDelegate.perfectPottyModel;
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    
    if (self.appWillEnterForegroundObserver == nil) {
        
        self.appWillEnterForegroundObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            
            [self viewWillAppear:animated];
        }];
    }
    
    // Update the view here. (I.e., in subclass.)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.appWillEnterForegroundObserver != nil) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self.appWillEnterForegroundObserver name:UIApplicationWillEnterForegroundNotification object:nil];
        self.appWillEnterForegroundObserver = nil;
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Using status-bar orientation, not device orientation. Seems to work.
    UIInterfaceOrientation theInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(theInterfaceOrientation) && !self.isShowingLandscapeView) {
        
        [self updateLayoutForLandscape];
        self.isShowingLandscapeView = YES;
    } else if (UIInterfaceOrientationIsPortrait(theInterfaceOrientation) && self.isShowingLandscapeView) {
        
        [self updateLayoutForPortrait];
        self.isShowingLandscapeView = NO;
    }
}

@end
