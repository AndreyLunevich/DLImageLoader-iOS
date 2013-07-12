//
//  DLILCacheManager.m
//
//  Created by Andrey Lunevich on 7/9/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import "DLILCacheManager.h"
#import "DLILCache.h"

NSString * const CACHE_FILE = @"cache.txt";

#define	Documents [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface DLILCacheManager()

@property (nonatomic, strong) DLILCache *cache;

@end

@implementation DLILCacheManager

static DLILCacheManager *_sharedInstance = nil;

+ (DLILCacheManager *)sharedInstance {
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[DLILCacheManager alloc] init];
        }
    }
    return _sharedInstance;
}

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

/** Loads cache
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