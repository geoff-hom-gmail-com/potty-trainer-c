//
//  GGKAddPottyViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKUseCustomSymbolViewController.h"
#import <UIKit/UIKit.h>

@protocol GGKAddPottyViewControllerDelegate

// Sent after a potty attempt has been added.
- (void)addPottyViewControllerDidAddPottyAttempt:(id)sender;

@end

@interface GGKAddPottyViewController : GGKViewController <GGKUseCustomSymbolViewControllerDelegate>

// For choosing the date of a potty attempt.
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) id <GGKAddPottyViewControllerDelegate> delegate;

// For choosing the symbol for the attempt.
@property (nonatomic, weak) IBOutlet UISegmentedControl *symbolSegmentedControl;

// For choosing whether the attempt was successful or not.
@property (nonatomic, weak) IBOutlet UISegmentedControl *successfulSegmentedControl;

// Override.
- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender;

// Add the potty attempt.
- (IBAction)savePottyAttempt;

- (void)useCustomSymbolViewControllerDidChooseSymbol:(id)sender;
// So, dismiss the view controller. Update the segmented control.

// Override.
- (void)viewDidLoad;

// Override.
- (void)viewWillAppear:(BOOL)animated;

@end
