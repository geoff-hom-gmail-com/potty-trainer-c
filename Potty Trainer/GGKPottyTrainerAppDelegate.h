//
//  GGKPottyTrainerAppDelegate.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/4/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGKPottyTrainerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;
// So, check if the app was active. If so, show an alert similar to the notification.

@end
