//
//  GGKPottyTrainerAppDelegate.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/4/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPerfectPottyAppDelegate.h"

#import <AudioToolbox/AudioServices.h> 
#import "GGKInAppPurchaseObserver.h"
#import "TestFlight.h"

NSString *GGKAppName = @"Perfect Potty";

@interface GGKPerfectPottyAppDelegate ()

// Whether a local notification was already received a short time ago (currently a second).
@property (assign, nonatomic) BOOL localNotificationWasRecentlyReceived;

// Sound to play for a reminder alert.
@property (assign, nonatomic) SystemSoundID reminderSound;

// So, reset that flag.
- (void)noteThatLocalNotificationsNotReceivedRecently;

@end

@implementation GGKPerfectPottyAppDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:GGKAppName]) {
        
        AudioServicesDisposeSystemSoundID(_reminderSound);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"PTAD a dFLWO1");
    
    // Show splash image, then fade it out.
    // Get proper image: Check if non-retina. Else, check if 3.5" retina. Else, assume 4" retina.
    NSString *theImageFilename;
    if ([UIScreen mainScreen].scale == 1.0) {
        theImageFilename = @"Default.png";
    } else if ([UIScreen mainScreen].bounds.size.height == 480) {
        theImageFilename = @"Default@2x.png";
    } else {
        theImageFilename = @"Default-568h@2x.png";
    }
    UIImageView *anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:theImageFilename]];
    UIView *theRootView = self.window.rootViewController.view;
    anImageView.frame = theRootView.frame;
    [theRootView addSubview:anImageView];
    [theRootView bringSubviewToFront:anImageView];
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        anImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [anImageView removeFromSuperview];
    }];
    
#define TESTING 1
#ifdef TESTING
//    NSLog(@"identifierForVendor: %@", [[UIDevice currentDevice] identifierForVendor]);
//    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    [TestFlight takeOff:@"633c83d4-65be-4664-a051-6b63aca3fb7e"];
    NSLog(@"Name:%@", [[UIDevice currentDevice] name]);
    NSLog(@"Localized model:%@", [[UIDevice currentDevice] localizedModel]);
    NSLog(@"System name:%@; system version:%@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]);
    
    self.soundModel = [[GGKSoundModel alloc] init];
    self.perfectPottyModel = [[GGKPerfectPottyModel alloc] init];
    
    [self noteThatLocalNotificationsNotReceivedRecently];
    
    GGKInAppPurchaseObserver *theInAppPurchaseHelper = [[GGKInAppPurchaseObserver alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:theInAppPurchaseHelper];
    self.inAppPurchaseObserver = theInAppPurchaseHelper;
    
    return YES;
}

- (void)application:(UIApplication *)theApplication didReceiveLocalNotification:(UILocalNotification *)theNotification
{
    // There's a bug that can cause one notification to call this method twice. So we'll add a timer so this can get called only so often.
    NSLog(@"PTAD a dRLN");
    if (!self.localNotificationWasRecentlyReceived) {
        
        if (theApplication.applicationState == UIApplicationStateActive) {
            
            NSLog(@"PTAD a dRLN. app was running");
            UIAlertView *anAlertView = [[UIAlertView alloc] initWithTitle:GGKAppName message:theNotification.alertBody delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [anAlertView show];
            
            // Play an alert sound, too.
            // Using Audio Services to use the "Ringer and Alerts" volume (Settings app -> Sounds).
            NSString *soundFilePath = [ [NSBundle mainBundle] pathForResource:@"reminder1" ofType:@"aiff" ];            
            NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
            AudioServicesCreateSystemSoundID( (__bridge CFURLRef)soundFileURL, &_reminderSound);
            AudioServicesPlaySystemSound(_reminderSound);
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
