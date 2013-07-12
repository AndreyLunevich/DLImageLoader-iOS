//
//  DLILCache.m
//
//  Created by Andrey Lunevich on 7/9/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import "DLILCache.h"

NSString * const IMAGES = @"images";

@implementation DLILCache

- (id)init {
    self = [super init];
    if (self) {
        self.images = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark - Coding data

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.images forKey:IMAGES];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.images = [aDecoder decodeObjectForKey:IMAGES];
    }
    return self;
}

@end