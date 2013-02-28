//
//  GGKHistoryForDayTableViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/26/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKHistoryForDayTableViewController.h"
#import "GGKPottyAttemptCell.h"

@interface GGKHistoryForDayTableViewController ()

@end

@implementation GGKHistoryForDayTableViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Set the navigation-bar title.
    NSDictionary *aPottyAttemptDictionary = self.pottyAttemptArray[0];
    NSDate *aDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
    NSString *aDateString = [aDate monthDayString];
    self.navigationItem.title = [NSString stringWithFormat:@"History, %@", aDateString];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

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
    static NSString *CellIdentifier = @"PottyAttemptCell";
    GGKPottyAttemptCell *aPottyAttemptCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // The top row should be the last element in the array, then go backward.
    NSUInteger theRow = indexPath.row;
    NSInteger arrayIndex = self.pottyAttemptArray.count - 1 - theRow;
    NSDictionary *aPottyAttemptDictionary = self.pottyAttemptArray[arrayIndex];
    aPottyAttemptCell.pottyAttemptDictionary = aPottyAttemptDictionary;
    
    [aPottyAttemptCell showTime];
    [aPottyAttemptCell showAttempt];
    
    return aPottyAttemptCell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        // Delete the row from the data source. The top row should be the last element in the array, then go backward.
        NSUInteger theRow = indexPath.row;
        NSInteger arrayIndex = self.pottyAttemptArray.count - 1 - theRow;
        NSMutableArray *aMutableArray = [self.pottyAttemptArray mutableCopy];
        NSDictionary *aPottyAttemptDictionary = self.pottyAttemptArray[arrayIndex];
        [aMutableArray removeObject:aPottyAttemptDictionary];
        self.pottyAttemptArray = [aMutableArray copy];
        [self.delegate historyForDayTableViewControllerDidDeleteAttempt:self];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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
    return self.pottyAttemptArray.count;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
