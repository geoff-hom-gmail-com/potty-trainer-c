//
//  GGKPottyAttemptDayTableViewCell.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/24/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGKPottyAttemptDayTableViewCell : UITableViewCell

// For showing an attempt.
@property (nonatomic, weak) IBOutlet UILabel *attempt1Label;

// For showing the date of the potty attempts. E.g., "2/22, Fri."
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

// For marking the end time of the range shown.
@property (nonatomic, weak) IBOutlet UILabel *endMarkLabel;

// Minutes between the start and end times. For calculating the range of the timeline.
@property (assign, nonatomic) NSInteger endMinutesAfterStartTimeInteger;

// An array of the potty attempts for this date.
@property (nonatomic, strong) NSArray *pottyAttemptArray;

// For marking the start time of the range shown.
@property (nonatomic, weak) IBOutlet UILabel *startMarkLabel;

// For calculating the time from the start time.
@property (strong, nonatomic) NSDateComponents *startTimeDateComponents;

// Show the day's attempts properly. This includes removing unused extra labels, adding extra labels if necessary, assigning success/not labels correctly, and aligning the labels visually.
- (void)showAttempts;

// Show this cell's date. We want to show only the month and day (e.g., Feb 23).
- (void)showDate;

@end
