//
//  GGKUseCustomSymbolViewController.m
//  Perfect Potty
//
//  Created by Geoff Hom on 6/6/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKUseCustomSymbolViewController.h"

@interface GGKUseCustomSymbolViewController ()

@end

@implementation GGKUseCustomSymbolViewController

- (IBAction)saveSymbol
{
    self.perfectPottyModel.currentCustomSymbol = self.symbolTextField.text;
    [self.perfectPottyModel saveCustomSymbol];
    [self.delegate useCustomSymbolViewControllerDidChooseSymbol:self];
}

//- (void)textFieldDidEndEditing:(UITextField *)theTextField
//{    
//    // Should be only one character. If not, then set to previous value. Store the value.
//    
//    if ([theTextField.text length] == 1) {
//        
//        NSLog(@"length 1");
//    } else {
//        
//        NSLog(@"length:%d", [theTextField.text length]);
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Text field: Resize (can't change height with this border in storyboard). Use previous symbol.
    CGRect aFrameRect = self.symbolTextField.frame;
    aFrameRect.size.height = 60;
    self.symbolTextField.frame = aFrameRect;
    
    NSString *aSymbolString = self.perfectPottyModel.currentCustomSymbol;
    if (aSymbolString != nil) {
        
        self.symbolTextField.text = aSymbolString;
    }
}

@end
