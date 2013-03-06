//
//  GGKHistoryTableViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKHistoryForDayTableViewController.h"
#import "GGKHistoryHeaderCell.h"
#import "GGKHistoryTableViewController.h"
#import "GGKPottyAttemptDayTableViewCell.h"

@interface GGKHistoryTableViewController ()

// Minutes between the start and end times. For calculating the range of the timeline.
@property (assign, nonatomic) NSInteger endMinutesAfterStartTimeInteger;

// An array of all potty-attempt days. Each day is also an array.
@property (strong, nonatomic) NSArray *pottyAttemptDayArray;

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

// For calculating the time from the start time.
@property (strong, nonatomic) NSDateComponents *startTimeDateComponents;

// Check the saved data for potty attempts.
//- (void)updatePottyAttemptDayArray;

@end

@implementation GGKHistoryTableViewController

- (void)addPottyViewControllerDidAddPottyAttempt:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)historyForDayTableViewControllerDidDeleteAttempt:(id)sender
{
    GGKHistoryForDayTableViewController *aHistoryForDayTableViewController = (GGKHistoryForDayTableViewController *)sender;
    NSArray *theNewPottyAttemptArray = aHistoryForDayTableViewController.pottyAttemptArray;
    
    NSIndexPath *theIndexPath = [self.tableView indexPathForSelectedRow];
    NSInteger theRow = theIndexPath.row;
    
    // The first row is the last element in the data array.
    NSInteger theIndex = self.pottyAttemptDayArray.count - 1 - theRow;
    
    NSMutableArray *aMutableArray = [self.pottyAttemptDayArray mutableCopy];
    if ([theNewPottyAttemptArray count] == 0) {
        
        [aMutableArray removeObjectAtIndex:theIndex];
    } else {
        
        [aMutableArray replaceObjectAtIndex:theIndex withObject:theNewPottyAttemptArray];
    }
    self.pottyAttemptDayArray = [aMutableArray copy];
    
    // Save data.
    [[NSUserDefaults standardUserDefaults] setObject:self.pottyAttemptDayArray forKey:GGKPottyAttemptsKeyString];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (IBAction)playButtonSound
{
//    NSLog(@"HTVC playButtonSound1");
    [self.soundModel playButtonTapSound];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showAddPottyView"]) {
        
//        NSLog(@"HTVC prepareForSegue");
        [segue.destinationViewController setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"showHistoryForDay"]) {
        
        GGKHistoryForDayTableViewController *aHistoryForDayTableViewController = segue.destinationViewController;
        NSIndexPath *theIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger theRow = theIndexPath.row;
        
        // The first row is the last element in the data array.
        NSInteger theIndex = self.pottyAttemptDayArray.count - 1 - theRow;
        aHistoryForDayTableViewController.pottyAttemptArray = self.pottyAttemptDayArray[theIndex];
        
        aHistoryForDayTableViewController.delegate = self;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self playButtonSound];

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    NSLog(@"HTVC tV nORIS: %d", self.pottyAttemptDayArray.count);
    return self.pottyAttemptDayArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Header view, for iOS 5+ and storyboards. Since we can't have just a UIView in a storyboard, we're using a trick: make the header view in a prototype cell, then use the table view to create it.
    
    static NSString *CellIdentifier = @"HistoryHeaderCell";
    GGKHistoryHeaderCell *theHistoryHeaderCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // We don't want the entire cell, just its view. This will prevent touches from going under the header. Also, the view's background color will be clear by default, so we need to set that.
    UIView *theHeaderView = theHistoryHeaderCell.contentView;
    theHeaderView.backgroundColor = self.tableView.backgroundColor;
    
    // If no data to show, then hide the time labels.
    if (self.pottyAttemptDayArray.count == 0) {
        
        theHistoryHeaderCell.startMarkLabel.hidden = YES;
        theHistoryHeaderCell.endMarkLabel.hidden = YES;
    } else {
        
        theHistoryHeaderCell.startMarkLabel.hidden = NO;
        theHistoryHeaderCell.endMarkLabel.hidden = NO;
    }
    
    // The above trick (making the header view a cell) is … tricky. The cell seems to have a long-press gesture recognizer attached, so doing a long press on the header results in a crash. We'll look for that GR and remove it.
    if (theHeaderView.gestureRecognizers.count >= 1) {
        
        UIGestureRecognizer *aGestureRecognizer = (UIGestureRecognizer *)theHeaderView.gestureRecognizers[0];
        if ([aGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            
            [theHeaderView removeGestureRecognizer:aGestureRecognizer];
        }
    }
    
    return theHeaderView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.soundModel = [[GGKSoundModel alloc] init];
    
    // On 24-hour clock.
    NSInteger theStartHour = 6;
    NSInteger theEndHour = 22;
    
    NSDateComponents *aDateComponents = [[NSDateComponents alloc] init];
    [aDateComponents setHour:theStartHour];
    [aDateComponents setMinute:0];
    self.startTimeDateComponents = aDateComponents;
    
    self.endMinutesAfterStartTimeInteger = (theEndHour - theStartHour) * 60;
    
//    NSLog(@"HTVC vDL");

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Reload the data and refresh the table each time the view appears. This is just more robust. Data may have been added or deleted, but also the date may have changed, so relative dates (e.g. today) will change if displayed.
    // When the table is first being shown, we might think this would result in the table reloading its data twice. However, that doesn't seem to be the case, so that's good.
    self.pottyAttemptDayArray = [[NSUserDefaults standardUserDefaults] objectForKey:GGKPottyAttemptsKeyString];
    [self.tableView reloadData];
}

@end
