//
//  GGKHistoryForDayTableViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/26/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGKHistoryForDayTableViewControllerDelegate

// Sent after a potty attempt was deleted.
- (void)historyForDayTableViewControllerDidDeleteAttempt:(id)sender;

@end

@interface GGKHistoryForDayTableViewController : UITableViewController

@property (weak, nonatomic) id <GGKHistoryForDayTableViewControllerDelegate> delegate;

// An array of potty attempts for a single day.
@property (strong, nonatomic) NSArray *pottyAttemptArray;

@end
