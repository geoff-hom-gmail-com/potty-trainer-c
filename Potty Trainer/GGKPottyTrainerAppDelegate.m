//
//  GGKPottyTrainerAppDelegate.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/4/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPottyTrainerAppDelegate.h"

@interface GGKPottyTrainerAppDelegate ()

// Whether a local notification was already received a short time ago (currently a second).
@property (assign, nonatomic) BOOL localNotificationWasRecentlyReceived;

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

// So, reset that flag.
- (void)noteThatLocalNotificationsNotReceivedRecently;

@end

@implementation GGKPottyTrainerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"PTAD a dFLWO");
    self.soundModel = [[GGKSoundModel alloc] init];
    
    [self noteThatLocalNotificationsNotReceivedRecently];
    
    return YES;
}

- (void)application:(UIApplication *)theApplication didReceiveLocalNotification:(UILocalNotification *)theNotification
{
    // There's a bug that can cause one notification to call this method twice. So we'll add a timer so this can get called only so often.
    NSLog(@"PTAD a dRLN");
    if (!self.localNotificationWasRecentlyReceived) {
        
        if (theApplication.applicationState == UIApplicationStateActive) {
            
            NSLog(@"PTAD a dRLN. app was running");
            NSString *theAppName = @"Potty Trainer";
            UIAlertView *anAlertView = [[UIAlertView alloc] initWithTitle:theAppName message:theNotification.alertBody delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [anAlertView show];
            
            // Play an alert sound, too.
            [self.soundModel playDingSound];
        }
        self.localNotificationWasRecentlyReceived = YES;
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(noteThatLocalNotificationsNotReceivedRecently) userInfo:nil repeats:NO];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)noteThatLocalNotificationsNotReceivedRecently
{
    self.localNotificationWasRecentlyReceived = NO;
}

@end
