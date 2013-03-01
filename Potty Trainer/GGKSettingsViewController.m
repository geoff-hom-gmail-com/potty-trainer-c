//
//  GGKSettingsViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/21/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKSettingsViewController.h"

@interface GGKSettingsViewController ()

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

// Update UI for a reminder existing already.
- (void)updateForAReminder:(UILocalNotification *)theLocalNotification;

// Update UI for no reminder set yet.
- (void)updateForNoReminder;

@end

@implementation GGKSettingsViewController

- (void)alertView:(UIAlertView *)theAlertView clickedButtonAtIndex:(NSInteger)theButtonIndex
{
    if ([[theAlertView buttonTitleAtIndex:theButtonIndex] isEqualToString:@"OK"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:GGKPottyAttemptsKeyString];
    }
}

- (IBAction)cancelReminder
{
    // delete all local notifications for this app
    ;
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSetReminderView"]) {
        
        [segue.destinationViewController setDelegate:self];
    }
}

- (IBAction)resetHistory
{
    // Put the cancel button on the right, since this is a potentially risky action.
    UIAlertView *anAlertView = [[UIAlertView alloc] initWithTitle:@"Delete potty history?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", @"Cancel", nil];
    anAlertView.cancelButtonIndex = 1;
    [anAlertView show];
}

- (void)setReminderViewControllerDidSetReminder:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateForAReminder:(UILocalNotification *)theLocalNotification
{
    // may need to start a timer (at least somewhere) to update this text.
    // need to get the fire date = time to show
    // and need to calculate hours/min from now
    NSCalendar *aGregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit aHourMinuteCalendarUnit = NSMinuteCalendarUnit | NSHourCalendarUnit;
    NSDate *theReminderDate = theLocalNotification.fireDate;
    NSDateComponents *theReminderIncrementDateComponents = [aGregorianCalendar components:aHourMinuteCalendarUnit fromDate:theReminderDate toDate:[NSDate date] options:0];

    NSLog(@"reminder h:%d m:%d time:%@", theReminderIncrementDateComponents.hour, theReminderIncrementDateComponents.minute, [theReminderDate description]);
//    NSLog(@"reminder2 date:%@", [theReminderDate descriptionWithLocale:nil]);
    NSLog(@"reminder3 date:%@", [NSDateFormatter localizedStringFromDate:theReminderDate dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle]);
    self.reminderLabel.text = @"A reminder is set for\nx hours, y mins from now (10:35 AM).";
    
    self.cancelButton.enabled = YES;
    [self.setOrChangeReminderButton setTitle:@"Change Reminder" forState:UIControlStateNormal];
}

- (void)updateForNoReminder
{
    self.reminderLabel.text = @"There is currently\nno reminder.";
    self.cancelButton.enabled = NO;
    [self.setOrChangeReminderButton setTitle:@"Set Reminder" forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.soundModel = [[GGKSoundModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Check for an existing reminder.
    NSArray *theLocalNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    if (theLocalNotifications.count == 0) {
        
        [self updateForNoReminder];
    } else {
        
        [self updateForAReminder:theLocalNotifications[0]];
    }
}

@end
