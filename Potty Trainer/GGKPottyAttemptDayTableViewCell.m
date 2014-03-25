//
//  GGKPottyAttemptDayTableViewCell.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/24/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPottyAttemptDayTableViewCell.h"

#import "GGKPerfectPottyModel.h"
#import "NSDate+GGKDate.h"

@interface GGKPottyAttemptDayTableViewCell ()

@end

@implementation GGKPottyAttemptDayTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code. Doesn't seem to be called in this case.
        NSLog(@"PADTV iWS2");
    }
    return self;
}
- (void)showAttempts {
    // Remove extra labels (from previous uses of this cell).
    NSArray *defaultLabels = @[self.dateLabel, self.startMarkLabel, self.endMarkLabel, self.attempt1Label];
    [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *aView, NSUInteger idx, BOOL *stop) {
        if ([aView isKindOfClass:[UILabel class]] && ![defaultLabels containsObject:aView]) {
            // This works without crashing, because -subviews returns a copy of the array.
            [aView removeFromSuperview];
        }
    }];
    [self.pottyAttemptArray enumerateObjectsUsingBlock:^(NSDictionary *aPottyAttemptDictionary, NSUInteger idx, BOOL *stop) {
        NSNumber *theAttemptWasSuccessfulBOOLNumber = aPottyAttemptDictionary[GGKPottyAttemptWasSuccessfulNumberKeyString];
        BOOL theAttemptWasSuccessfulBOOL = [theAttemptWasSuccessfulBOOLNumber boolValue];
        NSString *theSymbolString = aPottyAttemptDictionary[GGKPottyAttemptSymbolStringKeyString];
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
        // Align label along timeline. If at or before the start time, put at start mark. If at or after the end time, put at end mark. Else, put between, at a proportionate amount.
        NSInteger startXInteger = self.startMarkLabel.center.x;
        NSInteger endXInteger = self.endMarkLabel.center.x;
        
        NSDate *aDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
        
        NSInteger minutesAfterStartTimeInteger = [aDate minutesAfterTime:self.startTimeDateComponents];
        NSInteger theNewCenterXInteger;
        if (minutesAfterStartTimeInteger < 0) {
            theNewCenterXInteger = startXInteger;
        } else if (minutesAfterStartTimeInteger > self.endMinutesAfterStartTimeInteger) {
            theNewCenterXInteger = endXInteger;
        } else {
            NSInteger theProportionalXInteger = (endXInteger - startXInteger) * minutesAfterStartTimeInteger / self.endMinutesAfterStartTimeInteger;
            theNewCenterXInteger = startXInteger + theProportionalXInteger;
        }
        NSLog(@"PADTVC showAttempts theNewCenterXInteger:%d", theNewCenterXInteger);
        if (idx == 0) {
            self.attempt1Label.text = theSymbolString;
            self.attempt1Label.center = CGPointMake(theNewCenterXInteger, self.attempt1Label.center.y);
            NSLog(@"PADTVC showAttempts theNewCenterXInteger:%f", self.attempt1Label.center.x);
            self.attempt1Label.textColor = theTextColor;
            //testing; trying to get the new center to work; instead, it keeps using the value in the storyboard
            // WILO
            // works; but fixing it messes up other labels...
            [self.attempt1Label removeFromSuperview];
            [self.contentView addSubview:self.attempt1Label];
        } else {
            UILabel *aNewLabel = [[UILabel alloc] initWithFrame:self.attempt1Label.frame];
            aNewLabel.opaque = NO;
            aNewLabel.backgroundColor = [UIColor clearColor];
            aNewLabel.textAlignment = NSTextAlignmentCenter;
            aNewLabel.text = theSymbolString;
            aNewLabel.textColor = theTextColor;
            aNewLabel.center = CGPointMake(theNewCenterXInteger, aNewLabel.center.y);
            NSLog(@"PADTVC showAttempts theNewCenterXInteger:%f", aNewLabel.center.x);
            [self.contentView addSubview:aNewLabel];
        }
    }];
}
- (void)showDate {
    NSDictionary *aPottyAttemptDictionary = self.pottyAttemptArray[0];
    NSDate *theDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
    self.dateLabel.text = [theDate monthDayString];
}
@end
