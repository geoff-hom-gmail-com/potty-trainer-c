//
//  GGKAddPottyViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAddPottyViewController.h"

#import "NSDate+GGKDate.h"

@interface GGKAddPottyViewController ()
@end

@implementation GGKAddPottyViewController
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer");
    return YES;
}
//
- (void)handleSymbolSegmentedControlValueChanged {
    NSLog(@"handleSymbolSegmentedControlValueChanged");
}
//
- (void)handleCustomSymbolSegmentTapped {
    NSLog(@"handleCustomSymbolSegmentTapped");
}
- (IBAction)handleSymbolSegmentedControlTapped {
//    [self playButtonSound];
    NSLog(@"handleSymbolSegmentedControlTapped");

    // Adjust successfulness.
    NSInteger theSelectedSegmentIndex = self.symbolSegmentedControl.selectedSegmentIndex;
    NSString *theCurrentSegmentTitleString = [self.symbolSegmentedControl titleForSegmentAtIndex:theSelectedSegmentIndex];
    NSLog(@"selected segment:%@", theCurrentSegmentTitleString);
    // Assuming segment 0 = YES, 1 = NO.
    if ([theCurrentSegmentTitleString isEqualToString:GGKXSymbolString]) {
        self.successfulSegmentedControl.selectedSegmentIndex = 1;
    } else {
        self.successfulSegmentedControl.selectedSegmentIndex = 0;
    }
    
    // If the custom symbol was tapped, then show the view for entering a custom symbol.
    if (theSelectedSegmentIndex == 4) {
        [self performSegueWithIdentifier:@"ShowUseCustomSymbolView" sender:self];
    }
}
//- (IBAction)handleSymbolSegmentedControlTapped {
//    // play sound independently by connecting that method
////    [self playButtonSound];
//    [self.symbolSegmentedControl sendActionsForControlEvents:<#(UIControlEvents)#>
//    NSLog(@"handleSymbolSegmentedControlTapped");
//    
//    // Adjust successfulness.
//    NSInteger theSelectedSegmentIndex = self.symbolSegmentedControl.selectedSegmentIndex;
//    NSString *theCurrentSegmentTitleString = [self.symbolSegmentedControl titleForSegmentAtIndex:theSelectedSegmentIndex];
//    NSLog(@"selected segment:%@", theCurrentSegmentTitleString);
//    // Assuming segment 0 = YES, 1 = NO.
//    if ([theCurrentSegmentTitleString isEqualToString:GGKXSymbolString]) {
//        self.successfulSegmentedControl.selectedSegmentIndex = 1;
//    } else {
//        self.successfulSegmentedControl.selectedSegmentIndex = 0;
//    }
//    
//    // If the custom symbol was tapped, then show the view for entering a custom symbol.
//    if (theSelectedSegmentIndex == 4) {
//        [self performSegueWithIdentifier:@"ShowUseCustomSymbolView" sender:self];
//    }
//}
- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender {
    if ([theSegue.identifier hasPrefix:@"ShowUseCustomSymbolView"]) {
        GGKUseCustomSymbolViewController *aUseCustomSymbolViewController = [(UIStoryboardSegue *)theSegue destinationViewController];
        aUseCustomSymbolViewController.delegate = self;
    } else {
        [super prepareForSegue:theSegue sender:theSender];
    }
}
- (IBAction)savePottyAttempt {
    // Get new data.
    BOOL thePottyAttemptWasSuccessfulBOOL = NO;
    if (self.successfulSegmentedControl.selectedSegmentIndex == 0) {
        thePottyAttemptWasSuccessfulBOOL = YES;
    };
    NSDate *thePottyAttemptDate = self.datePicker.date;
    NSNumber *thePottyAttemptWasSuccessfulNumber = [NSNumber numberWithBool:thePottyAttemptWasSuccessfulBOOL];
    // Version without custom symbols.
//    NSDictionary *thePottyAttemptDictionary = @{GGKPottyAttemptDateKeyString:thePottyAttemptDate, GGKPottyAttemptWasSuccessfulNumberKeyString:thePottyAttemptWasSuccessfulNumber};
    // Get the selected symbol.
    NSString *thePottyAttemptSymbolString;
    NSInteger theSelectedSegmentIndex = self.symbolSegmentedControl.selectedSegmentIndex;
    // For "Pee" and "Both," replace with designated symbol.
    switch (theSelectedSegmentIndex) {
        case 0:
            thePottyAttemptSymbolString = GGKPeeSymbolString;
            break;
        case 2:
            thePottyAttemptSymbolString = GGKBothSymbolString;
            break;
        default:
            thePottyAttemptSymbolString = [self.symbolSegmentedControl titleForSegmentAtIndex:theSelectedSegmentIndex];
            break;
    }
    NSDictionary *thePottyAttemptDictionary = @{GGKPottyAttemptDateKeyString:thePottyAttemptDate, GGKPottyAttemptWasSuccessfulNumberKeyString:thePottyAttemptWasSuccessfulNumber, GGKPottyAttemptSymbolStringKeyString:thePottyAttemptSymbolString};
    // The model should handle the stuff below.
    if (self.pottyAttemptToEditDictionary == nil) {
        [self.perfectPottyModel addPottyAttempt:thePottyAttemptDictionary];
    } else {
        [self.perfectPottyModel replacePottyAttempt:self.pottyAttemptToEditDictionary withAttempt:thePottyAttemptDictionary];
        self.pottyAttemptToEditDictionary = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)useCustomSymbolViewControllerDidChooseSymbol:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    // Show symbol on segmented control.
    NSString *theMostRecentCustomSymbolString = self.perfectPottyModel.currentCustomSymbol;
    [self.symbolSegmentedControl setTitle:theMostRecentCustomSymbolString forSegmentAtIndex:4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.symbolSegmentedControl.apportionsSegmentWidthsByContent = YES;
    // Listen for taps on the symbol segmented control. We do this (instead of using the value-changed event) in case the user taps the same segment twice (e.g., the custom segment, to change the symbol).
    NSArray *aGestureRecognizerArray = self.successfulSegmentedControl.gestureRecognizers;
    NSLog(@"successfulSegmentedControl GRs: %d", [aGestureRecognizerArray count]);
    aGestureRecognizerArray = self.symbolSegmentedControl.gestureRecognizers;
    NSLog(@"symbolSegmentedControl GRs: %d", [aGestureRecognizerArray count]);
    // does this work in iOS 6 and 7? (Yes.)
    NSArray *aSubviewsArray = self.symbolSegmentedControl.subviews;
    NSLog(@"subviews: %d", [aSubviewsArray count]);
//    for (UIView *aView in aSubviewsArray) {
//        NSLog(@"subview class:%@", [[aView class] description]);
//        if ([aView isKindOfClass:[UIButton class]]) {
//            NSLog(@"found button");
////            [aGestureRecognizer addTarget:self action:@selector(handleSymbolSegmentedControlTapped)];
////            [aGestureRecognizer addTarget:self action:@selector(blah)];
////            [aGestureRecognizer addTarget:self action:@selector(argh:)];
////            [aGestureRecognizer removeTarget:nil action:NULL];
//        }
//    }
    UIView *aView = self.symbolSegmentedControl.subviews[4];
    NSLog(@"subview class:%@", [[aView class] description]);
    UITapGestureRecognizer *aTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCustomSymbolSegmentTapped)];
    aTapGestureRecognizer.cancelsTouchesInView = NO;
    aTapGestureRecognizer.delaysTouchesEnded = NO;
    [self.symbolSegmentedControl addTarget:self action:@selector(handleSymbolSegmentedControlValueChanged) forControlEvents:UIControlEventValueChanged];
