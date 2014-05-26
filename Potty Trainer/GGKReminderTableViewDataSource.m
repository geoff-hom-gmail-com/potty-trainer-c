//
//  GGKReminderTableViewDataSource.m
//  Perfect Potty
//
//  Created by Geoff Hom on 5/21/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

#import "GGKReminderTableViewDataSource.h"

#import "NSDate+GGKDate.h"
@implementation GGKReminderTableViewDataSource
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
    NSArray *theLocalNotificationsArray = [UIApplication sharedApplication].scheduledLocalNotifications;
    if ([theLocalNotificationsArray count] == 0) {
        aTableViewCell.textLabel.text = @"No reminders added";
    } else {
        UILocalNotification *aLocalNotification = theLocalNotificationsArray[theIndexPath.row];
        aTableViewCell.textLabel.text = [aLocalNotification.fireDate hourMinuteAMPMString];
    }
    return aTableViewCell;
}
- (void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)theEditingStyle forRowAtIndexPath:(NSIndexPath *)theIndexPath {
    // Delete corresponding reminder.
    NSArray *theLocalNotificationsArray = [UIApplication sharedApplication].scheduledLocalNotifications;
    UILocalNotification *aLocalNotification = theLocalNotificationsArray[theIndexPath.row];
    [[UIApplication sharedApplication] cancelLocalNotification:aLocalNotification];
    // Animate changes, then notify delegate (to update rest of UI).
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self.delegate reminderTableViewDataSourceDidDeleteRow:self];
    }];
    [theTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [CATransaction commit];
}
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)theSection {
    NSUInteger theNumberOfLocalNotificationsInteger = [[UIApplication sharedApplication].scheduledLocalNotifications count];
    if (theNumberOfLocalNotificationsInteger == 0) {
        theNumberOfLocalNotificationsInteger = 1;
    }
    return theNumberOfLocalNotificationsInteger;
}
@end
