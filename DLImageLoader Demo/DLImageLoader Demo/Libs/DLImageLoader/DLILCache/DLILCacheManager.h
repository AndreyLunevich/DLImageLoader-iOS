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
 memory cache
 @param memoryCacheEnabled by default is YES
 **/
@property (nonatomic, readonly, getter = isMemoryCacheEnabled) BOOL memoryCacheEnabled;

/**
 disk cache
 @param diskCacheEnabled by default is YES
 **/
@property (nonatomic, readonly, getter = isDiskCacheEnabled) BOOL diskCacheEnabled;

+ (instancetype)sharedInstance;

- (void)setCacheInMemory:(BOOL)enabled;

- (void)setCacheInDisk:(BOOL)enabled;

- (UIImage *)imageByKey:(NSString *)key;

- (void)performWithImage:(UIImage *)image andKey:(NSString *)key;

@end