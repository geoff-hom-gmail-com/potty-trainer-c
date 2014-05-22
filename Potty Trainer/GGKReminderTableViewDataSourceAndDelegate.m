//
//  GGKReminderTableViewDataSourceAndDelegate.m
//  Perfect Potty
//
//  Created by Geoff Hom on 5/21/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKReminderTableViewDataSourceAndDelegate.h"

@implementation GGKReminderTableViewDataSourceAndDelegate
- (id)initWithTableView:(UITableView *)theTableView {
    self = [super init];
    if (self) {
        theTableView.dataSource = self;
        theTableView.delegate = self;
    }
    return self;
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath {
    static NSString *TheCellIdentifier = @"ReminderCell";
    UITableViewCell *aTableViewCell = [theTableView dequeueReusableCellWithIdentifier:TheCellIdentifier];
    aTableViewCell.textLabel.text = @"No reminders set";
    return aTableViewCell;
}
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)theSection {
    return 1;
}
@end
