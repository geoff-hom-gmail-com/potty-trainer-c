//
//  GGKReminderTableViewDataSourceAndDelegate.m
//  Perfect Potty
//
//  Created by Geoff Hom on 5/21/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKReminderTableViewDataSourceAndDelegate.h"

#import "NSDate+GGKDate.h"
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
    // if these aren't in order, we have to sort them.....
    NSArray *theLocalNotificationsArray = [UIApplication sharedApplication].scheduledLocalNotifications;
    if ([theLocalNotificationsArray count] == 0) {
        aTableViewCell.textLabel.text = @"No reminders added";
    } else {
        UILocalNotification *aLocalNotification = theLocalNotificationsArray[theIndexPath.row];
        aTableViewCell.textLabel.text = [aLocalNotification.fireDate hourMinuteAMPMString];
    }
    return aTableViewCell;
}
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)theSection {
    NSUInteger theNumberOfLocalNotificationsInteger = [[UIApplication sharedApplication].scheduledLocalNotifications count];
    if (theNumberOfLocalNotificationsInteger == 0) {
        theNumberOfLocalNotificationsInteger = 1;
    }
    return theNumberOfLocalNotificationsInteger;
}
@end
