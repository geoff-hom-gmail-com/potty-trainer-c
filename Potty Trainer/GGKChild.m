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

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.nameString forKey:@"nameString"];
    [encoder encodeObject:self.pottyAttemptDayArray forKey:@"pottyAttemptDayArray"];
    [encoder encodeObject:self.rewardArray forKey:@"rewardArray"];
    [encoder encodeInteger:self.uniqueIDInteger forKey:@"uniqueIDInteger"];
}

- (id)initWithUniqueID:(NSInteger)uniqueIDInteger
{
    self = [super init];
    if (self) {
        
        self.uniqueIDInteger = uniqueIDInteger;
        
        self.nameString = @"Anonymous";
        
        self.pottyAttemptDayArray = [NSArray array];
        
        GGKReward *aReward1 = [[GGKReward alloc] init];
        aReward1.numberOfSuccessesNeededInteger = 5;
        aReward1.imageName = [NSString stringWithFormat:@"%ld_reward1", (long)self.uniqueIDInteger];
        GGKReward *aReward2 = [[GGKReward alloc] init];
        aReward2.numberOfSuccessesNeededInteger = 10;
        aReward2.imageName = [NSString stringWithFormat:@"%ld_reward2", (long)self.uniqueIDInteger];
        GGKReward *aReward3 = [[GGKReward alloc] init];
        aReward3.numberOfSuccessesNeededInteger = 15;
        aReward3.imageName = [NSString stringWithFormat:@"%ld_reward3", (long)self.uniqueIDInteger];
        self.rewardArray = @[aReward1, aReward2, aReward3];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {

        self.nameString = [decoder decodeObjectForKey:@"nameString"];
        self.pottyAttemptDayArray = [decoder decodeObjectForKey:@"pottyAttemptDayArray"];
        self.rewardArray = [decoder decodeObjectForKey:@"rewardArray"];
        self.uniqueIDInteger = [decoder decodeIntegerForKey:@"uniqueIDInteger"];
    }
    return self;
}

@end
