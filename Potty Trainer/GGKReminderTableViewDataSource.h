//
//  GGKReminderTableViewDataSource.h
//  Perfect Potty
//
//  Created by Geoff Hom on 5/21/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GGKReminderTableViewDataSourceDelegate
// Sent after a row was deleted.
- (void)reminderTableViewDataSourceDidDeleteRow:(id)sender;
@end
@interface GGKReminderTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) id <GGKReminderTableViewDataSourceDelegate> delegate;
// Designated initializer. Sets table view's data source and delegate.
- (id)initWithTableView:(UITableView *)theTableView;
// One row per notification. If none, one row to note that.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath;
// Delete that row's reminder. Notify delegate.
- (void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)theEditingStyle forRowAtIndexPath:(NSIndexPath *)theIndexPath;
// Number of local notifications.
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)theSection;
@end

