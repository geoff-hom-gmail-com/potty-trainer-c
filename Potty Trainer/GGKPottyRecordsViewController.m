//
//  GGKPottyRecordsViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/25/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPottyRecordsViewController.h"

#import "GGKHistoryForDayTableViewController.h"
#import "GGKPottyAttemptDayTableViewCell.h"
#import "NSDate+GGKDate.h"

@interface GGKPottyRecordsViewController ()

// Index path for the row/day being examined. For viewing attempts for a single day.
@property (strong, nonatomic) NSIndexPath *currentRowIndexPath;

// Minutes between the start and end times. For calculating the range of the timeline.
@property (assign, nonatomic) NSInteger endMinutesAfterStartTimeInteger;

@property (strong, nonatomic) NSArray *pottyAttemptDayArray;

// For calculating the time from the start time.
@property (strong, nonatomic) NSDateComponents *startTimeDateComponents;

@end

@implementation GGKPottyRecordsViewController
- (void)handleViewWillAppearToUser {
    [super handleViewWillAppearToUser];
    // Reload the data and refresh the table each time the view appears. This is simply more robust. Data may have been added or deleted, but also the date may have changed, so relative dates (e.g. today) will change if displayed.
    // When the table is first being shown, we might think this would result in the table reloading its data twice. However, that doesn't seem to be the case, so that's good.
    GGKChild *currentChild = self.perfectPottyModel.currentChild;
    NSString *buttonTitleString = [NSString stringWithFormat:@"Add Potty for %@", currentChild.nameString];
    [self.addPottyButton setTitle:buttonTitleString forState:UIControlStateNormal];
    self.pottyAttemptDayArray = currentChild.pottyAttemptDayArray;
    [self.tableView reloadData];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showHistoryForDaySegue"]) {
        // Sender is the cell tapped.
        GGKPottyAttemptDayTableViewCell *aPottyAttemptDayTableViewCell = (GGKPottyAttemptDayTableViewCell *)sender;
        NSUInteger theIndex = [self.pottyAttemptDayArray indexOfObject:aPottyAttemptDayTableViewCell.pottyAttemptArray];
        self.perfectPottyModel.currentChild.dayIndex = theIndex;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PottyAttemptDayCell";
    GGKPottyAttemptDayTableViewCell *aPottyAttemptDayTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    aPottyAttemptDayTableViewCell.startTimeDateComponents = self.startTimeDateComponents;
    aPottyAttemptDayTableViewCell.endMinutesAfterStartTimeInteger = self.endMinutesAfterStartTimeInteger;
    
    // The top row should be the last element in the array, then go backward.
    NSUInteger theRow = indexPath.row;
    NSInteger arrayIndex = self.pottyAttemptDayArray.count - 1 - theRow;
    NSArray *aPottyAttemptArray = self.pottyAttemptDayArray[arrayIndex];
    aPottyAttemptDayTableViewCell.pottyAttemptArray = aPottyAttemptArray;
    
    // If a day is for today, show that specifically. Else, use the normal date formatting.
    NSDictionary *aPottyAttemptDictionary = aPottyAttemptArray[0];
    NSDate *aPottyAttemptDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
    
    if ([aPottyAttemptDate dateIsToday]) {
        aPottyAttemptDayTableViewCell.dateLabel.text = @"Today";
    } else {
        [aPottyAttemptDayTableViewCell showDate];
    }
    [aPottyAttemptDayTableViewCell showAttempts];
    return aPottyAttemptDayTableViewCell;
}
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)theIndexPath {
    [self playButtonSound];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.pottyAttemptDayArray count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    // On 24-hour clock.
    NSInteger theStartHour = 6;
    NSInteger theEndHour = 22;
    
    NSDateComponents *aDateComponents = [[NSDateComponents alloc] init];
    [aDateComponents setHour:theStartHour];
    [aDateComponents setMinute:0];
    self.startTimeDateComponents = aDateComponents;
    
    self.endMinutesAfterStartTimeInteger = (theEndHour - theStartHour) * 60;
}
@end
