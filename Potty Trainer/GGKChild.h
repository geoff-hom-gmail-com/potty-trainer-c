//
//  GGKChild.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGKChild : NSObject

// Child's name.
@property (strong, nonatomic) NSString *nameString;

// All the child's potty-attempt days.
@property (strong, nonatomic) NSArray *pottyAttemptDayArray;

// Child's rewards.
@property (strong, nonatomic) NSArray *rewardArray;

// Override.
- (void)encodeWithCoder:(NSCoder *)encoder;

// Override.
- (id)init;

// Override.
- (id)initWithCoder:(NSCoder *)decoder;

@end
