//
//  GGKPottyAttemptCell.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/26/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGKPottyAttemptCell : UITableViewCell

// For showing the result of the attempt.
@property (nonatomic, weak) IBOutlet UILabel *attemptLabel;

// A dictionary with the time and success of the attempt. See GGKSavedInfo.h for keys.
@property (nonatomic, strong) NSDictionary *pottyAttemptDictionary;

// For showing the time of the attempt. E.g., "4:20 PM."
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

// Show the attempt properly. (I.e., set as a check mark or as an X.)
- (void)showAttempt;

// Show this cell's time. E.g., "12:52 AM, 3:00 PM."
- (void)showTime;

@end
