//
//  DLILCacheManager.m
//
//  Created by Andrey Lunevich
//  Copyright 2013-2014 Andrey Lunevich. All rights reserved.

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "DLILCacheManager.h"
#import "DLILCache.h"

NSString * const CACHE_FILE = @"cache.txt";

#define	Documents [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface DLILCacheManager()

@property (nonatomic, strong) DLILCache *cache;

@end

@implementation DLILCacheManager

static DLILCacheManager *_sharedInstance = nil;

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [self loadCache];
        
        /* If scheme is not exist create new scheme */
        if (!self.cache) {
            self.cache = [[DLILCache alloc] init];
//            [self saveCache];
        }
    }
    return self;
}

#pragma mark -
#pragma mark - Save and Load cache

- (void)saveCache {
    NSData *objectsToSave = [NSKeyedArchiver archivedDataWithRootObject:self.cache];
    [objectsToSave writeToFile:[Documents stringByAppendingPathComponent:CACHE_FILE]
                    atomically:YES];
}

/** 
    Loads cache
    @return Saved cache
 */
- (DLILCache *)loadCache {
    NSData * objectsLoaded = [NSData dataWithContentsOfFile:[Documents stringByAppendingPathComponent:CACHE_FILE]];
    if (!objectsLoaded) {
        return nil;
    }else{
        return [NSKeyedUnarchiver unarchiveObjectWithData:objectsLoaded];
    }
}

- (NSData *)imageFromCache:(NSString *)url {
    return [self.cache.images valueForKey:url];
}

- (void)addNewImageToCache:(NSData *)image url:(NSString *)url {
    [self.cache.images setValue:image forKey:url];
}

- (void)deleteImageFromCache:(NSString *)url {
    [self.cache.images removeObjectForKey:url];
}

@end