//    aTapGestureRecognizer.delegate = self;
//    [aView addGestureRecognizer:aTapGestureRecognizer];
//    aView = self.symbolSegmentedControl.subviews[2];
//    [aView addGestureRecognizer:aTapGestureRecognizer];
//    [self.symbolSegmentedControl addGestureRecognizer:aTapGestureRecognizer];
    // Set the date picker not to allow future days.
    NSDate *aTodayDate = [NSDate date];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *aDateComponents = [gregorianCalendar components:unitFlags fromDate:aTodayDate];
    [aDateComponents setHour:23];
    [aDateComponents setMinute:59];
    NSDate *anEndOfTodayDate = [gregorianCalendar dateFromComponents:aDateComponents];
    self.datePicker.maximumDate = anEndOfTodayDate;
    // If editing a potty attempt, prepopulate the fields.
    if (self.pottyAttemptToEditDictionary != nil) {
        // Navigation-bar title.
        self.navigationItem.title = [NSString stringWithFormat:@"Edit Potty"];
        // Symbol.
        NSInteger theSelectedSegmentIndex;
        NSString *theSymbolString = self.pottyAttemptToEditDictionary[GGKPottyAttemptSymbolStringKeyString];
        if ([theSymbolString isEqualToString:GGKPeeSymbolString]) {
            theSelectedSegmentIndex = 0;
        } else if ([theSymbolString isEqualToString:GGKPooSymbolString]) {
            theSelectedSegmentIndex = 1;
        } else if ([theSymbolString isEqualToString:GGKBothSymbolString]) {
            theSelectedSegmentIndex = 2;
        } else if ([theSymbolString isEqualToString:GGKXSymbolString]) {
            theSelectedSegmentIndex = 3;
        } else {
            theSelectedSegmentIndex = 4;
            [self.symbolSegmentedControl setTitle:theSymbolString forSegmentAtIndex:4];
            self.perfectPottyModel.currentCustomSymbol = theSymbolString;
        }
        self.symbolSegmentedControl.selectedSegmentIndex = theSelectedSegmentIndex;
        // Successfulness.
        NSNumber *theAttemptWasSuccessfulBOOLNumber = self.pottyAttemptToEditDictionary[GGKPottyAttemptWasSuccessfulNumberKeyString];
        BOOL theAttemptWasSuccessfulBOOL = [theAttemptWasSuccessfulBOOLNumber boolValue];
        if (theAttemptWasSuccessfulBOOL) {
            theSelectedSegmentIndex = 0;
        } else {
            theSelectedSegmentIndex = 1;
        }
        self.successfulSegmentedControl.selectedSegmentIndex = theSelectedSegmentIndex;
        // Date.
        NSDate *thePottyAttemptDate = self.pottyAttemptToEditDictionary[GGKPottyAttemptDateKeyString];
        self.datePicker.date = thePottyAttemptDate;
    }
}
@end
