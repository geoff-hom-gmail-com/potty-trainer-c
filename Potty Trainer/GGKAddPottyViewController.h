//
//  GGKAddPottyViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGKAddPottyViewControllerDelegate

// Sent after a potty attempt has been added.
- (void)addPottyViewControllerDidAddPottyAttempt:(UIViewController *)theViewController;

@end

@interface GGKAddPottyViewController : UIViewController

// For choosing the date of a potty attempt.
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) id <GGKAddPottyViewControllerDelegate> delegate;

// For choosing whether the attempt was successful or not.
@property (nonatomic, weak) IBOutlet UISegmentedControl *successfulSegmentedControl;

// Play sound as aural feedback for pressing button.
- (IBAction)playButtonSound;

// Add the potty attempt.
- (IBAction)savePottyAttempt;

// UIViewController override.
- (void)viewDidLoad;

// UIViewController override.
- (void)viewWillAppear:(BOOL)animated;

@end
