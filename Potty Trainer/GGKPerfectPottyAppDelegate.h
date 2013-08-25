//
//  GGKPottyTrainerAppDelegate.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/4/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGKPerfectPottyModel.h"

@class GGKInAppPurchaseObserver, GGKSoundModel;

@interface GGKPerfectPottyAppDelegate : UIResponder <UIApplicationDelegate>

// For observing App Store transactions.
@property (strong, nonatomic) GGKInAppPurchaseObserver *inAppPurchaseObserver;

@property (strong, nonatomic) GGKPerfectPottyModel *perfectPottyModel;

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

@property (strong, nonatomic) UIWindow *window;

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;
// So, check if the app was active. If so, show an alert similar to the notification.

@end
