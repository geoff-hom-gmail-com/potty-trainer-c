//
//  GGKReward.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/24/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKReward.h"

@implementation GGKReward

- (void)encodeWithCoder:(NSCoder *)encoder
{    
    [encoder encodeObject:self.imageName forKey:@"imageName"];
    [encoder encodeInteger:self.numberOfSuccessesNeededInteger forKey:@"numberOfSuccessesNeededInteger"];
    [encoder encodeObject:self.text forKey:@"text"];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.text = @"Add Reward";
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        
        self.imageName = [decoder decodeObjectForKey:@"imageName"];
        self.numberOfSuccessesNeededInteger = [decoder decodeIntegerForKey:@"numberOfSuccessesNeededInteger"];
        self.text = [decoder decodeObjectForKey:@"text"];
    }
    return self;
}

@end
