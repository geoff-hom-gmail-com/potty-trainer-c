//
//  GGKPottyAttemptDayTableViewCell.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/24/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPottyAttemptDayTableViewCell.h"

@interface GGKPottyAttemptDayTableViewCell ()

@end

@implementation GGKPottyAttemptDayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code. Doesn't seem to be called in this case.
        NSLog(@"PADTV iWS2");
//        self.backgroundColor = [UIColor whiteColor];
//        self.opaque = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showAttempts
{
    static NSString *CheckMarkString = @"\u2714";
    static NSString *XMarkString = @"\u2718";
     
//    NSLog(@"PADTVC updateAttemptLabels");
    
    // Remove extra labels (from previous uses of this cell).
    NSArray *defaultLabels = @[self.dateLabel, self.startMarkLabel, self.endMarkLabel, self.attempt1Label];
    [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *aView, NSUInteger idx, BOOL *stop) {
        
        if ([aView isKindOfClass:[UILabel class]] && ![defaultLabels containsObject:aView]) {
            
            // This should work without crashing, because -subviews returns a copy of the array?
            [aView removeFromSuperview];
        }
    }];
    
    [self.pottyAttemptArray enumerateObjectsUsingBlock:^(NSDictionary *aPottyAttemptDictionary, NSUInteger idx, BOOL *stop) {
        
        // Assign success label.
        NSNumber *theAttemptWasSuccessfulBOOLNumber = aPottyAttemptDictionary[GGKPottyAttemptWasSuccessfulNumberKeyString];
        BOOL theAttemptWasSuccessfulBOOL = [theAttemptWasSuccessfulBOOLNumber boolValue];
        NSString *theAttemptString;
        if (theAttemptWasSuccessfulBOOL) {
            
            theAttemptString = CheckMarkString;
        } else {
            
            theAttemptString = XMarkString;
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
        
        if (idx == 0) {
            
            self.attempt1Label.text = theAttemptString;
            self.attempt1Label.center = CGPointMake(theNewCenterXInteger, self.attempt1Label.center.y);            
        } else {
            
            UILabel *aNewLabel = [[UILabel alloc] initWithFrame:self.attempt1Label.frame];
            aNewLabel.opaque = NO;
            aNewLabel.backgroundColor = [UIColor clearColor];
            aNewLabel.textAlignment = UITextAlignmentCenter;
            aNewLabel.text = theAttemptString;
            aNewLabel.center = CGPointMake(theNewCenterXInteger, aNewLabel.center.y);
            [self.contentView addSubview:aNewLabel];
        }
    }];
}

- (void)showDate
{
    NSDictionary *aPottyAttemptDictionary = self.pottyAttemptArray[0];
    NSDate *theDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
    self.dateLabel.text = [theDate monthDayString];
}

@end
