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

@interface DLILCacheManager()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation DLILCacheManager

+ (instancetype)sharedInstance
{
    static DLILCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.memoryCacheEnabled = YES;
        instance.diskCacheEnabled = YES;
        [[NSFileManager defaultManager] createDirectoryAtPath:[instance cacheDirectoryPath]
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
        
    });
    
    return instance;
}

- (void)setMemoryCacheEnabled:(BOOL)memoryCacheEnabled
{
    _memoryCacheEnabled = memoryCacheEnabled;
    
    if (memoryCacheEnabled) {
        self.cache = [[NSCache alloc] init];
    }
}

- (UIImage *)imageByKey:(NSString *)key
{
    UIImage *image = nil;
    if (self.memoryCacheEnabled) {
        image = [self.cache objectForKey:key];
    }
    
    if (!image && self.diskCacheEnabled) {
        image = [self imageFromDisk:key];
    }
    
    return image;
}

- (void)saveImage:(UIImage *)image byKey:(NSString *)key
{
    if (self.memoryCacheEnabled) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            if (image) {
                [weakSelf.cache setObject:image forKey:key];
            }
        });
    }
    if (self.diskCacheEnabled) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            if (image) {
                [weakSelf saveImageToDisk:image withKey:key];
            }
        });
    }
}

- (void)saveImageToDisk:(UIImage *)image withKey:(NSString *)key
{
    NSString *path = [self pathToImageWithKey:key];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];
}

- (UIImage *)imageFromDisk:(NSString *)key
{
    return [UIImage imageWithContentsOfFile:[self pathToImageWithKey:key]];
}

- (NSString *)pathToImageWithKey:(NSString *)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [self cacheDirectoryPath];
    NSArray *array = [key componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":/"]];
    for (int i = 0; i < array.count; i++) {
        NSString *s = array[i];
        if (s.length == 0) {
            continue;
        }
        path = [path stringByAppendingPathComponent:s];
        if (i != array.count -1 && ![fileManager fileExistsAtPath:path]) {
            [fileManager createDirectoryAtPath:path
                   withIntermediateDirectories:NO
                                    attributes:nil
                                         error:nil];
        }
    }
    
    return path;
}

- (NSString *)cacheDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    return [path stringByAppendingPathComponent:kCacheFolderName];
}

#pragma mark - clear methods

- (void)clear:(void (^)(BOOL))completed
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [weakSelf.cache removeAllObjects];
        BOOL success = YES;
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *directory = [weakSelf cacheDirectoryPath];
        NSArray *files = [fileManager contentsOfDirectoryAtPath:directory error:&error];
        if (!error) {
            for (NSString *file in files) {
                NSString *path = [directory stringByAppendingPathComponent:file];
                [fileManager removeItemAtPath:path error:&error];
                
                if (error) {
                    success = NO;
                }
            }
        } else {
            success = NO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            if (completed) {
                completed(success);
            }
        });
    });
}

@end
