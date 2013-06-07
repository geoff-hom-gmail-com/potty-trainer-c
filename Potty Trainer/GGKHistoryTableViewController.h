//
//  GGKHistoryTableViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAddPottyViewController.h"
#import "GGKHistoryForDayTableViewController.h"
#import <UIKit/UIKit.h>

@interface GGKHistoryTableViewController : UITableViewController <GGKAddPottyViewControllerDelegate, GGKHistoryForDayTableViewControllerDelegate>

- (void)addPottyViewControllerDidAddPottyAttempt:(id)sender;
// So, dismiss the view controller.

- (void)historyForDayTableViewControllerDidDeleteAttempt:(id)sender;
// So, get the updated data for that day. If nil, delete that day from the array. Else, put that updated data in the array.

// Play sound as aural feedback for pressing button.
- (IBAction)playButtonSound;

// UIViewController override.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
// So, return the header view.

// UIViewController override.
- (void)viewDidLoad;

// UIViewController override.
- (void)viewWillAppear:(BOOL)animated;

@end
