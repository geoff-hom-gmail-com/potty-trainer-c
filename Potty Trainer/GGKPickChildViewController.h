//
//  GGKPickChildViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/28/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKEditChildNameViewController.h"

@interface GGKPickChildViewController : GGKViewController <GGKEditChildNameViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *editNameButton;

@property (strong, nonatomic) IBOutlet UIButton *removeChildButton;

@property (strong, nonatomic) IBOutlet UIButton *selectChildButton;

@property (strong, nonatomic) IBOutlet UITableView *childNamesTableView;

- (void)editChildNameViewControllerDidCancel:(id)sender;
// So, dismiss it.

- (void)editChildNameViewControllerDidEnterText:(id)sender;
// So: If duplicate name, alert user. Else, change name. Re-sort child array.

// Show view for editing child's name.
- (IBAction)editName;

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath;

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)theIndexPath;
// So, enable/disable buttons accordingly.

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)theSection;

// Override.
- (void)viewDidLoad;

// Override.
- (void)viewWillAppear:(BOOL)animated;

@end
