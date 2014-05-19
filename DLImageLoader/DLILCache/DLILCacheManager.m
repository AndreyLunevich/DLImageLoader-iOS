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

static NSString *kCacheFolderName = @"DLILCacheFolder";

@interface DLILCacheManager() {
    NSCache *cache;
}

@end

@implementation DLILCacheManager

+ (instancetype)sharedInstance
{
    static DLILCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
        instance->cache = [NSCache new];
        instance->_memoryCacheEnabled = YES;
        instance->_diskCacheEnabled = YES;
        [[NSFileManager defaultManager] createDirectoryAtPath:[instance directory]
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
        
    });
    return instance;
}

- (UIImage *)imageByKey:(NSString *)key
{
    UIImage *image = nil;
    if (_memoryCacheEnabled) {
        image = [cache objectForKey:key];
    }
    if (!image) {
        if (_diskCacheEnabled) {
            image = [self imageFromDisk:key];
        }
    }
    return image;
}

- (void)performWithImage:(UIImage *)image andKey:(NSString *)key
{
    if (_memoryCacheEnabled) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            if (image) {
                [cache setObject:image forKey:key];
            }
        });
    }
    if (_diskCacheEnabled) {
        __block typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [weakSelf saveToSandBoxImage:image withKey:key];
        });
    }
}

- (void)saveToSandBoxImage:(UIImage *)image withKey:(NSString *)key
{
    NSString *path = [self pathToImageWithKey:key];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];
}

- (UIImage *)imageFromDisk:(NSString *)key
{
    NSString *path = [self pathToImageWithKey:key];
    return [UIImage imageWithContentsOfFile:path];
}

- (NSString *)pathToImageWithKey:(NSString *)key
{
    NSString *path = [self directory];
    NSArray *array = [key componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":/"]];
    for (int i = 0; i < array.count; i++) {
        NSString *s = array[i];
        if ([s isEqualToString:@""]) continue;
        
        path = [path stringByAppendingPathComponent:s];
        if (i != array.count -1) {
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:path
                                          withIntermediateDirectories:NO
                                                           attributes:nil
                                                                error:nil];
            }
        }
    }
    return path;
}

- (NSString *)directory
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [path stringByAppendingPathComponent:kCacheFolderName];
}

#pragma mark -
#pragma mark - Cache

- (void)setCacheInMemory:(BOOL)enabled
{
    _memoryCacheEnabled = enabled;
}

- (void)setCacheInDisk:(BOOL)enabled
{
    _diskCacheEnabled = enabled;
}

@end