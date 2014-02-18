//
//  GGKPottyRecordsViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/25/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKAddPottyViewController.h"
#import "GGKHistoryForDayTableViewController.h"

@interface GGKPottyRecordsViewController : GGKViewController <GGKHistoryForDayTableViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addPottyButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Override.
- (void)handleViewWillAppearToUser;
//- (void)historyForDayTableViewControllerDidDeleteAttempt:(id)sender;
// So, get the updated data for that day. If nil, delete that day from the array. Else, put that updated data in the array.

// Override.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
// So, play sound.

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath;

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)theSection;

// Override.
- (void)viewDidLoad;
@end
