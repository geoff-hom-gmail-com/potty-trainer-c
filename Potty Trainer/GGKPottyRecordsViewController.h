//
//  GGKPottyRecordsViewController.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/25/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKViewController.h"

#import "GGKAddPottyViewController.h"

@interface GGKPottyRecordsViewController : GGKViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addPottyButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Override.
- (void)handleViewWillAppearToUser;
// Override.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath;
// Play sound.
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)theIndexPath;
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)theSection;
// Override.
- (void)viewDidLoad;
@end
