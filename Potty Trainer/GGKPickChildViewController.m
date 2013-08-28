//
//  GGKPickChildViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/28/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKPickChildViewController.h"

@interface GGKPickChildViewController ()

@end

@implementation GGKPickChildViewController

- (void)editChildNameViewControllerDidCancel:(id)sender
{
    [sender dismissViewControllerAnimated:YES completion:nil];
}

- (void)editChildNameViewControllerDidEnterText:(id)sender
{
    ;
}

- (IBAction)editName
{
    GGKEditChildNameViewController *editChildNameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GGKEditChildNameViewController"];
    editChildNameViewController.delegate = self;
    [self presentViewController:editChildNameViewController animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChildNameCell";
    UITableViewCell *aTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    GGKChild *aChild = self.perfectPottyModel.childrenMutableArray[indexPath.row];
    aTableViewCell.textLabel.text = aChild.nameString;
    
    return aTableViewCell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)theIndexPath
{
    self.editNameButton.enabled = YES;
    self.removeChildButton.enabled = YES;
    self.selectChildButton.enabled = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.perfectPottyModel.childrenMutableArray count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.editNameButton.enabled = NO;
    self.removeChildButton.enabled = NO;
    self.selectChildButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set height of table. This is also done in the storyboard and has been sufficient in other cases, but not here. (Don't know why. May be an Autolayout or 4-inch iPhone issue.)
    CGRect frameRect = self.childNamesTableView.frame;
    frameRect.size.height = 220;
    self.childNamesTableView.frame = frameRect;
}

@end
