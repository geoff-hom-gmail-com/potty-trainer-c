//
//  GGKPottyAttemptCell.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/26/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPottyAttemptCell.h"

@implementation GGKPottyAttemptCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showAttempt
{
    NSNumber *theAttemptWasSuccessfulBOOLNumber = self.pottyAttemptDictionary[GGKPottyAttemptWasSuccessfulNumberKeyString];
    BOOL theAttemptWasSuccessfulBOOL = [theAttemptWasSuccessfulBOOLNumber boolValue];
    NSString *theAttemptString;
    UIColor *theTextColor;
    if (theAttemptWasSuccessfulBOOL) {

        theAttemptString = @"\u2605";
        theTextColor = [UIColor greenColor];
    } else {
        
        theAttemptString = @"\u2718";
        theTextColor = [UIColor redColor];
    }
    self.attemptLabel.text = theAttemptString;
    self.attemptLabel.textColor = theTextColor;
}

- (void)showTime
{    
    NSDate *theDate = self.pottyAttemptDictionary[GGKPottyAttemptDateKeyString];
    self.timeLabel.text = [theDate hourMinuteAMPMString];
}

@end
