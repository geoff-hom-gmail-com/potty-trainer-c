//
//  GGKReward.m
//  Perfect Potty
//
//  Created by Geoff Hom on 8/24/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKReward.h"

@implementation GGKReward
- (void)deleteImage {
    NSFileManager *aFileManager = [[NSFileManager alloc] init];
    NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
    NSString *theImagePathComponentString = [NSString stringWithFormat:@"/%@.png", self.imageName];
    NSURL *theFileURL = [aDirectoryURL URLByAppendingPathComponent:theImagePathComponentString];
    [aFileManager removeItemAtURL:theFileURL error:nil];
    self.imageData = nil;
}
- (void)encodeWithCoder:(NSCoder *)encoder {    
    [encoder encodeObject:self.imageName forKey:@"imageName"];
    [encoder encodeInteger:self.numberOfSuccessesNeededInteger forKey:@"numberOfSuccessesNeededInteger"];
    [encoder encodeObject:self.text forKey:@"text"];
}
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.imageName = [decoder decodeObjectForKey:@"imageName"];
        self.numberOfSuccessesNeededInteger = [decoder decodeIntegerForKey:@"numberOfSuccessesNeededInteger"];
        self.text = [decoder decodeObjectForKey:@"text"];
    }
    return self;
}
- (void)loadImage {
    NSFileManager *aFileManager = [[NSFileManager alloc] init];
    NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
    NSString *theImagePathComponentString = [NSString stringWithFormat:@"/%@.png", self.imageName];
    NSURL *theFileURL = [aDirectoryURL URLByAppendingPathComponent:theImagePathComponentString];
    if ([aFileManager fileExistsAtPath:[theFileURL path]]) {
        self.imageData = [NSData dataWithContentsOfURL:theFileURL];
    };
}
- (void)saveImage {
    if (self.imageData != nil) {
        NSFileManager *aFileManager = [[NSFileManager alloc] init];
        // Not sure why not using NSApplicationSupportDirectory. But below should work.
        NSArray *aURLArray = [aFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *aDirectoryURL = (NSURL *)aURLArray[0];
        NSString *theImagePathComponentString = [NSString stringWithFormat:@"/%@.png", self.imageName];
        NSURL *theFileURL = [aDirectoryURL URLByAppendingPathComponent:theImagePathComponentString];
        [self.imageData writeToURL:theFileURL atomically:YES];
    }
}
@end
