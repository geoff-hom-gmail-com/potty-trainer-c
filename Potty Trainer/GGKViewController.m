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
// To remove the observer later.
@property (strong, nonatomic) id appDidEnterBackgroundObserver;
@property (strong, nonatomic) id appWillEnterForegroundObserver;
@end

@implementation GGKViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.appWillEnterForegroundObserver name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.appDidEnterBackgroundObserver name:UIApplicationDidEnterBackgroundNotification object:nil];
    // No need to call super.
}
- (void)handleViewDidDisappearFromUser {
    //    NSLog(@"VC hVDDFU");
}
- (void)handleViewWillAppearToUser {
//    NSLog(@"VC hVATU1");
}
- (IBAction)playButtonSound {
    GGKPerfectPottyAppDelegate *aPottyTrainerAppDelegate = (GGKPerfectPottyAppDelegate *)[UIApplication sharedApplication].delegate;
    [aPottyTrainerAppDelegate.soundModel playButtonTapSound];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self handleViewDidDisappearFromUser];
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GGKPerfectPottyAppDelegate *theAppDelegate = (GGKPerfectPottyAppDelegate *)[UIApplication sharedApplication].delegate;
    self.perfectPottyModel = theAppDelegate.perfectPottyModel;
    self.musicModel = theAppDelegate.musicModel;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self handleViewWillAppearToUser];
    // Using a weak variable to avoid a strong-reference cycle.
    GGKViewController * __weak aWeakSelf = self;
    self.appWillEnterForegroundObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [aWeakSelf handleViewWillAppearToUser];
    }];
    self.appDidEnterBackgroundObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [aWeakSelf handleViewDidDisappearFromUser];
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self.appWillEnterForegroundObserver name:UIApplicationWillEnterForegroundNotification object:nil];
    self.appWillEnterForegroundObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self.appDidEnterBackgroundObserver name:UIApplicationDidEnterBackgroundNotification object:nil];
    self.appDidEnterBackgroundObserver = nil;
}
@end
