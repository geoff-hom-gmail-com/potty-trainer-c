//
//  GGKHistoryHeaderCell.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/25/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGKHistoryHeaderCell : UITableViewCell

// For marking the end time of the range shown.
@property (nonatomic, weak) IBOutlet UILabel *endMarkLabel;

// For marking the start time of the range shown.
@property (nonatomic, weak) IBOutlet UILabel *startMarkLabel;

@end
