//
//  GGKAboutUsViewController.m
//  Perfect Potty Pal
//
//  Created by Geoff Hom on 3/5/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAboutUsViewController.h"

@interface GGKAboutUsViewController ()

@end

@implementation GGKAboutUsViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Height should match size of scroll view in the storyboard.
    self.scrollView.contentSize = CGSizeMake(320, 673);
}

@end
