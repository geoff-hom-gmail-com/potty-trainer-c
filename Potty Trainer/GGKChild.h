//
//  GGKChild.h
//  Perfect Potty
//
//  Created by Geoff Hom on 8/23/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGKChild : NSObject
// The index of the potty-attempt day to show when viewing a single day.
@property (assign, nonatomic) NSUInteger dayIndex;
// Child's name.
@property (strong, nonatomic) NSString *nameString;

// All the child's potty-attempt days.
@property (strong, nonatomic) NSArray *pottyAttemptDayArray;

// Child's rewards.
@property (strong, nonatomic) NSArray *rewardArray;

// A number guaranteed not to be used by another child. For assigning filenames, etc.
// The Child class itself doesn't assign the ID. The class managing children should assign and guarantee the IDs.
@property (assign, nonatomic) NSInteger uniqueIDInteger;

// Override.
- (void)encodeWithCoder:(NSCoder *)encoder;

// Designated initializer.
- (id)initWithUniqueID:(NSInteger)uniqueIDInteger;

// Override.
//- (id)init;

// Override.
- (id)initWithCoder:(NSCoder *)decoder;

@end
