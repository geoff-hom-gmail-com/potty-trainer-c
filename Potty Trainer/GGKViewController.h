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
- (void)dealloc;
// The view disappeared from the user, so stop any repeating updates.
// A view disappears from the user in two ways: 1) the app makes the view appear/disappear and 2) the app  enters the background (go to home screen, another app or screen lock). -viewDidDisappear: is called for 1). UIApplicationDidEnterBackgroundNotification is sent for 2). To have a consistent UI, both will call this method. Subclasses should call super and override.
// The background notification can be received independent of a VC's visibility (i.e., position in the nav stack). To prevent this, we'll add the observer in -viewWillAppear: and remove it in -viewWillDisappear:.
- (void)handleViewDidDisappearFromUser;
// The view will appear to the user, so ensure it's up to date.
// A view appears in two ways: 1) the app makes the view appear/disappear and 2) the app enters the foreground (from the home screen, another app or screen lock). -viewWillAppear: is called for 1). UIApplicationWillEnterForegroundNotification is sent for 2). To have a consistent UI, both will call this method. Subclasses should call super and override.
// The foreground notification can be received independent of a VC's visibility (i.e., position in the nav stack). To prevent this, we'll add the observer in -viewWillAppear: and remove it in -viewWillDisappear:.
- (void)handleViewWillAppearToUser;
// Play sound as aural feedback for pressing button.
- (IBAction)playButtonSound;
// Override.
- (void)viewDidDisappear:(BOOL)animated;
// Override.
- (void)viewDidLoad;
// Override.
- (void)viewWillAppear:(BOOL)animated;
// Override.
- (void)viewWillDisappear:(BOOL)animated;
@end
