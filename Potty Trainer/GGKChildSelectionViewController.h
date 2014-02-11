//
//  GGKPickChildViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/28/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKEditChildNameViewController.h"

@interface GGKChildSelectionViewController : GGKViewController <GGKEditChildNameViewControllerDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

// Name of the current child.
@property (weak, nonatomic) IBOutlet UILabel *currentChildLabel;

@property (weak, nonatomic) IBOutlet UITableView *childNamesTableView;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
// So: If it was for removing a child, and user said OK, then remove that child.

- (void)editChildNameViewControllerDidCancel:(id)sender;
// So, dismiss it.

- (void)editChildNameViewControllerDidEnterText:(id)sender;
// So: If duplicate name, alert user. Else, change name. Re-sort child array.

// Show view for editing child's name.
- (IBAction)editName;
// Override.
- (void)handleViewAppearedToUser;
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath;

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)theIndexPath;
// So: Make that the current child.

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)theSection;

// Verify that user wants to remove selected child.
- (IBAction)verifyRemoveChild:(id)sender;

// Override.
- (void)viewDidLoad;
@end
