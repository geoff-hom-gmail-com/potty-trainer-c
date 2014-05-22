//
//  GGKReminderTableViewDataSourceAndDelegate.h
//  Perfect Potty
//
//  Created by Geoff Hom on 5/21/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGKReminderTableViewDataSourceAndDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>
// Designated initializer. Sets table view's data source and delegate.
- (id)initWithTableView:(UITableView *)theTableView;
// One row per notification. If none, one row to note that.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath;
// Number of local notifications.
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)theSection;
@end
