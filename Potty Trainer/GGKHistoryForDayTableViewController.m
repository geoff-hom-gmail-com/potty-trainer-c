//
//  GGKHistoryForDayTableViewController.m
//  Potty Trainer
//
//  Created by Geoff Hom on 2/26/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKHistoryForDayTableViewController.h"

#import "GGKAddPottyViewController.h"
#import "GGKPerfectPottyAppDelegate.h"
#import "GGKPottyAttemptCell.h"
#import "NSDate+GGKDate.h"

@interface GGKHistoryForDayTableViewController ()
// For removing the observer later.
@property (strong, nonatomic) id appWillEnterForegroundObserver;
// The user can select a potty attempt to edit. For sending to the add-potty view for editing.
@property (strong, nonatomic) NSDictionary *pottyAttemptToEditDictionary;
// The "Edit" button in a cell was tapped. Find that row and notify the table view's delegate.
- (void)handleEditCellButtonTapped:(id)sender event:(id)event;
@end

@implementation GGKHistoryForDayTableViewController
- (void)handleEditCellButtonTapped:(id)sender event:(id)event {
    NSSet *theTouchesSet = [event allTouches];
    UITouch *aTouch = [theTouchesSet anyObject];
    CGPoint theCurrentTouchPosition = [aTouch locationInView:self.tableView];
    NSIndexPath *theIndexPath = [self.tableView indexPathForRowAtPoint:theCurrentTouchPosition];
    if (theIndexPath != nil) {
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:theIndexPath];
    }
}
- (void)handleViewWillAppearToUser {
    //    NSLog(@"VC hVATU1");
    // Reload the data and refresh the table each time the view appears. This is simply more robust. Data may have been added or deleted, but also the date may have changed, so relative dates (e.g. today) will change if displayed.
    // When the table is first being shown, we might think this would result in the table reloading its data twice. However, that doesn't seem to be the case, so that's good.
    NSUInteger theIndex = self.perfectPottyModel.currentChild.dayIndex;
    self.pottyAttemptArray = self.perfectPottyModel.currentChild.pottyAttemptDayArray[theIndex];
    [self.tableView reloadData];
    // Set the navigation-bar title.
    NSDictionary *aPottyAttemptDictionary = self.pottyAttemptArray[0];
    NSDate *aDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
    NSString *aDateString = [aDate monthDayString];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", aDateString];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowEditPottyAttemptSegue"]) {
        GGKAddPottyViewController *anAddPottyViewController = segue.destinationViewController;
        anAddPottyViewController.pottyAttemptToEditDictionary = self.pottyAttemptToEditDictionary;
    }
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSUInteger theRow = indexPath.row;
    NSInteger arrayIndex = self.pottyAttemptArray.count - 1 - theRow;
    NSDictionary *aPottyAttemptToEditDictionary = self.pottyAttemptArray[arrayIndex];
    self.pottyAttemptToEditDictionary = aPottyAttemptToEditDictionary;
    [self performSegueWithIdentifier:@"ShowEditPottyAttemptSegue" sender:self];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PottyAttemptCell";
    GGKPottyAttemptCell *aPottyAttemptCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // The top row should be the last element in the array, then go backward.
    NSUInteger theRow = indexPath.row;
    NSInteger arrayIndex = self.pottyAttemptArray.count - 1 - theRow;
    NSDictionary *aPottyAttemptDictionary = self.pottyAttemptArray[arrayIndex];
    aPottyAttemptCell.pottyAttemptDictionary = aPottyAttemptDictionary;
    [aPottyAttemptCell showTime];
    [aPottyAttemptCell showAttempt];
    // Add a custom "Edit" button as the editing accessory view.
    UIButton *anEditButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [anEditButton addTarget:self action:@selector(handleEditCellButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    [anEditButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [anEditButton setTitle:@"Edit" forState:UIControlStateNormal];
    [anEditButton sizeToFit];
    anEditButton.frame = CGRectMake(0, 0, anEditButton.frame.size.width, 40);
//    NSLog(@"frame:%@", NSStringFromCGRect(anEditButton.frame));
    aPottyAttemptCell.editingAccessoryView = anEditButton;
    return aPottyAttemptCell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        GGKPottyAttemptCell *thePottyAttemptCell = (GGKPottyAttemptCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSDictionary *thePottyAttemptDictionary = thePottyAttemptCell.pottyAttemptDictionary;
        NSMutableArray *aMutableArray = [self.pottyAttemptArray mutableCopy];
        [aMutableArray removeObject:thePottyAttemptDictionary];
        self.pottyAttemptArray = [aMutableArray copy];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.perfectPottyModel removePottyAttempt:thePottyAttemptDictionary];
        
//        The top row should be the last element in the array, then go backward.

//        NSUInteger theRow = indexPath.row;
//        NSInteger arrayIndex = self.pottyAttemptArray.count - 1 - theRow;
//        NSMutableArray *aMutableArray = [self.pottyAttemptArray mutableCopy];
//        NSDictionary *aPottyAttemptDictionary = self.pottyAttemptArray[arrayIndex];
//        [self.perfectPottyModel removePottyAttempt:aPottyAttemptDictionary];
//        [aMutableArray removeObject:aPottyAttemptDictionary];
//        self.pottyAttemptArray = [aMutableArray copy];
//        [self.delegate historyForDayTableViewControllerDidDeleteAttempt:self];
        
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.pottyAttemptArray.count;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView setEditing:YES animated:NO];
    GGKPerfectPottyAppDelegate *theAppDelegate = (GGKPerfectPottyAppDelegate *)[UIApplication sharedApplication].delegate;
    self.perfectPottyModel = theAppDelegate.perfectPottyModel;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self handleViewWillAppearToUser];
    // Using a weak variable to avoid a strong-reference cycle.
    GGKHistoryForDayTableViewController * __weak aWeakSelf = self;
    self.appWillEnterForegroundObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [aWeakSelf handleViewWillAppearToUser];
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self.appWillEnterForegroundObserver name:UIApplicationWillEnterForegroundNotification object:nil];
    self.appWillEnterForegroundObserver = nil;
}



//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    // Set the navigation-bar title.
//    NSDictionary *aPottyAttemptDictionary = self.pottyAttemptArray[0];
//    NSDate *aDate = aPottyAttemptDictionary[GGKPottyAttemptDateKeyString];
//    NSString *aDateString = [aDate monthDayString];
//    self.navigationItem.title = [NSString stringWithFormat:@"%@", aDateString];
//}
@end
