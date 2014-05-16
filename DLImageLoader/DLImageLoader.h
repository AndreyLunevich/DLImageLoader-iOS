//
//  DLImageLoader.h
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

@interface DLImageLoader : NSObject

/**
 DLImageLoader logger
 Default value YES
 **/
@property (nonatomic) BOOL isDLILLogEnabled;

/**
 Instance method
 @return shared instance.
 */
+ (DLImageLoader *)sharedInstance;

/**
 Load image from url
 @param urlString The url of image.
 @param completed Completed is a completion block that will call after image loading.
 */
- (void)loadImageFromUrl:(NSString *)urlString
               completed:(void(^)(NSError *error, UIImage *image))completed;

/**
 Load image from url
 @param urlString The url of image.
 @param completed Completed is a completion block that will call after image loading.
 @param canceled Canceled is a block that will if loading opedation was calceled.
 */
- (void)loadImageFromUrl:(NSString *)urlString
               completed:(void(^)(NSError *error, UIImage *image))completed
                canceled:(void(^)())canceled;

/**
 Load image from url
 @param urlString The url of image.
 @param imageView UIImageView in which will display image.
 */
- (void)displayImageFromUrl:(NSString *)urlString
                  imageView:(UIImageView *)imageView;

/**
 Stop all active operations
 */
- (void)stopDataLoading;

@end