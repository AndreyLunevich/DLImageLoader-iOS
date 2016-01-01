//
//  DLILCacheManager.h
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

#import <Foundation/Foundation.h>

@interface DLILCacheManager : NSObject

/**
 Memory cache
 @param memoryCacheEnabled by default is YES
 **/
@property (nonatomic) BOOL memoryCacheEnabled;

/**
 Disk cache
 @param diskCacheEnabled by default is YES
 **/
@property (nonatomic) BOOL diskCacheEnabled;

/**
 DLILCacheManager instance
 **/
+ (instancetype)sharedInstance;

/**
 Get the image from the cache by the key.
 At first will try to get image from memory cache
 If image will not found, will try to get image from disk cache
 @param key. Key of image in cache.
 */
- (UIImage *)imageByKey:(NSString *)key;

/**
 Save the image in the cache for the key.
 @param image. UIImage to save in cache.
 @param key. Key of image in cache.
 */
- (void)saveImage:(UIImage *)image byKey:(NSString *)key;

/**
 Clear memory and disk cache
 */
- (void)clear:(void(^)(BOOL success))completed;

@end
