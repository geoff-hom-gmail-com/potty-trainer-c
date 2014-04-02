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

@class GGKSameValueSegmentedControl;

@interface GGKAddPottyViewController : GGKViewController <GGKUseCustomSymbolViewControllerDelegate, UIGestureRecognizerDelegate>
// For choosing the date of a potty attempt.
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
// The user may be adding a new potty attempt, or she may have selected a potty attempt to edit.
@property (strong, nonatomic) NSDictionary *pottyAttemptToEditDictionary;
// For choosing whether the attempt was successful or not.
@property (nonatomic, weak) IBOutlet UISegmentedControl *successfulSegmentedControl;
// For choosing the symbol for the attempt.
@property (nonatomic, weak) IBOutlet GGKSameValueSegmentedControl *symbolSameValueSegmentedControl;
// Adjust successfulness. If custom-symbol segment, then show the view for entering a custom symbol.
- (IBAction)handleSymbolSameValueSegmentedControlValueChanged:(GGKSameValueSegmentedControl *)theSymbolSameValueSegmentedControl;
// Override.
- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender;
// Add the potty attempt.
- (IBAction)savePottyAttempt;
// Dismiss the view controller. Update the segmented control.
- (void)useCustomSymbolViewControllerDidChooseSymbol:(id)sender;
// Override.
- (void)viewDidLoad;
@end
