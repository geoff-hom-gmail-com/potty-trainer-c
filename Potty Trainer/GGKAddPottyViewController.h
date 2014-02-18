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

@interface GGKAddPottyViewController : GGKViewController <GGKUseCustomSymbolViewControllerDelegate>
// For choosing the date of a potty attempt.
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
// The user may be adding a new potty attempt, or she may have selected a potty attempt to edit.
@property (strong, nonatomic) NSDictionary *pottyAttemptToEditDictionary;
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
@end
