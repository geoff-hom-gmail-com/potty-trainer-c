//
//  GGKUseCustomSymbolViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 6/6/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKUseCustomSymbolViewController.h"

@interface GGKUseCustomSymbolViewController ()

@end

@implementation GGKUseCustomSymbolViewController

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{    
    // Should be only one character. If not, then set to previous value. Store the value.
    
    if ([theTextField.text length] == 1) {
        
        NSLog(@"length 1");
    } else {
        
        NSLog(@"length:%d", [theTextField.text length]);
    }
    
//    NSInteger anOkayInteger = -1;
//    NSString *theKey;
//    
//    NSInteger theCurrentInteger = [theTextField.text length integerValue];
//    if (theTextField == self.numberOfTimeUnitsToInitiallyWaitTextField) {
//        
//        anOkayInteger = [NSNumber ggk_integerBoundedByRange:theCurrentInteger minimum:GGKTakeDelayedPhotosMinimumNumberOfTimeUnitsToInitiallyWaitInteger maximum:self.maximumNumberOfTimeUnitsToInitiallyWaitInteger];
//        theKey = self.numberOfTimeUnitsToInitiallyWaitKeyString;
//    } else if (theTextField == self.numberOfPhotosToTakeTextField) {
//        
//        anOkayInteger = [NSNumber ggk_integerBoundedByRange:theCurrentInteger minimum:GGKTakeDelayedPhotosMinimumNumberOfPhotosInteger maximum:self.maximumNumberOfPhotosInteger];
//        theKey = self.numberOfPhotosToTakeKeyString;
//    } else if (theTextField == self.numberOfTimeUnitsBetweenPhotosTextField) {
//        
//        anOkayInteger = [NSNumber ggk_integerBoundedByRange:theCurrentInteger minimum:GGKTakeDelayedPhotosMinimumNumberOfTimeUnitsBetweenPhotosInteger maximum:self.maximumNumberOfTimeUnitsBetweenPhotosInteger];
//        theKey = self.numberOfTimeUnitsBetweenPhotosKeyString;
//    }
//    
//    // Set the new value, then update.
//    [[NSUserDefaults standardUserDefaults] setInteger:anOkayInteger forKey:theKey];
//    [self getSavedTimerSettings];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Text field: Resize (can't change height with this border in storyboard). Use previous symbol.
    CGRect aFrameRect = self.symbolTextField.frame;
    aFrameRect.size.height = 60;
    self.symbolTextField.frame = aFrameRect;
    
    NSString *aSymbolString = [[NSUserDefaults standardUserDefaults] stringForKey:GGKMostRecentCustomSymbolStringKeyString];
    if (aSymbolString != nil) {
        
        self.symbolTextField.text = aSymbolString;
    }
}

@end
