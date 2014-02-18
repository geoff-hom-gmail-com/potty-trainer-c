//
//  GGKPottyAttemptCell.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/26/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPottyAttemptCell.h"

#import "GGKPerfectPottyModel.h"
#import "NSDate+GGKDate.h"

@implementation GGKPottyAttemptCell
- (void)showAttempt
{
    NSNumber *theAttemptWasSuccessfulBOOLNumber = self.pottyAttemptDictionary[GGKPottyAttemptWasSuccessfulNumberKeyString];
    BOOL theAttemptWasSuccessfulBOOL = [theAttemptWasSuccessfulBOOLNumber boolValue];
    NSString *theSymbolString = self.pottyAttemptDictionary[GGKPottyAttemptSymbolStringKeyString];
    
    // Version 1.0.4 and before had no symbol stored. In that case, it was a star or an X.
    if (theSymbolString == nil) {
        
        if (theAttemptWasSuccessfulBOOL) {
            
            theSymbolString = GGKStarSymbolString;
        } else {
            
            theSymbolString = GGKXSymbolString;
        }
    }
    
    UIColor *theTextColor;
    if (theAttemptWasSuccessfulBOOL) {
        
        theTextColor = [UIColor greenColor];
    } else {
        
        theTextColor = [UIColor redColor];
    }
    
    self.attemptLabel.text = theSymbolString;
    self.attemptLabel.textColor = theTextColor;
}

- (void)showTime
{    
    NSDate *theDate = self.pottyAttemptDictionary[GGKPottyAttemptDateKeyString];
    self.timeLabel.text = [theDate hourMinuteAMPMString];
}

@end
