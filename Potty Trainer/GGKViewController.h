//
//  GGKViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 6/6/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGKMusicModel.h"
#import "GGKPerfectPottyModel.h"

@interface GGKViewController : UIViewController

@property (strong, nonatomic) GGKMusicModel *musicModel;
@property (strong, nonatomic) GGKPerfectPottyModel *perfectPottyModel;

// Override.
// Assume Nib is for portrait orientation.
- (void)awakeFromNib;
// Override.
- (void)dealloc;
// The view appeared to the user, so ensure it's up to date.
// A view can appear to the user in two ways: appearing from within the app, or the app was in the background and now enters the foreground. -viewWillAppear: is called for the former but not the latter. UIApplicationWillEnterForegroundNotification is sent for the latter but not the former. To have a consistent UI, we'll have both options call -handleViewWillAppearToUser. So, subclasses should call super and override.
// The foreground notification is received when opening a backgrounded app, and when returning from screen lock.
// The foreground notification may be received by a VC whose view isn't visible (e.g., not top of nav stack). To prevent unexpected updates, we'll add the observer in -viewWillAppear: and remove it in -viewWillDisappear:.
- (void)handleViewWillAppearToUser;
// Play sound as aural feedback for pressing button.
- (IBAction)playButtonSound;

// Story: When the user should see the UI in landscape, she does.
// Stub.
- (void)updateLayoutForLandscape;

// Story: When the user should see the UI in portrait, she does.
// Stub.
- (void)updateLayoutForPortrait;

// Override.
- (void)viewDidLoad;
// Override.
- (void)viewWillAppear:(BOOL)animated;
// Override.
- (void)viewWillDisappear:(BOOL)animated;
// Override.
// Story: Whether user rotates device in the app, or from the home screen, this method will be called. User sees UI in correct orientation.
- (void)viewWillLayoutSubviews;
@end
