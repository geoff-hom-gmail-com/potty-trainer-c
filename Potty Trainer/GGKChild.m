//
//  GGKChild.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKChild.h"

#import "GGKReward.h"

@implementation GGKChild

- (id)init
{
    self = [super init];
    if (self) {
        
        self.nameString = @"Anon";
        
        self.pottyAttemptDayArray = [NSArray array];
        
        GGKReward *aReward1 = [[GGKReward alloc] init];
        aReward1.numberOfSuccessesNeededInteger = 5;
        aReward1.imageName = [NSString stringWithFormat:@"%@_reward1", self.nameString];
        GGKReward *aReward2 = [[GGKReward alloc] init];
        aReward2.numberOfSuccessesNeededInteger = 10;
        aReward2.imageName = [NSString stringWithFormat:@"%@_reward2", self.nameString];
        GGKReward *aReward3 = [[GGKReward alloc] init];
        aReward3.numberOfSuccessesNeededInteger = 15;
        aReward3.imageName = [NSString stringWithFormat:@"%@_reward3", self.nameString];
        self.rewardArray = @[aReward1, aReward2, aReward3];
    }
    return self;
}

@end
