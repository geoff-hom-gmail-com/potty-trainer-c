//
//  GGKHistoryForDayTableViewController.h
//  Potty Trainer
//
//  Created by Geoff Hom on 2/26/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGKPerfectPottyModel.h"

@protocol GGKHistoryForDayTableViewControllerDelegate

// Sent after a potty attempt was deleted.
- (void)historyForDayTableViewControllerDidDeleteAttempt:(id)sender;

@end

@interface GGKHistoryForDayTableViewController : UITableViewController

@property (weak, nonatomic) id <GGKHistoryForDayTableViewControllerDelegate> delegate;
@property (strong, nonatomic) GGKPerfectPottyModel *perfectPottyModel;
// An array of potty attempts for a single day.
@property (strong, nonatomic) NSArray *pottyAttemptArray;
// The view appeared to the user, so ensure it's up to date.
// A view can appear to the user in two ways: appearing from within the app, or the app was in the background and now enters the foreground. -viewWillAppear: is called for the former but not the latter. UIApplicationWillEnterForegroundNotification is sent for the latter but not the former. To have a consistent UI, we'll have both options call -handleViewWillAppearToUser. So, subclasses should call super and override.
// The foreground notification is received when opening a backgrounded app, and when returning from screen lock.
// The foreground notification may be received by a VC whose view isn't visible (e.g., not top of nav stack). To prevent unexpected updates, we'll add the observer in -viewWillAppear: and remove it in -viewWillDisappear:.
// Get current day to show. Show it.
- (void)handleViewWillAppearToUser;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
// Prepare for segue. Could be add-potty view for editing.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
// The editing accesory button was tapped. So, show a view so the user may edit that potty attempt.
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
// Override.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
// Override.
- (void)viewDidLoad;
// Override.
- (void)viewWillAppear:(BOOL)animated;
// Override.
- (void)viewWillDisappear:(BOOL)animated;
@end
